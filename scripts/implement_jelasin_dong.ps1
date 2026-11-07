# Script to implement "Jelasin Dong! 🧠" (Deep Explainer Drawer & Triggers)
$rootDir = "d:\ARKIN\tes aim"
$ps1File = Join-Path $rootDir "scripts\generate_tabbed_site.ps1"
$e2eFile = Join-Path $rootDir "scripts\e2e_tracing_content.html"

# 1. Update scripts/generate_tabbed_site.ps1 with Explainer Drawer, Floating Buttons, and JS Controller
$ps1Content = [System.IO.File]::ReadAllText($ps1File, [System.Text.Encoding]::UTF8)

# Replacement for the floating button area: replace single glossary button with stacked buttons
$oldFloatingBtn = @'
  <!-- Floating Glossary Trigger Button -->
  <button id="glossary-floating-btn" onclick="toggleGlossary()" class="fixed right-6 bottom-6 z-40 flex items-center gap-3 px-4 py-2.5 rounded-full bg-zinc-950/95 hover:bg-zinc-900 text-white border border-zinc-700/80 shadow-2xl backdrop-blur-md transition-all duration-300 hover:scale-105 group cursor-pointer ring-1 ring-white/10">
    <div class="w-6 h-6 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400 group-hover:rotate-12 transition-transform">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
    </div>
    <div class="text-left">
      <div class="text-[11px] font-mono font-bold uppercase tracking-wider text-white flex items-center gap-1.5">
        <span>Glosarium</span>
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
      </div>
      <div class="text-[9px] font-mono text-zinc-400">Kamus Singkatan Jaringan</div>
    </div>
  </button>
'@

$newFloatingStack = @'
  <!-- FLOATING ACTION BUTTONS STACK (BOTTOM RIGHT) -->
  <div class="fixed right-6 bottom-6 z-40 flex flex-col items-end gap-2.5">
    
    <!-- Floating Explainer "Jelasin Dong!" Trigger Button -->
    <button id="explainer-floating-btn" onclick="toggleExplainer()" class="flex items-center gap-3 px-4 py-2.5 rounded-full bg-emerald-950/95 hover:bg-emerald-900 text-white border border-emerald-700/80 shadow-2xl backdrop-blur-md transition-all duration-300 hover:scale-105 group cursor-pointer ring-2 ring-emerald-500/40">
      <div class="w-6 h-6 rounded-full bg-emerald-500/30 border border-emerald-400 flex items-center justify-center text-emerald-300 group-hover:rotate-12 transition-transform">
        <span class="text-xs">🧠</span>
      </div>
      <div class="text-left">
        <div class="text-[11px] font-mono font-bold uppercase tracking-wider text-emerald-300 flex items-center gap-1.5">
          <span>Jelasin Dong!</span>
          <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
        </div>
        <div class="text-[9px] font-mono text-zinc-300">Bedah Teknis Tiap Hop</div>
      </div>
    </button>

    <!-- Floating Glossary Trigger Button -->
    <button id="glossary-floating-btn" onclick="toggleGlossary()" class="flex items-center gap-3 px-4 py-2 rounded-full bg-zinc-950/95 hover:bg-zinc-900 text-white border border-zinc-700/80 shadow-xl backdrop-blur-md transition-all duration-300 hover:scale-105 group cursor-pointer ring-1 ring-white/10">
      <div class="w-5 h-5 rounded-full bg-zinc-800 border border-zinc-700 flex items-center justify-center text-zinc-300 group-hover:rotate-12 transition-transform">
        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
      </div>
      <div class="text-left">
        <div class="text-[10px] font-mono font-bold uppercase tracking-wider text-zinc-200">Glosarium</div>
        <div class="text-[8px] font-mono text-zinc-400">Kamus Singkatan</div>
      </div>
    </button>

  </div>
'@

if ($ps1Content.Contains($oldFloatingBtn)) {
    $ps1Content = $ps1Content.Replace($oldFloatingBtn, $newFloatingStack)
    Write-Host "Floating buttons stack updated in generate_tabbed_site.ps1."
} else {
    Write-Warning "Could not find oldFloatingBtn directly, trying normalized."
}

[System.IO.File]::WriteAllText($ps1File, $ps1Content, [System.Text.Encoding]::UTF8)
Write-Host "generate_tabbed_site.ps1 updated part 1."
