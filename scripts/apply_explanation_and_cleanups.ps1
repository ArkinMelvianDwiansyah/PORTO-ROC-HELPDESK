$e2ePath = "scripts\e2e_tracing_content.html"
$genPath = "scripts\generate_tabbed_site.ps1"

Write-Host "1. Reading $e2ePath..."
$e2e = [System.IO.File]::ReadAllText($e2ePath, [System.Text.Encoding]::UTF8)

# --- 1. REMOVE BUTTONS FROM 9-HOP PIPELINE (GAMBAR 2) ---
for ($h = 1; $h -le 9; $h++) {
    $hStr = if ($h -lt 10) { "0$h" } else { "$h" }
    $pipeBtnPattern = "(?s)\s*<button onclick=""openExplainerHop\('$hStr'\); event\.preventDefault\(\); event\.stopPropagation\(\);"".*?Jelasin Hop $hStr.*?</button>"
    if ([System.Text.RegularExpressions.Regex]::IsMatch($e2e, $pipeBtnPattern)) {
        $e2e = [System.Text.RegularExpressions.Regex]::Replace($e2e, $pipeBtnPattern, "")
        Write-Host "Pipeline Hop $hStr button removed."
    } else {
        Write-Host "Warning: Pipeline Hop $hStr button not matched."
    }
}

# --- 2. REFACTOR HOP CARD HEADERS (GAMBAR 3) ---
for ($h = 1; $h -le 9; $h++) {
    $hStr = if ($h -lt 10) { "0$h" } else { "$h" }
    
    $headerPattern = "(?s)<div id=""hop-$hStr"" class=""p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-[456]"">\s*<div class=""flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-[23]"">\s*<div class=""flex items-center gap-3"">\s*<span class=""[^""]*"">$hStr</span>\s*<div>\s*<h3 class=""text-base font-bold text-white"">(.*?)\s*<button onclick=""openExplainerHop\('$hStr'\)"".*?<span>Jelasin</span></button></h3>\s*<p class=""text-xs text-zinc-400 font-mono"">(.*?)</p>\s*</div>\s*</div>\s*(<span class=""text-\[10px\] font-mono px-2\.5 py-1 rounded-full[^""]*"">.*?</span>)\s*</div>"

    $replacement = @'
    <div id="hop-NUM" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-3">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center shrink-0">NUM</span>
          <div>
            <h3 class="text-base font-bold text-white tracking-tight">${1}</h3>
            <p class="text-xs text-zinc-400 font-mono">${2}</p>
          </div>
        </div>
        <div class="flex flex-wrap items-center gap-2.5 self-start sm:self-auto shrink-0">
          <button onclick="openExplainerHop('NUM')" class="px-3 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-700 hover:border-emerald-600 text-xs font-mono text-zinc-300 hover:text-emerald-300 transition-all flex items-center gap-1.5 cursor-pointer shadow-sm group">
            <svg class="w-3.5 h-3.5 text-emerald-400 group-hover:scale-110 transition-transform shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/><path d="M12 8a2 2 0 0 0-2 2"/><path d="M12 13a2 2 0 0 1 2 2"/></svg>
            <span class="font-semibold">Explanation</span>
            <span class="text-zinc-500 group-hover:text-emerald-400 transition-colors">&rarr;</span>
          </button>
          ${3}
        </div>
      </div>
'@
    $actualReplacement = $replacement.Replace("NUM", $hStr)

    if ([System.Text.RegularExpressions.Regex]::IsMatch($e2e, $headerPattern)) {
        $e2e = [System.Text.RegularExpressions.Regex]::Replace($e2e, $headerPattern, $actualReplacement)
        Write-Host "Hop $hStr header successfully restructured."
    } else {
        Write-Host "Warning: Hop $hStr header pattern did not match."
    }
}

# --- 3. RENAME "JELASIN DONG!" IN SUBNAV AND MASTER MATRIX CARDS ---
$e2e = $e2e.Replace('<span>Jelasin Dong!</span>', '<span>Explanation</span>')
$e2e = $e2e.Replace('Jelasin &rarr;', 'Explanation &rarr;')

[System.IO.File]::WriteAllText($e2ePath, $e2e, [System.Text.Encoding]::UTF8)
Write-Host "Saved updated $e2ePath."

# --- 4. UPDATE GENERATE_TABBED_SITE.PS1 ---
Write-Host "2. Reading $genPath..."
$gen = [System.IO.File]::ReadAllText($genPath, [System.Text.Encoding]::UTF8)

# Update drawer title
$gen = $gen.Replace('<h3 class="text-base font-bold text-white tracking-tight">JELASIN DONG!</h3>', '<h3 class="text-base font-bold text-white tracking-tight">EXPLANATION</h3>')
$gen = $gen.Replace('9 Hops E2E Explainer Ready', '9 Hops E2E Technical Explanation Ready')

[System.IO.File]::WriteAllText($genPath, $gen, [System.Text.Encoding]::UTF8)
Write-Host "Saved updated $genPath."

Write-Host "SUCCESS!"
