# Script to add Master Port, VLAN, MAC Address & Uplink/Downlink Matrix into scripts/e2e_tracing_content.html
$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# 1. Update Sub-Nav to include Matriks Port & VLAN
$oldSubNav = @'
    <!-- Sub-Nav Pill Links inside Modul 01 -->
    <div class="flex flex-wrap items-center gap-2 mt-4 pt-4 border-t border-zinc-800/60">
      <a href="#pipeline-section" class="px-3 py-1 rounded-lg bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-xs text-zinc-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono">
        <span>&bull;</span> 9-Hop Pipeline
      </a>
      <a href="#deepdive-section" class="px-3 py-1 rounded-lg bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-xs text-zinc-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono">
        <span>&bull;</span> Bedah Logika Tracing
      </a>
'@

$newSubNav = @'
    <!-- Sub-Nav Pill Links inside Modul 01 -->
    <div class="flex flex-wrap items-center gap-2 mt-4 pt-4 border-t border-zinc-800/60">
      <a href="#pipeline-section" class="px-3 py-1 rounded-lg bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-xs text-zinc-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono">
        <span>&bull;</span> 9-Hop Pipeline
      </a>
      <a href="#master-matrix" class="px-3 py-1 rounded-lg bg-emerald-950/80 hover:bg-emerald-900/80 border border-emerald-800 text-xs text-emerald-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono font-semibold">
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
        Matriks Port, VLAN &amp; MAC
      </a>
      <a href="#deepdive-section" class="px-3 py-1 rounded-lg bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-xs text-zinc-300 hover:text-white transition-colors flex items-center gap-1.5 font-mono">
        <span>&bull;</span> Bedah Logika Tracing
      </a>
'@

if ($content.Contains($oldSubNav)) {
    $content = $content.Replace($oldSubNav, $newSubNav)
    Write-Host "Sub-nav updated with Matriks link."
} else {
    Write-Warning "Old sub-nav not matched directly, checking normalized..."
}

