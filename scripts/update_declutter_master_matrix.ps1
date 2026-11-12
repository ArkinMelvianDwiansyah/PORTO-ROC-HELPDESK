# PowerShell script to update Master Matrix, Hop 06 CLI, and Drawer

$e2ePath = "scripts\e2e_tracing_content.html"
$genPath = "scripts\generate_tabbed_site.ps1"

Write-Host "1. Reading $e2ePath..."
$e2e = [System.IO.File]::ReadAllText($e2ePath, [System.Text.Encoding]::UTF8)

# SVG Icons
$brainSvgSmall = '<svg class="w-3 h-3 text-emerald-400 shrink-0 inline-block" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/></svg>'

# --- NEW MASTER MATRIX SECTION ---
$newMasterMatrix = @"
  <!-- ============================================================ -->
  <!-- MASTER MATRIX: JALUR PORT, VLAN, MAC ADDRESS & UPLINK/DOWNLINK (DECLUTTERED & STREAMLINED) -->
  <!-- ============================================================ -->
  <div id="master-matrix" class="p-6 sm:p-8 rounded-2xl border-2 border-emerald-900/80 bg-zinc-950 space-y-6">
    <div class="flex flex-col lg:flex-row lg:items-center justify-between pb-4 border-b border-zinc-800 gap-4">
      <div>
        <div class="flex items-center gap-2 mb-1.5">
          <span class="px-2.5 py-0.5 rounded-full bg-emerald-950 border border-emerald-800 text-emerald-400 font-mono text-[10px] font-bold">PHYSICAL &amp; LOGICAL NETWORK MAPPING</span>
          <span class="text-zinc-500 text-xs font-mono">&bull; 100% COMPLETE &bull; 9 HOPS E2E</span>
        </div>
        <h2 class="text-xl font-bold text-white tracking-tight">Matriks Lengkap Jalur Port, VLAN, MAC Address, Uplink &amp; Downlink (9 Hops)</h2>
        <p class="text-xs text-zinc-400 mt-1 max-w-4xl leading-relaxed">
          Peta komprehensif jalur fisik, port interface, enkapsulasi VLAN masuk/keluar, dan resolusi MAC address dari Access Point hingga Core Internet Gateway BRAS.
        </p>
      </div>
      <div class="flex flex-wrap items-center gap-3">
        <!-- Interactive View Switcher -->
        <div class="flex items-center p-1 rounded-xl bg-black border border-zinc-800 shrink-0">
          <button id="btn-matrix-table-view" onclick="switchMatrixView('table')" class="px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-emerald-950 border border-emerald-700 text-emerald-300 cursor-pointer shadow-sm">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
            <span>Tabel Ringkas NOC</span>
          </button>
          <button id="btn-matrix-grid-view" onclick="switchMatrixView('grid')" class="px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-transparent border border-transparent text-zinc-400 hover:text-white cursor-pointer">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/></svg>
            <span>Kartu Alur 9 Hops</span>
          </button>
        </div>
        <div class="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-zinc-900 border border-zinc-800 shrink-0">
          <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          <span class="text-xs font-mono text-emerald-400 font-semibold">ALL 9 HOPS MAP VERIFIED</span>
        </div>
      </div>
    </div>

    <!-- Visual Highway Flowchart Ribbon (Clean Subway View) -->
    <div class="p-3.5 rounded-xl bg-black border border-zinc-800/80 overflow-x-auto">
      <div class="text-[10px] font-mono text-zinc-400 uppercase tracking-wider mb-2.5 flex items-center justify-between">
        <span class="flex items-center gap-1.5">
          <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
          VISUAL PACKET HIGHWAY: ENKAPSULASI PORT &amp; VLAN PER SIMPUL
        </span>
        <span class="text-emerald-400 text-[10px] font-mono">L1 (Fisik) &rarr; L2 (VLAN/MAC) &rarr; L3 (IP/SVI) &rarr; BNG/PE (Egress)</span>
      </div>
      <div class="flex items-center gap-1.5 min-w-[1020px] text-[11px] font-mono">
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">01 &bull; AP (c828.ee18)</div>
          <div class="font-bold text-emerald-400 text-xs">LAN RJ45</div>
          <div class="text-[9px] text-zinc-400">Untagged</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">02 &bull; ONT (ZTE F670L)</div>
          <div class="font-bold text-emerald-400 text-xs">eth_0/1 &rarr; PON</div>
          <div class="text-[9px] text-zinc-300">Tag VLAN 195</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">03 &bull; GPON OLT</div>
          <div class="font-bold text-emerald-400 text-xs">1/8/16 &rarr; sg1</div>
          <div class="text-[9px] text-zinc-300">Trunk VLAN 195</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">04 &bull; ME Akses</div>
          <div class="font-bold text-emerald-400 text-xs">Eth-Trunk2.195</div>
          <div class="text-[9px] text-emerald-400">VSI 245132851</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">05 &bull; ME Core</div>
          <div class="font-bold text-emerald-400 text-xs">Trunk23.2851</div>
          <div class="text-[9px] text-white font-bold">dot1q 2851</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">06 &bull; SWAGGR L3</div>
          <div class="font-bold text-emerald-400 text-xs">Po10 (20G)</div>
          <div class="text-[9px] text-emerald-400">SVI 10.5.130.1</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">07 &bull; Cisco WLC</div>
          <div class="font-bold text-emerald-400 text-xs">Port 1 (CAPWAP)</div>
          <div class="text-[9px] text-zinc-300">Dyn 1378</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">08 &bull; Huawei WAG</div>
          <div class="font-bold text-emerald-400 text-xs">GE6/0/0 Sub-Ints</div>
          <div class="text-[9px] text-emerald-400">VLAN 1372/1382</div>
        </div>
        <div class="text-zinc-600 font-bold">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-center flex-1">
          <div class="text-[9px] text-zinc-400 font-sans">09 &bull; PE Core</div>
          <div class="font-bold text-emerald-400 text-xs">Trunk 654/600</div>
          <div class="text-[9px] text-emerald-400">CGNAT &amp; BGP</div>
        </div>
      </div>
    </div>

    <!-- VIEW 1: STREAMLINED NOC TABLE (5 COLUMNS - CLEAN & SPACIOUS) -->
    <div id="matrix-table-container" class="overflow-x-auto rounded-xl border border-zinc-800">
      <table class="w-full text-left text-xs font-mono border-collapse min-w-[950px]">
        <thead>
          <tr class="bg-zinc-900/90 text-zinc-400 border-b border-zinc-800 text-[10px] uppercase tracking-wider">
            <th class="py-3.5 px-4 font-semibold w-1/5">Hop &amp; Perangkat</th>
            <th class="py-3.5 px-4 font-semibold w-1/5">Jalur Ingress (Downlink)</th>
            <th class="py-3.5 px-4 font-semibold w-1/5">Jalur Egress (Uplink)</th>
            <th class="py-3.5 px-4 font-semibold w-1/5 text-emerald-400">Identitas Jaringan (MAC / IP)</th>
            <th class="py-3.5 px-4 font-semibold w-1/5 text-right pr-6">Peer Target &amp; Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-zinc-800/70 text-[11px] text-zinc-300 bg-zinc-950/70">
          
          <!-- HOP 01 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">01</span>
                <div>
                  <div class="font-bold text-white">AP Cisco C9105AXI-F</div>
                  <div class="text-[10px] text-zinc-500 font-sans">Venue Warkop Koramil</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Radio RF 2.4/5GHz</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-400">Untagged</span> Wi-Fi 6 802.11ax</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">LAN RJ45 (PoE In)</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-400">Untagged</span> 1000Base-T Copper</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c8:28:e5:8a:ee:18</div>
              <div class="text-[10px] text-zinc-400">IP: 10.5.130.154 &bull; SN: FGL2702LHYR</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">ONT ZTE F670L</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">Port LAN: eth_0/1</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (1G)</span>
            </td>
          </tr>

          <!-- HOP 02 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">02</span>
                <div>
                  <div class="font-bold text-white">ONT ZTE F670L</div>
                  <div class="text-[10px] text-zinc-500 font-sans">CPE Modem Venue</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">eth_0/1 (Gigabit RJ45)</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span> Tagged via OMCI</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Port Optik PON SC/UPC</div>
              <div class="text-[10px] text-zinc-400">Tx 1310nm / Rx 1490nm Laser &bull; <span class="text-emerald-400">TCONT 1</span></div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-zinc-200">SN: ZTEGC80E6E92</div>
              <div class="text-[10px] text-zinc-400">Forwarding AP MAC .ee18 &bull; Dropcore 6.3 Km</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">GPON OLT C300v2</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">gpon-onu_1/8/16:7</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">ONLINE</span>
            </td>
          </tr>

          <!-- HOP 03 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">03</span>
                <div>
                  <div class="font-bold text-white">OLT ZTE C300v2</div>
                  <div class="text-[10px] text-zinc-500 font-sans">GPON04-D5-GSK-3 (Gresik)</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">gpon_1/8/16:7</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span> service-port 3 vport 1</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">smartgroup1 (20G LAG)</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span> Tagged Uplink Trunk</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">Tercatat di MAC table Slot 8 &bull; 0 CRC</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">ME-D5-GSK-3 (Huawei)</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">Port: Eth-Trunk2</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (20G)</span>
            </td>
          </tr>

          <!-- HOP 04 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">04</span>
                <div>
                  <div class="font-bold text-white">ME Akses Huawei CX600</div>
                  <div class="text-[10px] text-zinc-500 font-sans">ME-D5-GSK-3 (STO Gresik)</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Eth-Trunk2.195</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span> dot1q-termination</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">MPLS PW LDP Tunnel</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">VSI 245132851</span> WIFI_6_SBU_2851</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">Peer IP Core: 172.31.64.106</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">ME9-D5-KBL (Kebalen)</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">MPLS LDP Core Tunnel</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">FORWARD</span>
            </td>
          </tr>

          <!-- HOP 05 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">05</span>
                <div>
                  <div class="font-bold text-white">ME Core Tier-1 CX600</div>
                  <div class="text-[10px] text-zinc-500 font-sans">ME9-D5-KBL (STO Kebalen)</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">MPLS LDP Ingress</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">VSI 245132851</span> Dari IP 172.31.64.15</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Eth-Trunk23.2851</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">VLAN 2851</span> dot1q termination</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">Forwarding ke Eth-Trunk23</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">SWAGGR-D5-KBL-CS</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">Port-channel10 (Te1/0/1-2)</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (20G)</span>
            </td>
          </tr>

          <!-- HOP 06 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center text-[10px] font-bold">06</span>
                <div>
                  <div class="font-bold text-white">SWAGGR-D5-KBL-CS</div>
                  <div class="text-[10px] text-emerald-400 font-sans">Cisco Catalyst 6800 L3</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Port-channel10 (20G)</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">VLAN 2851</span> VL_AP_WLC02_KBL_WIFI6</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Te1/0/7 (To WAG) &amp; Te1/0/4</div>
              <div class="text-[10px] text-zinc-400">SVI <span class="text-emerald-400 font-mono">10.5.130.1/23</span> &bull; Lo85402 &bull; Vl535</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c828.e58a.ee18 DYNAMIC Po10</div>
              <div class="text-[10px] text-zinc-400">SVI: f4bd.9e32.8755 &bull; IP: 10.5.130.154</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">WAG-D5-KBL &amp; WLC02</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">WAG: GE6/0/0 &bull; WLC: Port 1</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">L3 GATEWAY</span>
            </td>
          </tr>

          <!-- HOP 07 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-200 inline-flex items-center justify-center text-[10px] font-bold">07</span>
                <div>
                  <div class="font-bold text-white">WLC02-D5-KBL-CS</div>
                  <div class="text-[10px] text-zinc-500 font-sans">Cisco 8540 AireOS</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Port 1 (10G SFP+)</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-300">VLAN 4035 &amp; 2851</span> CAPWAP UDP</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Dynamic telkom.id-wag</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 1378 &amp; 1372</span> IP: 172.17.67.3</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">IP AP: 10.5.130.154 &bull; NAT: .118</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">WAG-D5-KBL (Huawei)</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">GE6/0/0.1378 &amp; .1382</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">REG (UP)</span>
            </td>
          </tr>

          <!-- HOP 08 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center text-[10px] font-bold">08</span>
                <div>
                  <div class="font-bold text-white">WAG-D5-KBL (BNG)</div>
                  <div class="text-[10px] text-emerald-400 font-sans">Huawei ME60 Gateway</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">GE6/0/0 (10G Trunk)</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">10 Sub-interfaces</span> .1372, .1382, .1370..</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">GE1/0/0, 4/0/0, 7/1/0</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">Routed HSI IP</span> 3x Uplink Trunks</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">Subscriber MAC Table</div>
              <div class="text-[10px] text-zinc-400">Per-MAC QoS &bull; CoA 3799 &bull; BAS Domain</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">PE-D5-KBL-HSI</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">Ports: 654, 600, 678</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">ONLINE</span>
            </td>
          </tr>

          <!-- HOP 09 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="py-3.5 px-4">
              <div class="flex items-center gap-2">
                <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center text-[10px] font-bold">09</span>
                <div>
                  <div class="font-bold text-white">PE-D5-KBL-HSI</div>
                  <div class="text-[10px] text-emerald-400 font-sans">Core Internet Router</div>
                </div>
              </div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Ports 654, 600, 678</div>
              <div class="text-[10px] text-zinc-400"><span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-zinc-300">VLAN 535 / P2P</span> Core Subscriber Streams</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="text-white font-semibold">Backbone WAN (100G)</div>
              <div class="text-[10px] text-emerald-400"><span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">eBGP Default Transit</span> AS7713 Core</div>
            </td>
            <td class="py-3.5 px-4">
              <div class="font-bold text-emerald-400">CGNAT Session Translation</div>
              <div class="text-[10px] text-zinc-400">Public IP Pool Allocation</div>
            </td>
            <td class="py-3.5 px-4 text-right pr-6">
              <div class="text-zinc-200 font-semibold">Global Internet &amp; AAA</div>
              <div class="text-[10px] text-emerald-400 font-semibold mb-1">welcome2.wifi.id (WPGEN)</div>
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">CORE BGP</span>
            </td>
          </tr>

        </tbody>
      </table>
    </div>

    <!-- VIEW 2: RESPONSIVE CARD GRID (9 HOPS CARDS - SLEEK & MODERN) -->
    <div id="matrix-grid-container" class="hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      
      <!-- CARD 01 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">01</span>
              <div>
                <div class="text-xs font-bold text-white">AP Cisco C9105AXI-F</div>
                <div class="text-[10px] text-zinc-400 font-sans">Venue Warkop Koramil</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">UP (1G)</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">Radio RF 2.4/5 GHz &bull; Untagged</div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">LAN RJ45 (PoE In) &bull; Untagged</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">MAC &amp; IP</div>
              <div class="text-emerald-300 font-bold text-[11px]">c8:28:e5:8a:ee:18</div>
              <div class="text-[10px] text-zinc-400">10.5.130.154 &bull; FGL2702LHYR</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">ONT eth_0/1</strong></span>
          <button onclick="openExplainerHop('01')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 02 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-zinc-800 text-zinc-200 font-mono font-bold text-xs flex items-center justify-center">02</span>
              <div>
                <div class="text-xs font-bold text-white">ONT ZTE F670L</div>
                <div class="text-[10px] text-zinc-400 font-sans">CPE Modem Venue</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">ONLINE</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">eth_0/1 &bull; <span class="text-emerald-400">Tag VLAN 195</span></div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">Port Optik PON &bull; GEMPORT 1</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">Modem SN &amp; Optik</div>
              <div class="text-emerald-300 font-bold text-[11px]">SN: ZTEGC80E6E92</div>
              <div class="text-[10px] text-zinc-400">Rx -20.65 dBm &bull; Jarak 6.3 Km</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">OLT 1/8/16:7</strong></span>
          <button onclick="openExplainerHop('02')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 03 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-zinc-800 text-zinc-200 font-mono font-bold text-xs flex items-center justify-center">03</span>
              <div>
                <div class="text-xs font-bold text-white">OLT ZTE C300v2</div>
                <div class="text-[10px] text-zinc-400 font-sans">GPON04-D5-GSK-3</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">UP (20G)</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">gpon_1/8/16:7 &bull; <span class="text-emerald-400">VLAN 195</span></div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">smartgroup1 (20G) &bull; Trunk 195</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">MAC Table Slot 8</div>
              <div class="text-emerald-300 font-bold text-[11px]">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">service-port 3 vport 1</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">ME Eth-Trunk2</strong></span>
          <button onclick="openExplainerHop('03')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 04 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-zinc-800 text-zinc-200 font-mono font-bold text-xs flex items-center justify-center">04</span>
              <div>
                <div class="text-xs font-bold text-white">ME Akses Huawei CX600</div>
                <div class="text-[10px] text-zinc-400 font-sans">ME-D5-GSK-3 (STO Gresik)</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">FORWARD</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">Eth-Trunk2.195 &bull; dot1q vid 195</div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">MPLS PW &bull; <span class="text-emerald-400">VSI 245132851</span></div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">L2VPN VSI MAC</div>
              <div class="text-emerald-300 font-bold text-[11px]">c828.e58a.ee18</div>
              <div class="text-[10px] text-zinc-400">WIFI_6_SBU_2851</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">ME9 Core Tunnel</strong></span>
          <button onclick="openExplainerHop('04')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 05 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-zinc-800 text-zinc-200 font-mono font-bold text-xs flex items-center justify-center">05</span>
              <div>
                <div class="text-xs font-bold text-white">ME Core Tier-1 CX600</div>
                <div class="text-[10px] text-zinc-400 font-sans">ME9-D5-KBL (Kebalen)</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">UP (20G)</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">MPLS LDP &bull; VSI 245132851</div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">Eth-Trunk23.2851 &bull; dot1q 2851</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">Translasi VLAN</div>
              <div class="text-white font-bold text-[11px]">VLAN 195 &rarr; VLAN 2851</div>
              <div class="text-[10px] text-zinc-400">c828.e58a.ee18 forwarded</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">SWAGGR Po10</strong></span>
          <button onclick="openExplainerHop('05')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 06 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border-2 border-emerald-800 hover:border-emerald-600 transition-all flex flex-col justify-between space-y-3 bg-emerald-950/20">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-emerald-500 text-black font-mono font-bold text-xs flex items-center justify-center">06</span>
              <div>
                <div class="text-xs font-bold text-white">SWAGGR-D5-KBL-CS</div>
                <div class="text-[10px] text-emerald-400 font-sans">Catalyst 6800 L3</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">L3 GATEWAY</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">Po10 (20G) &bull; <span class="text-emerald-400">VLAN 2851</span></div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">Te1/0/7 (To WAG) &amp; Te1/0/4</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">Exact Match Po10 &bull; SVI</div>
              <div class="text-emerald-300 font-bold text-[11px]">c828.e58a.ee18 DYNAMIC Po10</div>
              <div class="text-[10px] text-zinc-400">SVI 10.5.130.1 &bull; Avg Load 5%</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">WAG GE6/0/0</strong></span>
          <button onclick="openExplainerHop('06')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 07 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-zinc-800 text-zinc-200 font-mono font-bold text-xs flex items-center justify-center">07</span>
              <div>
                <div class="text-xs font-bold text-white">WLC02-D5-KBL-CS</div>
                <div class="text-[10px] text-zinc-400 font-sans">Cisco 8540 AireOS</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">REG (UP)</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">Port 1 (10G) &bull; CAPWAP UDP 5246</div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">Dyn telkom.id-wag &bull; VLAN 1378</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">Controller AP State</div>
              <div class="text-emerald-300 font-bold text-[11px]">c828.e58a.ee18 Registered</div>
              <div class="text-[10px] text-zinc-400">10.5.130.154 &bull; 8.909 Klien</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">WAG GE6/0/0.1378</strong></span>
          <button onclick="openExplainerHop('07')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 08 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-emerald-500 text-black font-mono font-bold text-xs flex items-center justify-center">08</span>
              <div>
                <div class="text-xs font-bold text-white">WAG-D5-KBL (BNG)</div>
                <div class="text-[10px] text-emerald-400 font-sans">Huawei ME60 Gateway</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">ONLINE</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">GE6/0/0 &bull; <span class="text-emerald-400">10 Sub-interfaces</span></div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">GE1/0/0, 4/0/0, 7/1/0 (3x Uplink)</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">Subscriber Domain</div>
              <div class="text-emerald-300 font-bold text-[11px]">BAS Subscriber Table</div>
              <div class="text-[10px] text-zinc-400">QoS &bull; CoA UDP 3799 Active</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">PE Ports 654/600</strong></span>
          <button onclick="openExplainerHop('08')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

      <!-- CARD 09 -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 hover:border-emerald-800 transition-all flex flex-col justify-between space-y-3">
        <div>
          <div class="flex items-center justify-between pb-2 border-b border-zinc-800">
            <div class="flex items-center gap-2">
              <span class="w-6 h-6 rounded-lg bg-emerald-500 text-black font-mono font-bold text-xs flex items-center justify-center">09</span>
              <div>
                <div class="text-xs font-bold text-white">PE-D5-KBL-HSI</div>
                <div class="text-[10px] text-emerald-400 font-sans">Core Internet Gateway</div>
              </div>
            </div>
            <span class="px-2 py-0.5 rounded bg-emerald-950 text-emerald-400 font-mono text-[9px] font-bold">CORE BGP</span>
          </div>
          <div class="mt-3 space-y-2 text-xs font-mono">
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Ingress (Downlink)</div>
              <div class="text-white font-semibold text-[11px]">Ports 654, 600, 678 &bull; VLAN 535</div>
            </div>
            <div class="p-2 rounded bg-black/60 border border-zinc-850">
              <div class="text-[10px] text-zinc-500 uppercase">Egress (Uplink)</div>
              <div class="text-white font-semibold text-[11px]">Core Backbone WAN &bull; eBGP Transit</div>
            </div>
            <div class="p-2 rounded bg-zinc-950 border border-emerald-900/40">
              <div class="text-[10px] text-emerald-400 font-semibold uppercase">CGNAT &amp; AAA Portal</div>
              <div class="text-emerald-300 font-bold text-[11px]">AS7713 Telkom Core</div>
              <div class="text-[10px] text-zinc-400">welcome2.wifi.id (WPGEN)</div>
            </div>
          </div>
        </div>
        <div class="pt-2 border-t border-zinc-800 flex items-center justify-between text-[11px]">
          <span class="text-zinc-400">Peer: <strong class="text-white">Global Internet</strong></span>
          <button onclick="openExplainerHop('09')" class="text-emerald-400 hover:text-emerald-300 font-mono text-[10px] flex items-center gap-1 cursor-pointer">$brainSvgSmall Jelasin &rarr;</button>
        </div>
      </div>

    </div>

    <!-- DETAIL PORT INTERCONNECT SCHEDULE (SWAGGR WITH CONTROLLER UTILIZATION & WAG) -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-5 pt-2">
      
      <!-- Box 1: SWAGGR Detailed Port Map & Utilization Metrics -->
      <div class="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
        <div class="flex items-center justify-between border-b border-zinc-800/80 pb-2">
          <div class="flex items-center gap-2">
            <span class="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
            <span class="text-xs font-mono font-bold text-white">DETAIL PORT INVENTORY &amp; UTILISASI: SWAGGR</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-400">Catalyst 6800 &bull; Avg 5%</span>
        </div>
        <div class="space-y-2 text-xs font-mono">
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">Port-channel10</span>
              <span class="text-zinc-400 text-[11px]"> (Te1/0/1 + Te1/0/2) &bull; LAG 20G</span>
              <div class="text-[10px] text-zinc-400">Downlink ME9 &bull; <span class="text-zinc-300">Te1/0/1 (Rx 2% / Tx 15%), Te1/0/2 (Rx 2% / Tx 22%)</span></div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (4.2G Out)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">Te1/0/4</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Trunk ke WLC02 Port 1 (10G SFP+)</span>
              <div class="text-[10px] text-zinc-400"><strong class="text-emerald-400 font-semibold">Rx 40% &bull; Tx 39%</strong> &bull; Beban Tertinggi Switch (CAPWAP 8.909 Klien)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (Active)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">Te1/0/7</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Uplink ke WAG-D5-KBL (GE6/0/0)</span>
              <div class="text-[10px] text-zinc-400"><strong class="text-emerald-400 font-semibold">Rx 34% &bull; Tx 4%</strong> &bull; Downlink Trafik Subscriber dari Gateway</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (Connected)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Te1/0/3</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Uplink ke WLC01 Port 1</span>
              <div class="text-[10px] text-zinc-400">Rx 1% &bull; Tx 0% (Standby WLC Controller)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-400 font-bold">UP (Standby)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Te1/1/1 &amp; Te1/1/2</span>
              <span class="text-zinc-400 text-[11px]"> &bull; 1000BaseTX SFP</span>
              <div class="text-[10px] text-zinc-400">Port MGMT ke WAC05 &amp; WAC06 (VLAN 4035) &bull; Utilitas 0%</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (1 Gbps)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-zinc-400 font-bold">Te1/1/3, Te1/1/4, Te1/0/5</span>
              <div class="text-[10px] text-zinc-400">Port fisik kosong / slot transreceiver cadangan (Utilitas 0%)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-zinc-400">DOWN (notconnect)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-emerald-950/40 border border-emerald-800/80 flex items-center justify-between text-[11px]">
            <div class="text-emerald-300 font-semibold">&bull; Average Switch Utilization: <span class="text-white font-bold font-mono">5%</span> (Rx 5% / Tx 6%)</div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-900 text-emerald-200 font-mono font-bold">Headroom 95% Aman</span>
          </div>
        </div>
      </div>

      <!-- Box 2: WAG-D5-KBL Detailed Port Map -->
      <div class="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
        <div class="flex items-center justify-between border-b border-zinc-800/80 pb-2">
          <div class="flex items-center gap-2">
            <span class="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
            <span class="text-xs font-mono font-bold text-white">DETAIL PORT INVENTORY: WAG-D5-KBL</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-400">Huawei ME60 BNG</span>
        </div>
        <div class="space-y-2 text-xs font-mono">
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">GE6/0/0 (10G)</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Downlink Utama</span>
              <div class="text-[10px] text-zinc-400">Menyambung langsung ke SWAGGR Te1/0/7 &amp; WAC06</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (10G Trunk)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">GE1/0/0, 4/0/0, 7/1/0</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Uplink Core Trunks</span>
              <div class="text-[10px] text-zinc-400">Interkoneksi ke PE-D5-KBL-HSI (Port 654, 600, 678)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (3x Redundant)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Loopback 85401 &amp; 85402</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Inter-VRF WLC</span>
              <div class="text-[10px] text-zinc-400">Routing internal WLC01/02 Port 2 ke gateway WAG</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (L3 VRF)</span>
          </div>
          <div class="p-2.5 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-zinc-300 font-bold">GE2/0/0, 3/1/0, 6/1/0</span>
              <span class="text-zinc-400 text-[11px]"> &bull; WAC Interconnects</span>
              <div class="text-[10px] text-zinc-400">Interkoneksi ke WAC03 (Te1/2, Te5/4) &amp; WAC04 (Te1/3)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (LLDP Active)</span>
          </div>
        </div>
      </div>

    </div>

  </div>
