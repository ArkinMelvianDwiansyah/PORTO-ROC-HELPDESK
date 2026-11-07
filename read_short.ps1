Get-ChildItem rendered_notes | Where-Object { $_.Length -lt 200 } | ForEach-Object {
    Write-Output ("=== " + $_.Name + " ===")
    Get-Content $_.FullName
    Write-Output ""
}
