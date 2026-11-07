$blocks = Get-Content -Raw -Encoding UTF8 "all_blocks_complete.json" | ConvertFrom-Json
$imgMap = Get-Content -Raw -Encoding UTF8 "image_map.json" | ConvertFrom-Json

foreach ($prop in $blocks.psobject.properties) {
    $b = $prop.Value
    if ($b.type -eq "image") {
        $src = ""
        if ($b.properties -and $b.properties.source) { $src = $b.properties.source[0][0] }
        if ($src -like "*e659d7bc-0171-4eca-a269-e29fd21e8042*") {
            Write-Output ("Block ID: " + $b.id)
            Write-Output ("Local Image: " + $imgMap.($b.id))
        }
    }
}
