# Script to add "Jelasin Dong" trigger buttons to e2e_tracing_content.html
$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# 1. Add "🧠 Jelasin Dong!" button in Sub-Nav
$oldSubnavMarker = '<button onclick="toggleGlossary()"'
$newSubnavBtn = @'
<button onclick="toggleExplainer()" class="px-3 py-1 rounded-lg bg-emerald-950/90 hover:bg-emerald-900 border border-emerald-700 text-xs text-emerald-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono font-bold cursor-pointer mr-2">
        <span class="text-xs">🧠</span>
        Jelasin Dong!
      </button>
      <button onclick="toggleGlossary()"'
'@

if ($content.Contains($oldSubnavMarker)) {
    $idxSub = $content.IndexOf($oldSubnavMarker)
    $content = $content.Substring(0, $idxSub) + $newSubnavBtn + $content.Substring($idxSub + $oldSubnavMarker.Length)
    Write-Host "Subnav button 'Jelasin Dong!' added."
}

# 2. Add mini-button inside each pipeline card (Hops 01 - 09)
for ($i = 1; $i -le 9; $i++) {
    $hopStr = $i.ToString("D2")
    $searchHop = "<!-- HOP $hopStr -->"
    $idxHop = $content.IndexOf($searchHop)
    if ($idxHop -ge 0) {
        # Find closing </a> for this card
        $idxEndA = $content.IndexOf('</a>', $idxHop)
        if ($idxEndA -gt $idxHop) {
            # Find the last </div> before </a>
            $idxDiv = $content.LastIndexOf('</div>', $idxEndA)
            if ($idxDiv -gt $idxHop) {
                $btnSnippet = @"
`r`n          <button onclick="openExplainerHop('$hopStr'); event.preventDefault(); event.stopPropagation();" class="mt-2 text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800/90 hover:bg-emerald-950 text-zinc-300 hover:text-emerald-300 border border-zinc-700 hover:border-emerald-700 transition-colors flex items-center justify-between w-full cursor-pointer">
            <span>🧠 Jelasin Hop $hopStr</span>
            <span>&rarr;</span>
          </button>
"@
                $content = $content.Substring(0, $idxDiv) + $btnSnippet + "`r`n        " + $content.Substring($idxDiv)
                Write-Host "Pipeline button added for Hop $hopStr."
            }
        }
    }
}

# 3. Add "🧠 Jelasin Dong" button in each Hop card header (Hop 01 - 09)
for ($i = 1; $i -le 9; $i++) {
    $hopStr = $i.ToString("D2")
    $searchSection = "id=""hop-$hopStr"""
    $idxSec = $content.IndexOf($searchSection)
    if ($idxSec -ge 0) {
        # Look for the header flex container close or status badge
        $idxH3 = $content.IndexOf("<h3", $idxSec)
        if ($idxH3 -gt $idxSec) {
            $idxCloseH3 = $content.IndexOf("</h3>", $idxH3)
            if ($idxCloseH3 -gt $idxH3) {
                $headerBtn = @"
 <button onclick="openExplainerHop('$hopStr')" class="ml-2 inline-flex items-center gap-1 px-2 py-0.5 rounded bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800 text-[10px] font-mono text-emerald-300 hover:text-white transition-colors cursor-pointer align-middle"><span>🧠 Jelasin</span></button>
"@
                $content = $content.Substring(0, $idxCloseH3) + $headerBtn + $content.Substring($idxCloseH3)
                Write-Host "Header button added for Hop $hopStr section."
            }
        }
    }
}

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
Write-Host "e2e_tracing_content.html successfully patched with all Explainer triggers."