"@

# Replace old master-matrix
$oldMasterMatrixRegex = '(?s)<!-- ============================================================ -->\s*<!-- MASTER MATRIX: JALUR PORT, VLAN, MAC ADDRESS & UPLINK/DOWNLINK -->.*?<!-- ============================================================ -->\s*<div id="deepdive-section"'

$replacement = $newMasterMatrix + "`n`n  <!-- ============================================================ -->`n  <div id=""deepdive-section"""

$e2e = [System.Text.RegularExpressions.Regex]::Replace($e2e, $oldMasterMatrixRegex, $replacement)

# --- ADD SHOW CONTROLLERS UTILIZATION CLI TO HOP 06 ---
$newHop06Cli = @"
          <div class="space-y-1.5">
            <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
              <span>7. UTILISASI BANDWIDTH PER CONTROLLER PORT (SHOW CONTROLLERS UTILIZATION)</span>
              <button onclick="copyCode('cli-hop-06g', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin</button>
            </div>
            <pre id="cli-hop-06g" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
SWAGGR-D5-KBL-CS#<span class="text-white font-bold">show controllers utilization</span> 
Port       Receive Utilization  Transmit Utilization
Te1/0/1            2                    15
Te1/0/2            2                    22
Te1/0/3            1                    0
<span class="text-emerald-400 font-bold">Te1/0/4           40                   39</span>   <span class="text-zinc-500"># Trunk ke WLC02 (Port 1) &bull; Beban Tertinggi!</span>
Te1/0/5            0                    0
Te1/0/6            0                    0
<span class="text-emerald-400 font-bold">Te1/0/7           34                    4</span>   <span class="text-zinc-500"># Interkoneksi ke WAG (GE6/0/0) &bull; Downlink Sub</span>
Te1/0/8            0                    0
Te1/0/9            0                    0
Te1/0/10           0                    0
Te1/0/11           0                    0
Te1/0/12           0                    0
Te1/1/1            0                    0
Te1/1/2            0                    0
Te1/1/3            0                    0
Te1/1/4            0                    0

