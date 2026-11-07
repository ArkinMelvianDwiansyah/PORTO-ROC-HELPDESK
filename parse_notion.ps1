$json = Get-Content -Raw "page_chunk.json" | ConvertFrom-Json
Write-Output ("RecordMap keys: " + ($json.recordMap.PSObject.Properties.Name -join ', '))
$blocks = $json.recordMap.block.PSObject.Properties
Write-Output ("Total blocks in recordMap: " + $blocks.Count)

$pages = @()
$collections = @()

foreach ($b in $blocks) {
    $val = $b.Value.value
    if ($null -ne $val) {
        $type = $val.type
        $id = $val.id
        $title = ""
        if ($val.properties -and $val.properties.title) {
            $title = ($val.properties.title | ForEach-Object { $_[0] }) -join ""
        }
        if ($type -eq "page") {
            $pages += [PSCustomObject]@{
                Id = $id
                Title = $title
                ParentId = $val.parent_id
                Alive = $val.alive
            }
        }
        if ($type -eq "collection_view" -or $type -eq "collection_view_page") {
            $collections += [PSCustomObject]@{
                Id = $id
                CollectionId = $val.collection_id
                ViewIds = ($val.view_ids -join ', ')
            }
        }
    }
}

Write-Output "`n--- SUBPAGES FOUND ---"
$pages | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "`n--- COLLECTIONS FOUND ---"
$collections | Format-Table -AutoSize | Out-String | Write-Output
