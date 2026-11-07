$allBlocks = Get-Content -Raw "all_blocks.json" | ConvertFrom-Json
$blockMap = @{}
foreach ($prop in $allBlocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}
Write-Output "Initial blocks in map: $($blockMap.Count)"

$iteration = 0
while ($iteration -lt 10) {
    $iteration++
    $missingIds = @()
    foreach ($kv in $blockMap.GetEnumerator()) {
        $b = $kv.Value
        if ($b.content) {
            foreach ($cid in $b.content) {
                if (-not $blockMap.ContainsKey($cid) -and -not $missingIds.Contains($cid)) {
                    $missingIds += $cid
                }
            }
        }
    }
    
    Write-Output "Iteration $iteration : Found $($missingIds.Count) missing blocks."
    if ($missingIds.Count -eq 0) {
        Write-Output "All referenced blocks are completely fetched!"
        break
    }
    
    # Process in batches of 50
    $batchSize = 50
    for ($i = 0; $i -lt $missingIds.Count; $i += $batchSize) {
        $endIdx = [Math]::Min($i + $batchSize - 1, $missingIds.Count - 1)
        $batch = $missingIds[$i..$endIdx]
        $reqs = @()
        foreach ($id in $batch) {
            $reqs += @{
                pointer = @{
                    table = "block"
                    id = $id
                }
                version = -1
            }
        }
        $payload = @{ requests = $reqs } | ConvertTo-Json -Depth 5 -Compress
        $payload | Out-File -FilePath "temp_sync_payload.json" -Encoding utf8
        
        & curl.exe -s -X POST "https://www.notion.so/api/v3/syncRecordValues" -H "Content-Type: application/json" --data "@temp_sync_payload.json" -o "temp_sync_res.json"
        
        if (Test-Path "temp_sync_res.json") {
            try {
                $res = Get-Content -Raw "temp_sync_res.json" | ConvertFrom-Json
                if ($res.recordMap -and $res.recordMap.block) {
                    $newBlocks = $res.recordMap.block.psobject.properties
                    foreach ($nb in $newBlocks) {
                        $val = $nb.Value.value.value
                        if (-not $val) { $val = $nb.Value.value }
                        if ($val) {
                            $blockMap[$nb.Name] = $val
                        }
                    }
                }
            } catch {
                Write-Output "  Error parsing sync response: $_"
            }
        }
    }
    Write-Output "  After iteration $iteration, total blocks in map: $($blockMap.Count)"
}

Write-Output "FINAL BLOCK COUNT: $($blockMap.Count)"
$blockMap | ConvertTo-Json -Depth 10 | Out-File -FilePath "all_blocks_complete.json" -Encoding utf8
Write-Output "Saved all_blocks_complete.json ($((Get-Item all_blocks_complete.json).Length) bytes)"