Total Ports : 16
Total Ports Receive Bandwidth Percentage Utilization  : 5
Total Ports Transmit Bandwidth Percentage Utilization : 6

<span class="text-white font-bold">Average Switch  Percentage Utilization : 5</span></pre>
            <div class="p-3 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-300 space-y-1.5">
              <div class="text-emerald-400 font-semibold">&bull; Analisis Rekayasa Trafik (Traffic Engineering Analysis):</div>
              <ul class="list-disc list-inside text-zinc-400 text-[10px] space-y-1 ml-1 leading-relaxed">
                <li><strong class="text-white">Port Te1/0/4 (Rx 40% / Tx 39%):</strong> Interface paling sibuk pada SWAGGR. Menghubungkan langsung ke <strong class="text-white">WLC02-D5-KBL-CS Port 1</strong> untuk mengalirkan seluruh tunnel data CAPWAP dari 8.909 klien aktif.</li>
                <li><strong class="text-white">Port Te1/0/7 (Rx 34% / Tx 4%):</strong> Menghubungkan ke gateway <strong class="text-white">WAG-D5-KBL (GE6/0/0)</strong>. Rx 34% mencerminkan aliran downstream dari internet gateway menuju pelanggan.</li>
                <li><strong class="text-white">Po10 (Te1/0/1 Tx 15% &amp; Te1/0/2 Tx 22%):</strong> Distribusi transmit load balancing LACP 20G berjalan sangat seimbang (total Tx ~37%) menuju Metro Core ME9-D5-KBL.</li>
                <li><strong class="text-white">Average Switch Utilization 5%:</strong> Kapasitas switch Catalyst 6800 beroperasi sangat aman dengan sisa headroom 95%, membuktikan tidak ada packet drop atau saturasi hardware ASIC.</li>
              </ul>
            </div>
          </div>
