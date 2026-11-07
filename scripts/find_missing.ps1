$allBlocks = Get-Content -Raw "all_blocks.json" | ConvertFrom-Json
$missing = @()
foreach ($prop in $allBlocks.psobject.properties) {
    $b = $prop.Value
    if ($b.content) {
        foreach ($childId in $b.content) {
            if (-not $allBlocks.$childId) {
                $missing += $childId
            }
        }
    }
}
$missing = $missing | Select-Object -Unique
Write-Output "Total missing child blocks referenced in content: $($missing.Count)"
$missing | Select-Object -First 10 | ForEach-Object { Write-Output "  Missing: $_" }