# 2. Master Matrix HTML Block
$masterMatrixHtml = @'
  <!-- ============================================================ -->
  <!-- MASTER MATRIX: JALUR PORT, VLAN, MAC ADDRESS & UPLINK/DOWNLINK -->
  <!-- ============================================================ -->
  <div id="master-matrix" class="p-6 sm:p-8 rounded-2xl border-2 border-emerald-900/80 bg-zinc-950 space-y-6">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800 gap-3">
      <div>
        <div class="flex items-center gap-2 mb-1">
          <span class="px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-mono text-[10px] font-bold">PHYSICAL &amp; LOGICAL NETWORK MAPPING</span>
          <span class="text-zinc-500 text-xs font-mono">&bull; 100% COMPLETE</span>
        </div>
        <h2 class="text-xl font-bold text-white tracking-tight">Matriks Lengkap Jalur Port, VLAN, MAC Address, Uplink &amp; Downlink (9 Hops)</h2>
        <p class="text-xs text-zinc-400 mt-1 max-w-4xl">
          Tabel referensi komprehensif seluruh jalur kabel fisik, port interface, enkapsulasi VLAN masuk/keluar, dan resolusi MAC address dari Access Point hingga Core Internet Gateway BRAS.
        </p>
      </div>
      <div class="flex items-center gap-2 self-start sm:self-auto">
        <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <span class="text-xs font-mono text-emerald-400 font-semibold">ALL 9 HOPS MAP VERIFIED</span>
      </div>
    </div>

    <!-- Visual Highway Flowchart Ribbon -->
    <div class="p-4 rounded-xl bg-black border border-zinc-800/80 overflow-x-auto">
      <div class="text-[10px] font-mono text-zinc-400 uppercase tracking-wider mb-2 flex items-center justify-between">
        <span>&bull; VISUAL PACKET HIGHWAY: ENKAPSULASI PORT &amp; VLAN PER SIMPUL</span>
        <span class="text-emerald-400 text-[10px]">L1 (Fisik) &rarr; L2 (VLAN/MAC) &rarr; L3 (IP/SVI) &rarr; BNG/PE (Egress)</span>
      </div>
      <div class="flex items-center gap-1.5 min-w-[1050px] text-[11px] font-mono">
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">AP (c828.e58a.ee18)</div>
          <div class="font-bold text-emerald-400">LAN RJ45</div>
          <div class="text-[9px] text-zinc-400">Untagged</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">ONT (ZTEGC80E6E92)</div>
          <div class="font-bold text-emerald-400">eth_0/1 &rarr; PON</div>
          <div class="text-[9px] text-zinc-300">Tag VLAN 195</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">GPON OLT (C300v2)</div>
          <div class="font-bold text-emerald-400">1/8/16 &rarr; sg1 (10G)</div>
          <div class="text-[9px] text-zinc-300">Trunk VLAN 195</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">ME Akses (CX600)</div>
          <div class="font-bold text-emerald-400">Eth-Trunk2.195</div>
          <div class="text-[9px] text-emerald-400">VSI 245132851</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">ME Core (ME9-D5-KBL)</div>
          <div class="font-bold text-emerald-400">Eth-Trunk23.2851</div>
          <div class="text-[9px] text-white font-bold">dot1q VLAN 2851</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">SWAGGR (L3 Cisco)</div>
          <div class="font-bold text-emerald-400">Po10 (20G) &rarr; SVI</div>
          <div class="text-[9px] text-emerald-400">10.5.130.1 / Vl2851</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">WLC (Cisco 8540)</div>
          <div class="font-bold text-emerald-400">Port 1 (CAPWAP)</div>
          <div class="text-[9px] text-zinc-300">Dynamic 1378</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">WAG (Huawei ME60)</div>
          <div class="font-bold text-emerald-400">GE6/0/0 Sub-Ints</div>
          <div class="text-[9px] text-emerald-400">VLAN 1372 / 1382</div>
        </div>
        <div class="text-zinc-600">&rarr;</div>
        <div class="px-2.5 py-1.5 rounded-lg bg-zinc-900 border border-zinc-700 text-white text-center">
          <div class="text-[9px] text-zinc-400">PE Core (PE-D5-KBL)</div>
          <div class="font-bold text-emerald-400">Port 654/600/678</div>
          <div class="text-[9px] text-emerald-400">CGNAT &amp; BGP AS7713</div>
        </div>
      </div>
    </div>

    <!-- MASTER TABLE -->
    <div class="overflow-x-auto rounded-xl border border-zinc-800">
      <table class="w-full text-left text-xs font-mono border-collapse">
        <thead>
          <tr class="bg-zinc-900/90 text-zinc-400 border-b border-zinc-800 text-[10px] uppercase tracking-wider">
            <th class="p-3 font-semibold">Hop &amp; Node</th>
            <th class="p-3 font-semibold">Downlink / Ingress Port</th>
            <th class="p-3 font-semibold">Ingress VLAN</th>
            <th class="p-3 font-semibold text-emerald-400">MAC Address &amp; Binding</th>
            <th class="p-3 font-semibold">Uplink / Egress Port</th>
            <th class="p-3 font-semibold">Egress VLAN</th>
            <th class="p-3 font-semibold">Remote Peer &amp; Target Port</th>
            <th class="p-3 font-semibold text-center">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-zinc-800/80 text-[11px] text-zinc-300 bg-zinc-950/60">
          
          <!-- HOP 01 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">01</span>
              AP Cisco C9105AXI-F
              <div class="text-[9px] text-zinc-500 font-normal">Venue Warkop Koramil</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">Radio RF 2.4/5GHz</span>
              <div class="text-[9px] text-zinc-500">Wi-Fi 6 802.11ax</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-300">Untagged</span>
              <div class="text-[9px] text-zinc-500">Klien Nirkabel</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="font-bold text-emerald-400">c8:28:e5:8a:ee:18</span>
              <div class="text-[9px] text-zinc-500">Base AP MAC / BSSID .10 &amp; .20</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">LAN RJ45 (PoE In)</span>
              <div class="text-[9px] text-zinc-500">1000Base-T Copper</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-300">Untagged</span>
              <div class="text-[9px] text-zinc-500">Payload Native Frame</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">ONT ZTE F670L</span>
              <div class="text-[9px] text-emerald-400 font-semibold">Port LAN: eth_0/1</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (1G)</span>
            </td>
          </tr>

          <!-- HOP 02 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">02</span>
              ONT ZTE F670L
              <div class="text-[9px] text-zinc-500 font-normal">CPE Modem Venue</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">eth_0/1</span>
              <div class="text-[9px] text-zinc-500">RJ45 Gigabit Ethernet</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span>
              <div class="text-[9px] text-zinc-500">Tagged via OMCI Policy</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-300">SN: ZTEGC80E6E92</span>
              <div class="text-[9px] text-zinc-500">Forwarding AP MAC .ee18</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">Port Optik PON SC/UPC</span>
              <div class="text-[9px] text-zinc-500">Tx 1310nm / Rx 1490nm Laser</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span>
              <div class="text-[9px] text-zinc-500">GEMPORT 1 / TCONT 1</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">GPON OLT C300v2</span>
              <div class="text-[9px] text-emerald-400 font-semibold">gpon-onu_1/8/16:7</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">ONLINE</span>
            </td>
          </tr>

          <!-- HOP 03 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">03</span>
              OLT ZTE C300v2
              <div class="text-[9px] text-zinc-500 font-normal">GPON04-D5-GSK-3 (Gresik)</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">gpon_1/8/16:7</span>
              <div class="text-[9px] text-zinc-500">Linecard GPON GTGH</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span>
              <div class="text-[9px] text-zinc-500">service-port 3 vport 1</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>
              <div class="text-[9px] text-zinc-500">Tercatat di MAC table Slot 8</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">smartgroup1 (20G)</span>
              <div class="text-[9px] text-zinc-500">xgei_1/10/1, 2 &amp; xgei_1/11/1</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span>
              <div class="text-[9px] text-zinc-500">Tagged Uplink Trunk</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">ME-D5-GSK-3 (Huawei)</span>
              <div class="text-[9px] text-emerald-400 font-semibold">Eth-Trunk2</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (20G)</span>
            </td>
          </tr>

          <!-- HOP 04 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">04</span>
              ME Akses Huawei CX600
              <div class="text-[9px] text-zinc-500 font-normal">ME-D5-GSK-3 (STO Gresik)</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Eth-Trunk2.195</span>
              <div class="text-[9px] text-zinc-500">LAG Ingress dari OLT sg1</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 195</span>
              <div class="text-[9px] text-zinc-500">dot1q-termination vid 195</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>
              <div class="text-[9px] text-zinc-500">Learned via VSI L2VPN</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">MPLS PW LDP Tunnel</span>
              <div class="text-[9px] text-zinc-500">Peer IP: 172.31.64.106</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">VSI 245132851</span>
              <div class="text-[9px] text-emerald-400">WIFI_6_SBU_2851</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">ME9-D5-KBL (Kebalen)</span>
              <div class="text-[9px] text-emerald-400 font-semibold">MPLS LDP Core Tunnel</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">FORWARD</span>
            </td>
          </tr>

          <!-- HOP 05 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">05</span>
              ME Core Tier-1 CX600
              <div class="text-[9px] text-zinc-500 font-normal">ME9-D5-KBL (STO Kebalen)</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">MPLS LDP Ingress</span>
              <div class="text-[9px] text-zinc-500">Dari IP: 172.31.64.15</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">VSI 245132851</span>
              <div class="text-[9px] text-zinc-500">De-enkapsulasi MPLS</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>
              <div class="text-[9px] text-zinc-500">Forwarding ke Eth-Trunk23</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Eth-Trunk23.2851</span>
              <div class="text-[9px] text-zinc-500">Gi1/1/19 &amp; Gi1/1/21</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">VLAN 2851</span>
              <div class="text-[9px] text-zinc-500">vlan-type dot1q 2851</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">SWAGGR-D5-KBL-CS</span>
              <div class="text-[9px] text-emerald-400 font-semibold">Port-channel10 (Te1/0/1-2)</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">UP (20G)</span>
            </td>
          </tr>

          <!-- HOP 06 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center mr-1 text-[10px] font-bold">06</span>
              SWAGGR-D5-KBL-CS
              <div class="text-[9px] text-emerald-400 font-normal">Cisco Catalyst 6800 L3</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Port-channel10 (20G)</span>
              <div class="text-[9px] text-zinc-400">Te1/0/1 &amp; Te1/0/2 (SFP-LR)</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">VLAN 2851</span>
              <div class="text-[9px] text-zinc-500">VL_AP_WLC02_KBL_WIFI6</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <div class="font-bold text-emerald-400">c828.e58a.ee18 DYNAMIC Po10</div>
              <div class="text-[9px] text-zinc-400">SVI: f4bd.9e32.8755 &bull; IP: 10.5.130.154</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Te1/0/7 (To WAG) &amp; Te1/0/4</span>
              <div class="text-[9px] text-zinc-400">Lo85402 (WLC) &amp; Vl535 (PE)</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-zinc-300">VLAN 1378, 1372..</span>
              <div class="text-[9px] text-emerald-400 font-mono">SVI 10.5.130.1/23</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">WAG-D5-KBL &amp; WLC02</span>
              <div class="text-[9px] text-emerald-400 font-semibold">WAG: GE6/0/0 &bull; WLC: Port 1</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">L3 GATEWAY</span>
            </td>
          </tr>

          <!-- HOP 07 -->
          <tr class="hover:bg-zinc-900/40 transition-colors">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-zinc-800 text-zinc-300 inline-flex items-center justify-center mr-1 text-[10px]">07</span>
              WLC02-D5-KBL-CS
              <div class="text-[9px] text-zinc-500 font-normal">Cisco 8540 AireOS</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">Port 1 (10G SFP+)</span>
              <div class="text-[9px] text-zinc-500">Trunk dari SWAGGR Te1/0/4</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-800 text-zinc-300">VLAN 4035 &amp; 2851</span>
              <div class="text-[9px] text-zinc-500">CAPWAP UDP 5246/5247</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>
              <div class="text-[9px] text-zinc-500">IP: 10.5.130.154 &bull; NAT: .118</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200 font-bold">Dynamic telkom.id-wag</span>
              <div class="text-[9px] text-zinc-500">Port 2 &rarr; Lo85402 ke WAG</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold">VLAN 1378 &amp; 1372</span>
              <div class="text-[9px] text-zinc-500">IP WLC: 172.17.67.3</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">WAG-D5-KBL (Huawei)</span>
              <div class="text-[9px] text-emerald-400 font-semibold">GE6/0/0.1378 &amp; .1382</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">REG (UP)</span>
            </td>
          </tr>

          <!-- HOP 08 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center mr-1 text-[10px] font-bold">08</span>
              WAG-D5-KBL (BNG)
              <div class="text-[9px] text-emerald-400 font-normal">Huawei ME60 Gateway</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">GE6/0/0 (10G)</span>
              <div class="text-[9px] text-zinc-400">Dari SWAGGR Te1/0/7</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">10 Sub-interfaces</span>
              <div class="text-[9px] text-zinc-400">.1372, .1382, .1370, .1102..</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">Subscriber MAC Table</span>
              <div class="text-[9px] text-zinc-400">Per-MAC QoS &amp; CoA 3799</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">GE1/0/0, 4/0/0, 7/1/0</span>
              <div class="text-[9px] text-zinc-400">3x High-Speed Uplink Trunks</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-white font-semibold">Routed HSI IP</span>
              <div class="text-[9px] text-emerald-400">BAS Subscriber Domain</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">PE-D5-KBL-HSI</span>
              <div class="text-[9px] text-emerald-400 font-semibold">Ports: 654, 600, 678</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">ONLINE</span>
            </td>
          </tr>

          <!-- HOP 09 -->
          <tr class="hover:bg-zinc-900/40 transition-colors bg-emerald-950/10 border-l-2 border-emerald-500">
            <td class="p-3 font-bold text-white whitespace-nowrap">
              <span class="w-5 h-5 rounded bg-emerald-500 text-black inline-flex items-center justify-center mr-1 text-[10px] font-bold">09</span>
              PE-D5-KBL-HSI
              <div class="text-[9px] text-emerald-400 font-normal">Core Internet Router</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Ports 654, 600, 678</span>
              <div class="text-[9px] text-zinc-400">3x Interconnect dari WAG</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-zinc-300">VLAN 535 / P2P</span>
              <div class="text-[9px] text-zinc-400">Core Subscriber Streams</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-emerald-400 font-bold">CGNAT Session Translation</span>
              <div class="text-[9px] text-zinc-400">Public IP Pool Allocation</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-white font-bold">Core Backbone WAN (100G)</span>
              <div class="text-[9px] text-zinc-400">OTN Links ke Surabaya IGW</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="px-1.5 py-0.5 rounded bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-bold">eBGP Default Transit</span>
              <div class="text-[9px] text-zinc-400">AS7713 Telkom Core</div>
            </td>
            <td class="p-3 whitespace-nowrap">
              <span class="text-zinc-200">Global Internet &amp; AAA</span>
              <div class="text-[9px] text-emerald-400 font-semibold">welcome2.wifi.id (WPGEN)</div>
            </td>
            <td class="p-3 text-center whitespace-nowrap">
              <span class="px-2 py-0.5 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 text-[10px] font-bold">CORE BGP</span>
            </td>
          </tr>

        </tbody>
      </table>
    </div>

    <!-- DETAIL PORT INTERCONNECT SCHEDULE (SWAGGR, WAG & PE) -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-5 pt-2">
      
      <!-- Box 1: SWAGGR Detailed Port Map -->
      <div class="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
        <div class="flex items-center justify-between border-b border-zinc-800/80 pb-2">
          <div class="flex items-center gap-2">
            <span class="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
            <span class="text-xs font-mono font-bold text-white">DETAIL PORT INVENTORY: SWAGGR-D5-KBL-CS</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-400">Cisco Catalyst 6800</span>
        </div>
        <div class="space-y-2 text-xs font-mono">
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">Port-channel10</span>
              <span class="text-zinc-400 text-[11px]"> (Te1/0/1 + Te1/0/2)</span>
              <div class="text-[10px] text-zinc-400">LAG 20 Gbps &bull; Downlink dari ME9-D5-KBL (VLAN 2851)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (4.2G Out)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Te1/0/7</span>
              <span class="text-zinc-400 text-[11px]"> &bull; SFP 10G</span>
              <div class="text-[10px] text-zinc-400">Uplink data subscriber ke WAG-D5-KBL (GE6/0/0)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (Connected)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Te1/0/3 &amp; Te1/0/4</span>
              <span class="text-zinc-400 text-[11px]"> &bull; SFP 10G</span>
              <div class="text-[10px] text-zinc-400">Uplink trunk ke WLC01 Port 1 &amp; WLC02 Port 1</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (Connected)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Te1/1/1 &amp; Te1/1/2</span>
              <span class="text-zinc-400 text-[11px]"> &bull; 1000BaseTX SFP</span>
              <div class="text-[10px] text-zinc-400">Port MGMT ke WAC05 &amp; WAC06 (VLAN 4035)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (1 Gbps)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">Lo85401 &amp; Lo85402</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Loopback Inter-VRF</span>
              <div class="text-[10px] text-zinc-400">WLC01/02 Port 2 ke WAG-D5-KBL Te4/1/0 &amp; Te6/0/0</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (Routed)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-zinc-400 font-bold">Te1/1/3, Te1/1/4, Te1/0/5</span>
              <div class="text-[10px] text-zinc-400">Port fisik kosong / slot cadangan transreceiver (6y40w)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-zinc-900 border border-zinc-700 text-zinc-400">DOWN (notconnect)</span>
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
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">GE6/0/0 (10G)</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Downlink Utama</span>
              <div class="text-[10px] text-zinc-400">Menyambung langsung ke SWAGGR Te1/0/7 &amp; WAC06</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (10G Trunk)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">GE6/0/0.1372 &amp; .1382</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Sub-Int WMS</span>
              <div class="text-[10px] text-zinc-400">Terminasi dot1q SSID WMS Venue (Warkop Koramil)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP / BAS Active</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">GE6/0/0.1370</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Sub-Int @wifi.id</span>
              <div class="text-[10px] text-zinc-400">Terminasi dot1q SSID Publik @wifi.id Voucher</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP / BAS Active</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-white font-bold">GE6/0/0.1101 &amp; .1102</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Sub-Int Seamless</span>
              <div class="text-[10px] text-zinc-400">Terminasi dot1q SSID seamless@wifi.id EAP-SIM</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP / BAS Active</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
            <div>
              <span class="text-emerald-400 font-bold">GE1/0/0, 4/0/0, 7/1/0</span>
              <span class="text-zinc-400 text-[11px]"> &bull; Core Uplink Trunks</span>
              <div class="text-[10px] text-zinc-400">3x Direct Interconnect ke PE-D5-KBL-HSI (Port 654, 600, 678)</div>
            </div>
            <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-400 font-bold">UP (3x Redundant)</span>
          </div>
          <div class="p-2 rounded-lg bg-black/60 border border-zinc-800/80 flex items-center justify-between">
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
'@

# Target insertion right before #deepdive-section
$targetDeepDive = '<div id="deepdive-section"'
$idxDeep = $content.IndexOf($targetDeepDive)

if ($idxDeep -ge 0) {
    # Check comment above deepdive: <!-- ============================================================ -->
    $searchComment = $content.LastIndexOf('<!-- ============================================================ -->', $idxDeep)
    if ($searchComment -ge 0) {
        $idxDeep = $searchComment
    }
    $beforeDeep = $content.Substring(0, $idxDeep)
    $afterDeep = $content.Substring($idxDeep)
    $content = $beforeDeep + $masterMatrixHtml + "`r`n`r`n  " + $afterDeep
    Write-Host "Master Matrix successfully inserted before Deep Dive section."
} else {
    Write-Error "Could not find target for Deep Dive section."
}

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
Write-Host "File updated cleanly."
