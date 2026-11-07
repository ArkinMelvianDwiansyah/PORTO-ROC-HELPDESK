$blocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

New-Item -ItemType Directory -Force -Path "rendered_notes" | Out-Null

function Get-RichText($prop) {
    if (-not $prop) { return "" }
    $out = ""
    foreach ($chunk in $prop) {
        $text = $chunk[0]
        if ($chunk.Count -gt 1) {
            foreach ($annot in $chunk[1]) {
                $type = $annot[0]
                switch ($type) {
                    "b" { $text = "**" + $text + "**" }
                    "i" { $text = "*" + $text + "*" }
                    "s" { $text = "~~" + $text + "~~" }
                    "c" { $text = "``" + $text + "``" }
                    "a" { 
                        $url = $annot[1]
                        $text = "[" + $text + "](" + $url + ")" 
                    }
                }
            }
        }
        $out += $text
    }
    return $out
}

function Render-Block-Markdown($id, $depth, [System.Collections.Generic.List[string]]$lines, $visited) {
    if ($visited.Contains($id)) { return }
    $visited.Add($id) | Out-Null
    
    $b = $blockMap[$id]
    if (-not $b) {
        $lines.Add(("  " * $depth) + "[Missing block " + $id + "]")
        return
    }
    
    $indent = "  " * $depth
    $type = $b.type
    $title = ""
    if ($b.properties -and $b.properties.title) {
        $title = Get-RichText $b.properties.title
    }
    
    switch ($type) {
        "page" {
            if ($depth -eq 0) {
                $lines.Add("# " + $title)
                $lines.Add("")
            } else {
                $lines.Add($indent + "- **[Subpage: " + $title + "]** (Page ID: " + $b.id + ")")
            }
        }
        "header" {
            $lines.Add("")
            $lines.Add($indent + "# " + $title)
            $lines.Add("")
        }
        "sub_header" {
            $lines.Add("")
            $lines.Add($indent + "## " + $title)
            $lines.Add("")
        }
        "sub_sub_header" {
            $lines.Add("")
            $lines.Add($indent + "### " + $title)
            $lines.Add("")
        }
        "text" {
            if ($title) {
                $lines.Add($indent + $title)
            } else {
                $lines.Add("")
            }
        }
        "bulleted_list" {
            $lines.Add($indent + "- " + $title)
        }
        "numbered_list" {
            $lines.Add($indent + "1. " + $title)
        }
        "to_do" {
            $checked = if ($b.properties.checked -and $b.properties.checked[0][0] -eq "Yes") { "[x]" } else { "[ ]" }
            $lines.Add($indent + "- " + $checked + " " + $title)
        }
        "toggle" {
            $lines.Add("")
            $lines.Add($indent + "<details><summary><b>" + $title + "</b></summary>")
            $lines.Add("")
        }
        "callout" {
            $icon = ""
            if ($b.format -and $b.format.page_icon) { $icon = $b.format.page_icon + " " }
            $lines.Add("")
            $lines.Add($indent + "> " + $icon + $title)
            $lines.Add("")
        }
        "quote" {
            $lines.Add($indent + "> " + $title)
        }
        "divider" {
            $lines.Add("")
            $lines.Add($indent + "---")
            $lines.Add("")
        }
        "code" {
            $lang = if ($b.properties.language) { $b.properties.language[0][0] } else { "" }
            $lines.Add($indent + '```' + $lang)
            $lines.Add($title)
            $lines.Add($indent + '```')
        }
        "image" {
            $src = ""
            if ($b.properties.source) { $src = $b.properties.source[0][0] }
            elseif ($b.format -and $b.format.display_source) { $src = $b.format.display_source }
            $caption = ""
            if ($b.properties.caption) { $caption = Get-RichText $b.properties.caption }
            $lines.Add("")
            $lines.Add($indent + "![Image: " + $caption + "](" + $src + ")")
            if ($caption) { $lines.Add($indent + "*Caption: " + $caption + "*") }
            $lines.Add("")
        }
        "bookmark" {
            $link = if ($b.properties.link) { $b.properties.link[0][0] } else { "" }
            $lines.Add($indent + "[Bookmark: " + $title + "](" + $link + ")")
        }
        default {
            if ($title) {
                $lines.Add($indent + "[" + $type + "] " + $title)
            }
        }
    }
    
    if ($b.content -and ($type -ne "page" -or $depth -eq 0)) {
        foreach ($childId in $b.content) {
            $nextDepth = if ($type -eq "page") { 0 } else { $depth + 1 }
            Render-Block-Markdown $childId $nextDepth $lines $visited
        }
    }
    
    if ($type -eq "toggle") {
        $lines.Add("")
        $lines.Add($indent + "</details>")
        $lines.Add("")
    }
}

$pageList = @()
foreach ($kv in $blockMap.GetEnumerator()) {
    $b = $kv.Value
    if ($b.type -eq "page") {
        $pageList += $b
    }
}

$allPagesContent = [System.Collections.Generic.List[string]]::new()
$allPagesContent.Add("# DOKUMENTASI LENGKAP WIFI-ID NOTES`n")
$allPagesContent.Add("Sumber: https://app.notion.com/p/WIFI-ID-NOTES-340bc60a349d80298c50e2ff294097b4`n")

foreach ($p in $pageList) {
    $pTitle = if ($p.properties.title) { (Get-RichText $p.properties.title).Trim() } else { "Untitled" }
    $safeName = ($pTitle -replace '[\\/*?:"<>|]', '_').Trim()
    if (-not $safeName) { $safeName = $p.id }
    
    $pLines = [System.Collections.Generic.List[string]]::new()
    $vSet = [System.Collections.Generic.HashSet[string]]::new()
    Render-Block-Markdown $p.id 0 $pLines $vSet
    
    $filePath = "rendered_notes\$safeName.md"
    [System.IO.File]::WriteAllLines($filePath, $pLines, [System.Text.Encoding]::UTF8)
    
    $allPagesContent.Add("`n`n================================================================================")
    $allPagesContent.Add("PAGE: $pTitle (ID: $($p.id))")
    $allPagesContent.Add("================================================================================`n")
    foreach ($l in $pLines) {
        $allPagesContent.Add($l)
    }
}

[System.IO.File]::WriteAllLines("FULL_WIFI_ID_NOTES.md", $allPagesContent, [System.Text.Encoding]::UTF8)
Write-Output "Successfully exported all pages! Total compiled lines: $($allPagesContent.Count)"
