$allBlocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$imageBlocks = @()
foreach ($prop in $allBlocks.psobject.properties) {
    $b = $prop.Value
    if ($b.type -eq "image") {
        $src = ""
        if ($b.properties -and $b.properties.source) { $src = $b.properties.source[0][0] }
        elseif ($b.format -and $b.format.display_source) { $src = $b.format.display_source }
        
        if ($src) {
            $imageBlocks += [PSCustomObject]@{
                id = $b.id
                src = $src
            }
        }
    }
}

Write-Output "Found $($imageBlocks.Count) images to download."
New-Item -ItemType Directory -Force -Path "assets\images" | Out-Null

$imageMap = @{}
$batchSize = 40

for ($i = 0; $i -lt $imageBlocks.Count; $i += $batchSize) {
    $endIdx = [Math]::Min($i + $batchSize - 1, $imageBlocks.Count - 1)
    $batch = $imageBlocks[$i..$endIdx]
    
    $reqUrls = @()
    foreach ($item in $batch) {
        $reqUrls += @{
            url = $item.src
            permissionRecord = @{
                table = "block"
                id = $item.id
            }
        }
    }
    
    $payload = @{ urls = $reqUrls } | ConvertTo-Json -Depth 5 -Compress
    $payload | Out-File -FilePath "temp_signed_req.json" -Encoding utf8
    
    & curl.exe -s -X POST "https://www.notion.so/api/v3/getSignedFileUrls" -H "Content-Type: application/json" --data "@temp_signed_req.json" -o "temp_signed_res.json"
    
    if (Test-Path "temp_signed_res.json") {
        try {
            $res = Get-Content -Raw "temp_signed_res.json" | ConvertFrom-Json
            if ($res.signedUrls) {
                for ($k = 0; $k -lt $res.signedUrls.Count; $k++) {
                    $item = $batch[$k]
                    $sUrl = $res.signedUrls[$k]
                    $ext = "png"
                    if ($item.src -match '\.(jpg|jpeg|gif|webp|svg)') {
                        $ext = $matches[1]
                    }
                    $fileName = "$($item.id).$ext"
                    $destPath = "assets\images\$fileName"
                    
                    # Download image
                    & curl.exe -s -L "$sUrl" -o "$destPath"
                    
                    if (Test-Path $destPath) {
                        $imageMap[$item.id] = "assets/images/$fileName"
                    }
                }
            }
        } catch {
            Write-Output "Error in batch $i : $_"
        }
    }
    Write-Output "Processed up to index $endIdx. Downloaded: $($imageMap.Count)"
}

$imageMap | ConvertTo-Json -Depth 3 | Out-File -FilePath "image_map.json" -Encoding utf8
Write-Output "DONE! Successfully saved image_map.json with $($imageMap.Count) images."
