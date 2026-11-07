# Test getting signed URLs for Notion image blocks
$allBlocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$imageBlocks = @()
foreach ($prop in $allBlocks.psobject.properties) {
    $b = $prop.Value
    if ($b.type -eq "image") {
        $src = ""
        if ($b.properties -and $b.properties.source) { $src = $b.properties.source[0][0] }
        elseif ($b.format -and $b.format.display_source) { $src = $b.format.display_source }
        
        if ($src) {
            $imageBlocks += @{
                id = $b.id
                src = $src
            }
        }
    }
}

Write-Output "Found $($imageBlocks.Count) images."
if ($imageBlocks.Count -gt 0) {
    Write-Output "First image: ID=$($imageBlocks[0].id), SRC=$($imageBlocks[0].src)"
}
