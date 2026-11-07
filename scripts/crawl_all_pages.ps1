# crawler for notion pages
$pageIds = @(
    "340bc60a-349d-8029-8c50-e2ff294097b4", # WIFI-ID NOTES (Root)
    "340bc60a-349d-80f2-9d4e-e97691869aba", # TIKETING WIFI-ID
    "340bc60a-349d-80f9-bdd1-f004dbd11ed2", # GANTI AP
    "340bc60a-349d-80b6-a7ea-f2a88be9038d", # GANTI AP - BEDA WISM
    "340bc60a-349d-8028-ad88-e48661065286", # WP-ERROR / URL ERROR
    "340bc60a-349d-80ba-8ab6-ecc230b933e8", # INTERMITTEN
    "340bc60a-349d-8036-b123-dab53afd82c8", # GANTI CHANNEL
    "340bc60a-349d-8011-bfc3-fa722365c73e", # RESEND - EMAIL
    "340bc60a-349d-805d-a0a5-ccaaa5369cc8", # CEK & GANTI PASSWORD
    "340bc60a-349d-809a-b3b1-edad2b75ee0e", # CEK PENGGUNAAN DAN PERANGKAT TERKONEKSI
    "340bc60a-349d-80f3-abe1-fbea9a8c2de8", # CEK SN ONT
    "340bc60a-349d-8099-bd22-d63b314e03a1", # CREATE SSID
    "340bc60a-349d-802e-943a-d0272cc53185", # GROPING SSID
    "340bc60a-349d-8059-9de2-ee3a6bc16cae", # WIFIv6
    "340bc60a-349d-80ac-93ba-f7bb8263f82a", # Ganti AP Baru ( Gress )
    "340bc60a-349d-8078-b957-db39a075300c", # OPEN TIKET
    "340bc60a-349d-8026-9aa7-f457eeed4ab0", # CREATE RSA
    "340bc60a-349d-8067-99f0-c5e085b0594b", # RSA Automation
    "340bc60a-349d-80ff-93ad-ed04e4254f4e", # WP ERROR PORT LOCATING ( X )
    "340bc60a-349d-800f-9785-dd6f0114c2a2", # CONFIG WMS TACACS ONT GANTI ONT BARU
    "386bc60a-349d-804c-bffe-ff22dfab5499", # BUKA ISOLIR
    "386bc60a-349d-80b9-9a98-dad9aa97c58e"  # MOJANG
)

New-Item -ItemType Directory -Force -Path "chunks" | Out-Null

$allBlocks = @{}

foreach ($pageId in $pageIds) {
    Write-Output "Fetching page $pageId ..."
    $chunkNo = 0
    $hasMore = $true
    
    while ($hasMore -and $chunkNo -lt 10) {
        $outFile = "chunks\chunk_${pageId}_${chunkNo}.json"
        $reqBody = @{
            page = @{ id = $pageId }
            limit = 100
            cursor = @{ stack = @() }
            chunkNumber = $chunkNo
            verticalColumns = $false
        } | ConvertTo-Json -Compress
        
        # Save temp payload
        $reqBody | Out-File -FilePath "temp_payload.json" -Encoding utf8
        
        & curl.exe -s -X POST "https://www.notion.so/api/v3/loadCachedPageChunk" -H "Content-Type: application/json" --data "@temp_payload.json" -o $outFile
        
        if (Test-Path $outFile) {
            $len = (Get-Item $outFile).Length
            if ($len -lt 500) {
                # Could be empty or error
                break
            }
            try {
                $cJson = Get-Content -Raw $outFile | ConvertFrom-Json
                $blocks = $cJson.recordMap.block.psobject.properties
                $added = 0
                foreach ($p in $blocks) {
                    $bVal = $p.Value.value.value
                    if (-not $bVal) { $bVal = $p.Value.value }
                    if ($bVal -and -not $allBlocks.ContainsKey($p.Name)) {
                        $allBlocks[$p.Name] = $bVal
                        $added++
                    }
                }
                Write-Output "  Chunk $chunkNo added $added blocks (Total: $($allBlocks.Count))"
                
                # Check cursor
                if ($cJson.cursor.stack.Count -eq 0 -and $chunkNo -gt 0) {
                    $hasMore = $false
                } elseif ($added -eq 0) {
                    $hasMore = $false
                }
            } catch {
                Write-Output "  Error parsing JSON for $($outFile): $_"
                break
            }
        } else {
            break
        }
        $chunkNo++
        # If content count was small, break
        if ($chunkNo -ge 1 -and $added -lt 50) {
            $hasMore = $false
        }
    }
}

Write-Output "FINISHED FETCHING. Total unique blocks: $($allBlocks.Count)"
$allBlocks | ConvertTo-Json -Depth 10 | Out-File -FilePath "all_blocks.json" -Encoding utf8
Write-Output "Saved all_blocks.json ($((Get-Item all_blocks.json).Length) bytes)"
