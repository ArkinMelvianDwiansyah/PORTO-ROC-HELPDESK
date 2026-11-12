# Script to update scripts/e2e_tracing_content.html with full DATIN ROC CLI data
$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# 1. Update Alert Banner
$oldBanner = @'
  <!-- ============================================================ -->
  <!-- ALERT BANNER: STATUS TRACING & NOTICE TO USER -->
  <!-- ============================================================ -->
  <div class="p-5 rounded-2xl border border-zinc-800 bg-zinc-950/90 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-sm">
    <div class="flex items-start gap-3.5">
      <div class="p-2.5 rounded-xl bg-zinc-900 border border-zinc-800 text-zinc-200 shrink-0">
        <svg class="w-5 h-5 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
      </div>
      <div>
        <div class="flex items-center gap-2">
          <span class="text-xs font-mono font-bold uppercase tracking-wider text-white">STATUS TRACING: SEGMENT 01 S/D 07 FULLY VERIFIED</span>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">7 / 9 HOPS ONLINE</span>
        </div>
        <p class="text-xs text-zinc-400 mt-1 leading-relaxed">
          Tracing dari <strong class="text-zinc-200">AP &rarr; ONT &rarr; GPON (OLT) &rarr; METRO AKSES &rarr; METRO CORE &rarr; SWAGGR (L3) &rarr; WAC (WLC)</strong> telah terekam dan terverifikasi secara presisi dengan datek CLI &amp; GUI aktual.
        </p>
        <div class="mt-2 flex items-center gap-2 text-xs">
          <span class="w-2 h-2 rounded-full bg-amber-400 animate-pulse"></span>
          <span class="text-amber-300 font-medium">Notice Rekan ROC:</span>
          <span class="text-zinc-400">Hop 08 (WAG ISG session) dan Hop 09 (PE / BRAS &amp; AAA Portal WPGEN) telah disiapkan slotnya di bawah menunggu kiriman log CLI / skrip dari Anda.</span>
        </div>
      </div>
    </div>
    <div class="shrink-0 flex items-center gap-2">
      <a href="#hop-08" class="px-3 py-1.5 rounded-lg border border-zinc-700 bg-zinc-900 hover:bg-zinc-800 text-[11px] font-mono text-zinc-300 hover:text-white transition-colors">
        Slot Hop 08 &amp; 09 &darr;
      </a>
    </div>
  </div>
'@

$newBanner = @'
  <!-- ============================================================ -->
  <!-- ALERT BANNER: STATUS TRACING & NOTICE TO USER -->
  <!-- ============================================================ -->
  <div class="p-5 rounded-2xl border border-zinc-800 bg-zinc-950/90 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-sm">
    <div class="flex items-start gap-3.5">
      <div class="p-2.5 rounded-xl bg-zinc-900 border border-emerald-900/60 text-zinc-200 shrink-0">
        <svg class="w-5 h-5 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
      </div>
      <div>
        <div class="flex items-center gap-2">
          <span class="text-xs font-mono font-bold uppercase tracking-wider text-white">STATUS TRACING: SEGMENT 01 S/D 09 FULLY VERIFIED (E2E COMPLETE)</span>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">9 / 9 HOPS VERIFIED &amp; ONLINE</span>
        </div>
        <p class="text-xs text-zinc-400 mt-1 leading-relaxed">
          Tracing end-to-end dari <strong class="text-zinc-200">AP &rarr; ONT &rarr; GPON (OLT) &rarr; METRO AKSES &rarr; METRO CORE &rarr; SWAGGR (L3) &rarr; WAC (WLC) &rarr; WAG (BNG) &rarr; PE / BRAS CORE INTERNET</strong> telah 100% terekam dan terverifikasi secara presisi dengan datek CLI live lapangan dari DATIN ROC.
        </p>
        <div class="mt-2 flex items-center gap-2 text-xs">
          <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
          <span class="text-emerald-300 font-medium">Update Live DATIN ROC:</span>
          <span class="text-zinc-400">Hop 06 (SWAGGR Po10 20G &amp; MAC c828.e58a.ee18), Hop 08 (WAG-D5-KBL GE6/0/0 dot1q), dan Hop 09 (PE-D5-KBL-HSI 3x Trunks) kini terverifikasi utuh.</span>
        </div>
      </div>
    </div>
    <div class="shrink-0 flex items-center gap-2">
      <a href="#hop-08" class="px-3 py-1.5 rounded-lg border border-zinc-700 bg-zinc-900 hover:bg-zinc-800 text-[11px] font-mono text-zinc-300 hover:text-white transition-colors">
        Lihat Hop 08 &amp; 09 &darr;
      </a>
    </div>
  </div>
'@

# 2. Update Pipeline Hop 08 & 09
$oldPipelineHops = @'
        <div class="flex items-center text-zinc-600 border-dashed">&dash;&rarr;</div>

        <!-- HOP 08 (Pending) -->
        <a href="#hop-08" class="flex-1 p-3.5 rounded-xl border border-dashed border-amber-800/80 bg-zinc-950 hover:bg-zinc-900 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-amber-400">HOP 08</span>
              <span class="text-[9px] font-mono px-1.5 py-0.2 rounded bg-amber-950/80 border border-amber-800 text-amber-300">PENDING</span>
            </div>
            <div class="text-xs font-bold text-zinc-300">WAG / PORTAL</div>
            <div class="text-[10px] text-zinc-500 mt-0.5">Cisco ISG / AAA WPGEN</div>
            <div class="text-[10px] font-mono text-amber-300/80 mt-1.5">VLAN 1378 (172.17.67.3)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-amber-400/80">
            Menunggu datek user
          </div>
        </a>

        <div class="flex items-center text-zinc-600 border-dashed">&dash;&rarr;</div>

        <!-- HOP 09 (Pending) -->
        <a href="#hop-09" class="flex-1 p-3.5 rounded-xl border border-dashed border-amber-800/80 bg-zinc-950 hover:bg-zinc-900 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-amber-400">HOP 09</span>
              <span class="text-[9px] font-mono px-1.5 py-0.2 rounded bg-amber-950/80 border border-amber-800 text-amber-300">PENDING</span>
            </div>
            <div class="text-xs font-bold text-zinc-300">PE / BRAS</div>
            <div class="text-[10px] text-zinc-500 mt-0.5">Internet Gateway BRAS</div>
            <div class="text-[10px] font-mono text-zinc-400 mt-1.5">BGP Default Route</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-amber-400/80">
            Menunggu datek user
          </div>
        </a>
'@

$newPipelineHops = @'
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 08 -->
        <a href="#hop-08" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 08</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">WAG (BNG)</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">WAG-D5-KBL</div>
            <div class="text-[10px] font-mono text-emerald-400 mt-1.5">GE6/0/0 (dot1q)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            Subscriber QoS &amp; BAS
          </div>
        </a>

        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 09 -->
        <a href="#hop-09" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 09</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">PE / BRAS</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">PE-D5-KBL-HSI</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">Trunk 654/600/678</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            welcome2.wifi.id &amp; BGP
          </div>
        </a>
'@

if ($content.Contains($oldBanner)) {
    $content = $content.Replace($oldBanner, $newBanner)
    Write-Host "Banner updated."
} else {
    Write-Warning "Old banner not matched."
}

if ($content.Contains($oldPipelineHops)) {
    $content = $content.Replace($oldPipelineHops, $newPipelineHops)
    Write-Host "Pipeline hops updated."
} else {
    Write-Warning "Old pipeline hops not matched."
}

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
Write-Host "Done basic banner & pipeline update."
