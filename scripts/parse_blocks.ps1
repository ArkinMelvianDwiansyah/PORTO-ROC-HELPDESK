$json = Get-Content -Raw "page_chunk.json" | ConvertFrom-Json
$blockObj = $json.recordMap.block
$blockNames = $blockObj.psobject.properties.name
Write-Output ("Count of blocks: " + $blockNames.Count)
Write-Output ("First 5 block IDs: " + ($blockNames | Select-Object -First 5 -Join ', '))

foreach ($name in $blockNames) {
    $item = $blockObj.$name.value
    if ($item) {
        $type = $item.type
        $props = $item.properties
        $title = ""
        if ($props -and $props.title) {
            $title = ($props.title | ForEach-Object { $_[0] }) -join ""
        }
        Write-Output "Block: $name | Type: $type | Title: $title"
    }
}