"@

$targetHop06End = '<!-- Screenshot IP NAT List & SecureCRT -->'
if ($e2e.Contains($targetHop06End) -and -not $e2e.Contains('show controllers utilization')) {
    $e2e = $e2e.Replace($targetHop06End, $newHop06Cli + "`n`n      " + $targetHop06End)
    Write-Host "Added show controllers utilization to Hop 06."
}

[System.IO.File]::WriteAllText($e2ePath, $e2e, [System.Text.Encoding]::UTF8)
Write-Host "Saved updated $e2ePath."

# --- NOW UPDATE GENERATE_TABBED_SITE.PS1 ---
Write-Host "2. Reading $genPath..."
$gen = [System.IO.File]::ReadAllText($genPath, [System.Text.Encoding]::UTF8)

# Clean up drawer header mojibake
$oldDrawerHeaderRegex = '(?s)<div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400 font-black font-mono text-base shadow-sm">\s*dY.*?\s*</div>'
$newDrawerHeader = @"
<div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400 font-mono shadow-sm">
          <svg class="w-5 h-5 text-emerald-400 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z"/><path d="M12 5a3 3 0 1 1 5.997.125 4 4 0 0 1 2.526 5.77 4 4 0 0 1-.556 6.588A4 4 0 1 1 12 18Z"/><path d="M12 3v18"/><path d="M12 8a2 2 0 0 0-2 2"/><path d="M12 13a2 2 0 0 1 2 2"/></svg>
        </div>
