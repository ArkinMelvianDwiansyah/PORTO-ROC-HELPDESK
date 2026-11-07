$json = Get-Content -Raw "page_chunk.json" | ConvertFrom-Json
$pages = @()
foreach ($prop in $json.recordMap.block.psobject.properties) {
    $val = $prop.Value.value.value
    if (-not $val) { $val = $prop.Value.value }
    if ($val.type -eq "page") {
        $title = ""
        if ($val.properties.title) {
            $title = ($val.properties.title | ForEach-Object { $_[0] }) -join ""
        }
        $pages += [PSCustomObject]@{
            Id = $val.id
            Title = $title
            ContentCount = if ($val.content) { $val.content.Count } else { 0 }
        }
    }
}
$pages | Format-Table -AutoSize | Out-String | Write-Output
