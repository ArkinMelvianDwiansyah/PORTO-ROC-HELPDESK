$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

$oldSnippet = '<a href="#deepdive-section"'
$newPill = @'
<a href="#master-matrix" class="px-3 py-1 rounded-lg bg-emerald-950/80 hover:bg-emerald-900/80 border border-emerald-800 text-xs text-emerald-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono font-semibold">
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
        Matriks Port, VLAN &amp; MAC
      </a>
      <a href="#deepdive-section"
'@

if ($content.Contains($oldSnippet)) {
    $idx = $content.IndexOf($oldSnippet)
    $content = $content.Substring(0, $idx) + $newPill + $content.Substring($idx + $oldSnippet.Length)
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Subnav successfully patched with Matriks link."
} else {
    Write-Error "Could not find $oldSnippet in file."
}