"@
$gen = [System.Text.RegularExpressions.Regex]::Replace($gen, $oldDrawerHeaderRegex, $newDrawerHeader)

# Clean up comments
$gen = $gen.Replace('<!-- "JELASIN DONG! dY " DEEP EXPLAINER SLIDE-OUT DRAWER -->', '<!-- "JELASIN DONG!" DEEP EXPLAINER SLIDE-OUT DRAWER -->')
$gen = $gen.Replace('// Explainer "Jelasin Dong! dY " Controller', '// Explainer "Jelasin Dong!" Controller')

# Add item 4 in Hop 06 explainer card if not present
$explainerHop06Point4 = @"
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 4. Analisis Beban Utilitas Port (Show Controllers Utilization)</div>
            <p class="text-zinc-400 text-[11px]">
              Berdasarkan live controller audit DATIN ROC: Port <code class="text-emerald-400 font-mono">Te1/0/4</code> ke WLC02 mencatat utilisasi tertinggi (<strong class="text-white font-mono">Rx 40% / Tx 39%</strong>) karena mengangkut CAPWAP 8.909 klien aktif. Port <code class="text-emerald-400 font-mono">Te1/0/7</code> ke WAG mencatat Rx 34% untuk trafik downstream gateway. Rata-rata utilisasi switch hanya <strong class="text-emerald-400 font-mono">5%</strong>, sehingga switch beroperasi sangat aman dengan headroom kapasitas 95%.
            </p>
          </div>
