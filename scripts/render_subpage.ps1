$json = Get-Content -Raw "test_subpage_chunk.json" | ConvertFrom-Json
$blockMap = @{}
foreach ($prop in $json.recordMap.block.psobject.properties) {
    $val = $prop.Value.value.value
    if (-not $val) { $val = $prop.Value.value }
    if ($val) { $blockMap[$prop.Name] = $val }
}

function Get-BlockText($b) {
    if (-not $b.properties -or -not $b.properties.title) { return "" }
    $texts = @()
    foreach ($chunk in $b.properties.title) {
        if ($chunk.Count -gt 0) { $texts += $chunk[0] }
    }
    return ($texts -join "")
}

function Render-Block($id, $depth) {
    $b = $blockMap[$id]
    if (-not $b) {
        Write-Output ("  " * $depth + "[Missing: $id]")
        return
    }
    $indent = "  " * $depth
    $type = $b.type
    $text = Get-BlockText $b
    
    switch ($type) {
        "page" { Write-Output ("`n" + $indent + "=== PAGE: $text (ID: $($b.id)) ===") }
        "header" { Write-Output ($indent + "# " + $text) }
        "sub_header" { Write-Output ($indent + "## " + $text) }
        "sub_sub_header" { Write-Output ($indent + "### " + $text) }
        "text" { if ($text) { Write-Output ($indent + $text) } else { Write-Output "" } }
        "bulleted_list" { Write-Output ($indent + "* " + $text) }
        "numbered_list" { Write-Output ($indent + "1. " + $text) }
        "to_do" {
            $checked = if ($b.properties.checked -and $b.properties.checked[0][0] -eq "Yes") { "[x]" } else { "[ ]" }
            Write-Output ($indent + "$checked " + $text)
        }
        "toggle" { Write-Output ($indent + "> [TOGGLE] " + $text) }
        "callout" { Write-Output ($indent + "> [CALLOUT] " + $text) }
        "quote" { Write-Output ($indent + "> " + $text) }
        "divider" { Write-Output ($indent + "---") }
        "image" {
            $src = ""
            if ($b.properties.source) { $src = $b.properties.source[0][0] }
            elseif ($b.format.display_source) { $src = $b.format.display_source }
            Write-Output ($indent + "[IMAGE: $src]")
        }
        default { Write-Output ($indent + "[$type] " + $text) }
    }

    if ($b.content) {
        foreach ($childId in $b.content) {
            Render-Block $childId ($depth + 1)
        }
    }
}

Render-Block "340bc60a-349d-80f2-9d4e-e97691869aba" 0
