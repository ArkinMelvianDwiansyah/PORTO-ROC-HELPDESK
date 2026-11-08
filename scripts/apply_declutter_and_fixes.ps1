# PowerShell script to:
# 1. Replace all broken emojis/mojibake with clean inline Lucide Brain SVGs
# 2. Redesign Master Matrix into a sleek, streamlined 5-column table + 9-Hop Card Grid + View Switcher
# 3. Add 'show controllers utilization' CLI and analysis to Hop 06
# 4. Update SWAGGR Port Inventory and Explainer Drawer with utilization metrics
# 5. Add switchMatrixView JS function to generate_tabbed_site.ps1

$brainSvgLarge = '<svg class="w-5 h-5 text-emerald-400 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/><path d="M12 8a2 2 0 0 0-2 2"/><path d="M12 13a2 2 0 0 1 2 2"/></svg>'

$brainSvgMedium = '<svg class="w-3.5 h-3.5 text-emerald-400 shrink-0 inline-block align-middle" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/><path d="M12 8a2 2 0 0 0-2 2"/><path d="M12 13a2 2 0 0 1 2 2"/></svg>'

$brainSvgSmall = '<svg class="w-3 h-3 text-emerald-400 shrink-0 inline-block" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/></svg>'

Write-Host "Step 1: Reading e2e_tracing_content.html..."
$e2ePath = "scripts\e2e_tracing_content.html"
$e2eContent = [System.IO.File]::ReadAllText($e2ePath, [System.Text.Encoding]::UTF8)

# Replace Subnav button mojibake
$oldSubnavBtnRegex = '(?s)<button onclick="toggleExplainer\(\)" class="px-3 py-1 rounded-lg bg-emerald-950/90[^>]*>.*?Jelasin Dong!\s*</button>'
$newSubnavBtn = @"
<button onclick="toggleExplainer()" class="px-3 py-1 rounded-lg bg-emerald-950/90 hover:bg-emerald-900 border border-emerald-700 text-xs text-emerald-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono font-bold cursor-pointer mr-2 shadow-sm">
        $brainSvgMedium
        <span>Jelasin Dong!</span>
      </button>
"@
$e2eContent = [System.Text.RegularExpressions.Regex]::Replace($e2eContent, $oldSubnavBtnRegex, $newSubnavBtn)

# Replace Pipeline Hop buttons (Hops 01 - 09)
for ($h = 1; $h -le 9; $h++) {
    $hStr = if ($h -lt 10) { "0$h" } else { "$h" }
    $oldPipeBtnRegex = "(?s)<button onclick=""openExplainerHop\('$hStr'\)[^""]*"" class=""mt-2 text-\[9px\] font-mono px-2 py-0\.5 rounded bg-zinc-800/90[^""]*"">.*?Jelasin Hop $hStr.*?<span>&rarr;</span>\s*</button>"
    $newPipeBtn = @"
<button onclick="openExplainerHop('$hStr'); event.preventDefault(); event.stopPropagation();" class="mt-2 text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800/90 hover:bg-emerald-950 text-zinc-300 hover:text-emerald-300 border border-zinc-700 hover:border-emerald-700 transition-colors flex items-center justify-between w-full cursor-pointer">
            <span class="inline-flex items-center gap-1">
              $brainSvgSmall
              <span>Jelasin Hop $hStr</span>
            </span>
            <span>&rarr;</span>
          </button>
"@
    $e2eContent = [System.Text.RegularExpressions.Regex]::Replace($e2eContent, $oldPipeBtnRegex, $newPipeBtn)

    # Replace Hop Card header button
    $oldCardBtnRegex = "(?s)<button onclick=""openExplainerHop\('$hStr'\)"" class=""ml-2 inline-flex items-center gap-1 px-2 py-0\.5 rounded bg-emerald-950/80[^""]*""><span>.*?Jelasin</span></button>"
    $newCardBtn = @"
<button onclick="openExplainerHop('$hStr')" class="ml-2 inline-flex items-center gap-1 px-2 py-0.5 rounded bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800 text-[10px] font-mono text-emerald-300 hover:text-white transition-colors cursor-pointer align-middle">$brainSvgSmall<span>Jelasin</span></button>
"@
    $e2eContent = [System.Text.RegularExpressions.Regex]::Replace($e2eContent, $oldCardBtnRegex, $newCardBtn)
}

Write-Host "Mojibake replaced in e2e_tracing_content.html."
[System.IO.File]::WriteAllText($e2ePath, $e2eContent, [System.Text.Encoding]::UTF8)
