$c0 = Get-Content -Raw "chunks\chunk_340bc60a-349d-80f9-bdd1-f004dbd11ed2_0.json" | ConvertFrom-Json
$c0.cursor | ConvertTo-Json -Depth 5
