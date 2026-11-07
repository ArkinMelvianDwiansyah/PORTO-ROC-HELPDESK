$blocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$images = @()
foreach ($prop in $blocks.psobject.properties) {
    $b = $prop.Value
    if ($b.type -eq "image") {
        $src = ""
        if ($b.properties -and $b.properties.source) { $src = $b.properties.source[0][0] }
        elseif ($b.format -and $b.format.display_source) { $src = $b.format.display_source }
        
        $caption = ""
        if ($b.properties -and $b.properties.caption) {
            $caption = ($b.properties.caption | ForEach-Object { $_[0] }) -join ""
        }
        
        $images += [PSCustomObject]@{
            Id = $b.id
            ParentId = $b.parent_id
            Source = $src
            Caption = $caption
        }
    }
}

Write-Output "Total image blocks: $($images.Count)"
$images | Format-Table -AutoSize | Out-String | Write-Output
