$fullPath = "D:\Users\roc-5\.gemini\antigravity\brain\4f2d50ce-7a16-4e86-8d28-3a71eb522155\.system_generated\logs\transcript_full.jsonl"
$stream = [System.IO.File]::OpenText($fullPath)
$targetLine = $null
while (-not $stream.EndOfStream) {
    $line = $stream.ReadLine()
    if ($line -like '*"step_index":852*') {
        $targetLine = $line
        break
    }
}
$stream.Close()

if ($targetLine) {
    $data = $targetLine | ConvertFrom-Json
    [System.IO.File]::WriteAllText("D:\ARKIN\tes aim\data\mas_adi_input.txt", $data.content)
    Write-Host "Success! Length: $($data.content.Length)"
} else {
    Write-Host "Step 852 not found."
}
