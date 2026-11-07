$blocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

Write-Output "Loaded $($blockMap.Count) blocks."

# Identify all pages
$pages = @()
foreach ($kv in $blockMap.GetEnumerator()) {
    $b = $kv.Value
    if ($b.type -eq "page") {
        $title = ""
        if ($b.properties.title) {
            $title = ($b.properties.title | ForEach-Object { $_[0] }) -join ""
        }
        $pages += [PSCustomObject]@{
            Id = $b.id
            Title = $title
            ParentId = $b.parent_id
            ContentCount = if ($b.content) { $b.content.Count } else { 0 }
        }
    }
}

Write-Output "Found $($pages.Count) pages:"
$pages | Format-Table -AutoSize | Out-String | Write-Output