"@

if (-not $gen.Contains('show controllers utilization') -and $gen.Contains('id="explainer-card-hop-07"')) {
    $targetExplainerHop06 = '<!-- CARD HOP 07 -->'
    $gen = $gen.Replace($targetExplainerHop06, $explainerHop06Point4 + "`n`n      " + $targetExplainerHop06)
    Write-Host "Added point 4 to Hop 06 explainer drawer card."
}

# Add switchMatrixView JS function to generate_tabbed_site.ps1
$jsMatrixSwitch = @"
    // Master Matrix View Switcher (Table vs Cards)
    function switchMatrixView(mode) {
      const tblContainer = document.getElementById('matrix-table-container');
      const gridContainer = document.getElementById('matrix-grid-container');
      const btnTable = document.getElementById('btn-matrix-table-view');
      const btnGrid = document.getElementById('btn-matrix-grid-view');
      if (!tblContainer || !gridContainer) return;

      if (mode === 'grid') {
        tblContainer.classList.add('hidden');
        gridContainer.classList.remove('hidden');
        btnGrid.className = 'px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-emerald-950 border border-emerald-700 text-emerald-300 cursor-pointer shadow-sm';
        btnTable.className = 'px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-transparent border border-transparent text-zinc-400 hover:text-white cursor-pointer';
      } else {
        gridContainer.classList.add('hidden');
        tblContainer.classList.remove('hidden');
        btnTable.className = 'px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-emerald-950 border border-emerald-700 text-emerald-300 cursor-pointer shadow-sm';
        btnGrid.className = 'px-3 py-1.5 rounded-lg text-xs font-mono font-semibold transition-all flex items-center gap-1.5 bg-transparent border border-transparent text-zinc-400 hover:text-white cursor-pointer';
      }
    }
"@

if (-not $gen.Contains('switchMatrixView')) {
    $gen = $gen.Replace('// Lightbox Controller', $jsMatrixSwitch + "`n`n    // Lightbox Controller")
    Write-Host "Added switchMatrixView JS function."
}

[System.IO.File]::WriteAllText($genPath, $gen, [System.Text.Encoding]::UTF8)
Write-Host "Saved updated $genPath."

Write-Host "SUCCESS! All templates updated cleanly."
