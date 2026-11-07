$html = Get-Content -Raw "index.html"
Write-Output ("Total Length: " + $html.Length)
$imgMatches = [regex]::Matches($html, 'src="assets/images/[^"]+"')
Write-Output ("Total Image References in HTML: " + $imgMatches.Count)
$secMatches = [regex]::Matches($html, 'id="sec-[^"]+"')
Write-Output ("Total Sections in HTML: " + $secMatches.Count)
foreach ($m in $secMatches) {
    Write-Output ("  " + $m.Value)
}
