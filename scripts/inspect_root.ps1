$json = Get-Content -Raw "page_chunk.json" | ConvertFrom-Json
$root = $json.recordMap.block."340bc60a-349d-8029-8c50-e2ff294097b4"
Write-Output "--- ROOT BLOCK ---"
$root | ConvertTo-Json -Depth 6 | Out-File -FilePath "root_block.json" -Encoding utf8
Write-Output "Wrote root_block.json"
