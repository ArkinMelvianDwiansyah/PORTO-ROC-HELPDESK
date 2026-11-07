$blocks = Get-Content -Raw -Encoding UTF8 "all_blocks_complete.json" | ConvertFrom-Json
$root = $blocks."340bc60a-349d-8029-8c50-e2ff294097b4"

$found = $false
for ($i = 0; $i -lt $root.content.Count; $i++) {
    $cid = $root.content[$i]
    $b = $blocks.$cid
    $txt = ""
    if ($b.properties -and $b.properties.title) {
        $txt = ($b.properties.title | ForEach-Object { $_[0] }) -join ""
    }
    if ($txt -like "*TOPOLOGI*") {
        Write-Output "Found TOPOLOGI at index $i"
        for ($j = [Math]::Max(0, $i - 2); $j -le [Math]::Min($root.content.Count - 1, $i + 15); $j++) {
            $subId = $root.content[$j]
            $sb = $blocks.$subId
            $stxt = if ($sb.properties.title) { ($sb.properties.title | ForEach-Object { $_[0] }) -join "" } else { "" }
            Write-Output "  [$j] Type: $($sb.type) | ID: $subId | Text: $stxt"
        }
        break
    }
}
