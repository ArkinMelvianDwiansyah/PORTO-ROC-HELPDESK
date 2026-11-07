$json = Get-Content -Raw "page_chunk.json" | ConvertFrom-Json
$blockMap = @{}
foreach ($prop in $json.recordMap.block.psobject.properties) {
    $val = $prop.Value.value.value
    if (-not $val) {
        $val = $prop.Value.value
    }
    if ($val) {
        $blockMap[$prop.Name] = $val
    }
}

Write-Output "Found $($blockMap.Count) blocks in map."

function Get-BlockText($b) {
    if (-not $b.properties -or -not $b.properties.title) { return "" }
    $texts = @()
    foreach ($chunk in $b.properties.title) {
        if ($chunk.Count -gt 0) {
            $texts += $chunk[0]
        }
    }
    return ($texts -join "")
}

function Render-Block($id, $depth) {
    $b = $blockMap[$id]
    if (-not $b) {
        Write-Output ("  " * $depth + "[Block not in map: $id]")
        return
    }
    $indent = "  " * $depth
    $type = $b.type
    $text = Get-BlockText $b
    
    switch ($type) {
        "page" {
            Write-Output ("`n" + $indent + "=== PAGE: $text (ID: $($b.id)) ===")
        }
        "header" {
            Write-Output ($indent + "# " + $text)
        }
        "sub_header" {
            Write-Output ($indent + "## " + $text)
        }
        "sub_sub_header" {
            Write-Output ($indent + "### " + $text)
        }
        "text" {
            if ($text) { Write-Output ($indent + $text) } else { Write-Output "" }
        }
        "bulleted_list" {
            Write-Output ($indent + "* " + $text)
        }
        "numbered_list" {
            Write-Output ($indent + "1. " + $text)
        }
        "to_do" {
            $checked = if ($b.properties.checked -and $b.properties.checked[0][0] -eq "Yes") { "[x]" } else { "[ ]" }
            Write-Output ($indent + "$checked " + $text)
        }
        "toggle" {
            Write-Output ($indent + "> [TOGGLE] " + $text)
        }
        "callout" {
            Write-Output ($indent + "> [CALLOUT] " + $text)
        }
        "quote" {
            Write-Output ($indent + "> " + $text)
        }
        "divider" {
            Write-Output ($indent + "---")
        }
        "image" {
            $src = ""
            if ($b.properties.source) { $src = $b.properties.source[0][0] }
            elseif ($b.format.display_source) { $src = $b.format.display_source }
            Write-Output ($indent + "[IMAGE: $src]")
        }
        "bookmark" {
            $link = if ($b.properties.link) { $b.properties.link[0][0] } else { "" }
            Write-Output ($indent + "[BOOKMARK: $link | $text]")
        }
        default {
            Write-Output ($indent + "[$type] " + $text)
        }
    }

    if ($b.content) {
        foreach ($childId in $b.content) {
            Render-Block $childId ($depth + 1)
        }
    }
}

Render-Block "340bc60a-349d-8029-8c50-e2ff294097b4" 0 | Out-File -FilePath "rendered_page.txt" -Encoding utf8
Write-Output "Done rendering. File size: $((Get-Item rendered_page.txt).Length) bytes"
