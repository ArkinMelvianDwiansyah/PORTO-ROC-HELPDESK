# build_full_e2e_tab.ps1
# Script to build high-precision E2E Tracing & Problem Solving HTML tab

$html = @'
<div class="space-y-10">

  <!-- ============================================================ -->
  <!-- MODULE HEADER -->
  <!-- ============================================================ -->
  <div class="border-b border-zinc-800/80 pb-6 mb-8">
    <div class="flex items-center gap-2 mb-2">
      <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 08 &middot; E2E TRACING &amp; PROBLEM SOLVING</span>
      <span class="text-xs font-mono text-zinc-500">REV. 2026.11 &middot; LIVE FIELD CASE STUDY</span>
    </div>
    <h1 class="text-3xl font-extrabold text-white tracking-tight">Tracing Data End-to-End &amp; Problem Solving WiFi.id</h1>
    <p class="text-sm text-zinc-400 mt-2 leading-relaxed max-w-5xl">
      Dokumentasi penelusuran alur paket data lengkap (<em class="text-zinc-300">hop-by-hop packet flow tracing</em>) dan isolasi akar masalah (<em class="text-zinc-300">root cause isolation</em>) dari titik fisik Access Point hingga Core Internet Gateway. Disusun berdasarkan studi kasus riil lapangan ROC Regional 5 pada AP <strong>WMS Warkop Koramil</strong> (MAC: <code class="text-zinc-200 font-mono">C8:28:E5:8A:EE:18</code>).
    </p>
  </div>

  <!-- ============================================================ -->
  <!-- ENGINEERING NOTICE FOR PENDING HOPS -->
  <!-- ============================================================ -->
  <div class="p-5 rounded-2xl border border-dashed border-zinc-700 bg-zinc-950/90 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-sm">
    <div class="flex items-start gap-3.5">
      <div class="p-2.5 rounded-xl bg-zinc-900 border border-zinc-800 text-zinc-200 shrink-0">
        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
      </div>
      <div>
        <div class="flex items-center gap-2">
          <span class="text-xs font-mono font-bold uppercase tracking-wider text-white">STATUS TRACING: HOP 01 S/D 07 TERVERIFIKASI PENUH</span>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300 border border-zinc-700">7 / 9 HOPS COMPLETE</span>
        </div>
        <p class="text-xs text-zinc-400 mt-1 leading-relaxed">
          Tracing dari <strong class="text-zinc-200">AP &rarr; ONT &rarr; GPON (OLT) &rarr; METRO AKSES &rarr; METRO CORE &rarr; SWAGGR (L3) &rarr; WAC (WLC)</strong> telah terekam dan terverifikasi secara presisi dengan datek CLI &amp; GUI aktual.
        </p>
        <p class="text-xs text-zinc-400 mt-0.5">
          <span class="text-zinc-300 font-medium">&bull; Notice ke Rekan Engineer:</span> Hop 08 (WAG ISG session) dan Hop 09 (PE / BRAS &amp; AAA Portal WPGEN) telah disiapkan slotnya di bawah dan menunggu kiriman log CLI / skrip konfigurasi dari Anda.
        </p>
      </div>
    </div>
    <div class="shrink-0 flex items-center gap-2">
      <a href="#hop-08" class="px-3 py-1.5 rounded-lg border border-zinc-700 bg-zinc-900 hover:bg-zinc-800 text-[11px] font-mono text-zinc-300 hover:text-white transition-colors">
        Lihat Slot Hop 08-09 &darr;
      </a>
    </div>
  </div>

  <!-- ============================================================ -->
  <!-- CASE STUDY DATEK OVERVIEW -->
  <!-- ============================================================ -->
  <div class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
      <div>
        <div class="text-[10px] font-mono text-zinc-500 uppercase tracking-wider">DATEK OPERASIONAL LAPANGAN</div>
        <h2 class="text-xl font-bold text-white tracking-tight">Profil Lengkap AP Studi Kasus Tracing</h2>
      </div>
      <div class="flex items-center gap-2">
        <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <span class="text-xs font-mono text-zinc-300 font-medium">Status Operasional: ONLINE / UP</span>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 text-xs">
      
      <!-- Box 1: Identitas AP & Radio -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2.5">
        <div class="text-[10px] font-mono uppercase tracking-wider text-zinc-400 font-semibold flex items-center justify-between">
          <span>01. IDENTITAS AP</span>
          <span class="text-zinc-500 font-mono">CISCO</span>
        </div>
        <div class="space-y-1.5 font-mono text-[11px]">
          <div><span class="text-zinc-500">AP Name:</span> <span class="text-white font-semibold">GSGSK00415/TLK-WI31871627-0001</span></div>
          <div><span class="text-zinc-500">AP MAC:</span> <span class="text-white font-semibold">C8:28:E5:8A:EE:18</span></div>
          <div><span class="text-zinc-500">AP SN:</span> <span class="text-white font-semibold">FGL2702LHYR</span> <span class="text-[9px] px-1 py-0.5 rounded bg-zinc-800 text-zinc-400">VLAN 195</span></div>
          <div><span class="text-zinc-500">AP Model:</span> <span class="text-zinc-200">Cisco C9105AXI-F (WiFi 6)</span></div>
          <div><span class="text-zinc-500">Base BSSID:</span> <span class="text-zinc-300">C8:28:E5:81:DA:40</span></div>
          <div><span class="text-zinc-500">IP AP:</span> <span class="text-white font-semibold">10.5.130.154</span></div>
          <div><span class="text-zinc-500">Link Speed:</span> <span class="text-zinc-300">1000 Mbps (Full Duplex)</span></div>
        </div>
      </div>

      <!-- Box 2: Pelanggan & Lokasi -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2.5">
        <div class="text-[10px] font-mono uppercase tracking-wider text-zinc-400 font-semibold flex items-center justify-between">
          <span>02. PELANGGAN &amp; BISNIS</span>
          <span class="text-zinc-500 font-mono">WMS</span>
        </div>
        <div class="space-y-1.5 text-[11px]">
          <div><span class="text-zinc-500">Pelanggan:</span> <span class="text-white font-medium">WMS Warkop Koramil (M Usman)</span></div>
          <div><span class="text-zinc-500 font-mono">No Internet:</span> <span class="text-zinc-200 font-mono">152420227462</span></div>
          <div><span class="text-zinc-500 font-mono">Location ID:</span> <span class="text-zinc-200 font-mono">GSGSK00415</span></div>
          <div><span class="text-zinc-500">Skema Bisnis:</span> <span class="text-zinc-300">MS Silver Consumer</span></div>
          <div><span class="text-zinc-500">AP Group:</span> <span class="text-white font-mono font-medium">WARKOP_KORAMIL</span></div>
          <div><span class="text-zinc-500">Regional / Witel:</span> <span class="text-zinc-300">Reg 5 / Surabaya Utara</span></div>
          <div><span class="text-zinc-500">Klien Aktif:</span> <span class="text-white font-semibold font-mono">13 User</span> <span class="text-[10px] text-zinc-400">(5 di 2.4G / 8 di 5G)</span></div>
        </div>
      </div>

      <!-- Box 3: Akses Optik & GPON -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2.5">
        <div class="text-[10px] font-mono uppercase tracking-wider text-zinc-400 font-semibold flex items-center justify-between">
          <span>03. AKSES OPTIK &amp; ONT</span>
          <span class="text-zinc-500 font-mono">ZTE</span>
        </div>
        <div class="space-y-1.5 font-mono text-[11px]">
          <div><span class="text-zinc-500">ONT SN:</span> <span class="text-white font-semibold">ZTEGCF054F69</span> (ZTE F609 V9.0)</div>
          <div><span class="text-zinc-500">OLT Host:</span> <span class="text-white">GPON04-D5-GSK-3</span></div>
          <div><span class="text-zinc-500">IP OLT:</span> <span class="text-zinc-300">172.27.142.133</span></div>
          <div><span class="text-zinc-500">Port OLT:</span> <span class="text-white font-semibold">gpon-onu_1/8/16:7</span></div>
          <div><span class="text-zinc-500">Jarak Fiber:</span> <span class="text-zinc-200">6,332 Meter</span></div>
          <div><span class="text-zinc-500">Rx OLT / ONT:</span> <span class="text-emerald-400 font-semibold">-22.43 dBm / -21.13 dBm</span></div>
          <div><span class="text-zinc-500">Status Optik:</span> <span class="text-emerald-400 font-semibold">NORMAL &amp; STABIL</span></div>
        </div>
      </div>

      <!-- Box 4: Routing & Kontroler -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2.5">
        <div class="text-[10px] font-mono uppercase tracking-wider text-zinc-400 font-semibold flex items-center justify-between">
          <span>04. CORE &amp; CONTROLLER</span>
          <span class="text-zinc-500 font-mono">WAC / L3</span>
        </div>
        <div class="space-y-1.5 font-mono text-[11px]">
          <div><span class="text-zinc-500">WAC Host:</span> <span class="text-white font-semibold">WLC02-D5-KBL-CS</span></div>
          <div><span class="text-zinc-500">WAC IP Asli:</span> <span class="text-zinc-300">10.16.56.131 (VLAN 4035)</span></div>
          <div><span class="text-zinc-500">IP NAT WAC:</span> <span class="text-white font-semibold">172.18.65.118</span></div>
          <div><span class="text-zinc-500">SWAGGR L3:</span> <span class="text-white font-semibold">SWAGGR-D5-KBL-CS</span></div>
          <div><span class="text-zinc-500">IP NAT SWAGGR:</span> <span class="text-zinc-300">172.18.65.116</span></div>
          <div><span class="text-zinc-500">Gateway AP:</span> <span class="text-white font-semibold">10.5.130.1/23 (Vlan2851)</span></div>
          <div><span class="text-zinc-500">Metro VSI:</span> <span class="text-zinc-200">WIFI_6_SBU_2851</span></div>
        </div>
      </div>

    </div>
  </div>

  <!-- ============================================================ -->
  <!-- TOPOLOGY & PACKET FLOW PIPELINE -->
  <!-- ============================================================ -->
  <div class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <div class="text-[10px] font-mono text-zinc-500 uppercase tracking-wider">DIAGRAM ALUR DATA LENGKAP</div>
        <h2 class="text-xl font-bold text-white tracking-tight">Topologi End-to-End Tracing WiFi.id (9 Hops Pipeline)</h2>
      </div>
      <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300 border border-zinc-700">CLICKABLE PIPELINE</span>
    </div>

    <!-- Clickable Visual Pipeline -->
    <div class="overflow-x-auto pb-4">
      <div class="flex items-stretch gap-2 min-w-[1200px]">

        <!-- HOP 01 -->
        <a href="#hop-01" class="flex-1 p-3.5 rounded-xl border-2 border-white bg-zinc-900 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 01</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">ACCESS POINT</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">Cisco C9105AXI-F</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">10.5.130.154</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            FGL2702LHYR &middot; 13 Klien
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 02 -->
        <a href="#hop-02" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 02</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">MODEM ONT</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">ZTE F609 V9.0</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">eth_0/1 (VLAN 195)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            Rx -21.1 dBm &middot; 6.3 Km
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 03 -->
        <a href="#hop-03" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 03</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">GPON / OLT</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">GPON04-D5-GSK-3</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">1/8/16:7 (VLAN 195)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            Smartgroup1 &middot; 0 CRC
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 04 -->
        <a href="#hop-04" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 04</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">METRO ACCESS</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">ME-D5-GS (Huawei)</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">Eth-Trunk2.195</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            VSI WIFI_6_SBU_2851
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 05 -->
        <a href="#hop-05" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 05</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">METRO CORE (T-1)</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">ME9-D5-KBL (Kebalen)</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">Eth-Trunk23.2851</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            MPLS LDP &middot; dot1q 2851
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 06 -->
        <a href="#hop-06" class="flex-1 p-3.5 rounded-xl border border-zinc-700 bg-zinc-900/80 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 06</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">SWAGGR (L3)</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">SWAGGR-D5-KBL-CS</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">Vlan2851 / Po10</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            GW 10.5.130.1 &middot; SVI L3
          </div>
        </a>

        <!-- Arrow -->
        <div class="flex items-center text-zinc-600">&rarr;</div>

        <!-- HOP 07 -->
        <a href="#hop-07" class="flex-1 p-3.5 rounded-xl border-2 border-white bg-zinc-900 hover:bg-zinc-850 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-400 group-hover:text-white">HOP 07</span>
              <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
            <div class="text-xs font-bold text-white">WAC / WLC</div>
            <div class="text-[10px] text-zinc-400 mt-0.5">WLC02-D5-KBL-CS</div>
            <div class="text-[10px] font-mono text-zinc-300 mt-1.5">10.16.56.131 (REG)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-400">
            CAPWAP &middot; NAT .118
          </div>
        </a>

        <!-- Arrow (Dashed) -->
        <div class="flex items-center text-zinc-600 border-dashed">&dash;&rarr;</div>

        <!-- HOP 08 (Pending) -->
        <a href="#hop-08" class="flex-1 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-950 hover:bg-zinc-900 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-500">HOP 08</span>
              <span class="text-[9px] font-mono px-1.5 py-0.2 rounded bg-zinc-800 text-zinc-400">PENDING</span>
            </div>
            <div class="text-xs font-bold text-zinc-300">WAG / PORTAL</div>
            <div class="text-[10px] text-zinc-500 mt-0.5">Cisco ISG / AAA WPGEN</div>
            <div class="text-[10px] font-mono text-zinc-400 mt-1.5">VLAN 1378 (172.17.67.3)</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-500">
            Menunggu datek user
          </div>
        </a>

        <!-- Arrow (Dashed) -->
        <div class="flex items-center text-zinc-600 border-dashed">&dash;&rarr;</div>

        <!-- HOP 09 (Pending) -->
        <a href="#hop-09" class="flex-1 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-950 hover:bg-zinc-900 transition-all group flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <span class="text-[10px] font-mono font-bold text-zinc-500">HOP 09</span>
              <span class="text-[9px] font-mono px-1.5 py-0.2 rounded bg-zinc-800 text-zinc-400">PENDING</span>
            </div>
            <div class="text-xs font-bold text-zinc-300">PE / BRAS</div>
            <div class="text-[10px] text-zinc-500 mt-0.5">Internet Gateway BRAS</div>
            <div class="text-[10px] font-mono text-zinc-400 mt-1.5">BGP Default Route</div>
          </div>
          <div class="mt-3 pt-2 border-t border-zinc-800 text-[9px] font-mono text-zinc-500">
            Menunggu datek user
          </div>
        </a>

      </div>
    </div>
  </div>

  <!-- ============================================================ -->
  <!-- ENGINEERING COPYWRITING: BEDAH ALUR TEKNIS NETWORK ENGINEER -->
  <!-- ============================================================ -->
  <div class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-6">
    <div class="border-b border-zinc-800 pb-4">
      <div class="text-[10px] font-mono text-zinc-500 uppercase tracking-wider">NETWORK ENGINEERING DEEP-DIVE</div>
      <h2 class="text-xl font-bold text-white tracking-tight">Bedah Alur Tracing End-to-End: Kenapa &amp; Bagaimana Paket Berpindah</h2>
      <p class="text-xs text-zinc-400 mt-1.5 leading-relaxed max-w-4xl">
        Penjelasan komprehensif logika transmisi data, enkapsulasi VLAN, translasi MPLS Pseudowire, dan peran masing-masing node dari perspektif Network Engineer operasional ROC Telkom.
      </p>
    </div>

    <div class="space-y-6 text-xs leading-relaxed text-zinc-300">
      
      <!-- Point 1 -->
      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-2">
        <div class="flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">1</span>
          <h3 class="text-sm font-bold text-white">Level Access (AP ke ONT): Logika Penentuan VLAN Berdasarkan Serial Number AP</h3>
        </div>
        <p class="text-zinc-400 pl-8">
          Saat Access Point Cisco C9105AXI-F dinyalakan, AP ditenagai melalui PoE adaptor atau switch lokal dan kabel UTP terhubung ke port LAN ONT ZTE F609 (<code class="text-zinc-200 font-mono">eth_0/1</code>). Di jaringan WiFi.id ROC 5, terdapat <strong>standarisasi pemetaan VLAN AP berdasarkan prefix Serial Number</strong>:
        </p>
        <div class="pl-8 grid grid-cols-1 md:grid-cols-2 gap-3 pt-1">
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-white font-semibold">AP SN FGL2702LHYR &rarr; PASTI VLAN 195</div>
            <div class="text-[11px] text-zinc-400 mt-1">AP generasi terbaru (WiFi 6 Cisco C9105) menggunakan range Serial Number FGL27xx yang dialokasikan khusus ke subnet VLAN 195 untuk kontroler WLC WiFi 6.</div>
          </div>
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-white font-semibold">AP SN FGL17/18 &amp; KWC21 &rarr; PASTI VLAN 197</div>
            <div class="text-[11px] text-zinc-400 mt-1">AP generasi sebelumnya (Aironet 1800/2800 legacy) dialokasikan ke VLAN 197. Untuk seri KWC22 ke atas, dapat diarahkan ke VLAN 195 atau 197 tergantung alokasi WAC.</div>
          </div>
        </div>
        <p class="text-zinc-400 pl-8 pt-1">
          Pada konfigurasi ONT (<code class="text-zinc-200 font-mono">pon-onu-mng gpon-onu_1/8/16:7</code>), port <code class="text-zinc-200 font-mono">eth_0/1</code> dan <code class="text-zinc-200 font-mono">eth_0/2</code> diset <code class="text-zinc-200 font-mono">mode tag vlan 195</code>. Semua frame ethernet dari AP otomatis di-tag dengan dot1q 195 saat masuk ke ONT.
        </p>
      </div>

      <!-- Point 2 -->
      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-2">
        <div class="flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">2</span>
          <h3 class="text-sm font-bold text-white">Level GPON / OLT: TCONT, GEMPORT, dan Uplink 10GE Trunking</h3>
        </div>
        <p class="text-zinc-400 pl-8">
          ONT ZTE F609 mentransmisikan traffic VLAN 195 melalui laser optik (1310nm upstream) via kabel dropcore sepanjang <strong>6.332 meter</strong> menuju splitter dan masuk ke line card OLT ZTE C300v2 (<code class="text-zinc-200 font-mono">gpon-onu_1/8/16:7</code>).
        </p>
        <p class="text-zinc-400 pl-8">
          Di OLT, alur data dibungkus dalam <code class="text-zinc-200 font-mono">gemport 1 tcont 1</code> dengan profil downstream 100 Mbps (<code class="text-zinc-200 font-mono">DOWN-112640KB0</code>). Perintah <code class="text-zinc-200 font-mono">service-port 3 vport 1 user-vlan 195 vlan 195</code> memetakan GEMPORT virtual port 1 langsung ke VLAN 195 OLT. OLT kemudian meneruskan frame tagged 195 ini ke port uplink 10 Gigabit Ethernet <code class="text-zinc-200 font-mono">xgei_1/10/1</code> (anggota <code class="text-zinc-200 font-mono">smartgroup1</code>, BW 20 Gbps) menuju Switch Metro Akses. Hasil pengecekan interface mencatat <strong>0 CRC-ERROR dan 0 Drop</strong>, membuktikan fisik fiber optik OLT ke Metro sangat sehat.
        </p>
      </div>

      <!-- Point 3 -->
      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-2">
        <div class="flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">3</span>
          <h3 class="text-sm font-bold text-white">Level Metro Ethernet: Mengapa VLAN 195 di OLT Berubah Menjadi VLAN 2851 di SWAGGR?</h3>
        </div>
        <p class="text-zinc-400 pl-8">
          Ini adalah poin arsitektur paling kritikal: <strong>VLAN 195 dari sisi OLT tidak langsung di-bridging secara L2 murni ke SWAGGR</strong>. Melainkan dilewatkan melalui <strong class="text-white">MPLS L2VPN (Virtual Private Wire Service / VSI)</strong>:
        </p>
        <ul class="list-disc list-inside space-y-1.5 pl-8 text-zinc-400">
          <li>
            <strong class="text-zinc-200">Metro Akses (ME-D5-GS, Gresik)</strong>: Menerima frame dari OLT pada sub-interface <code class="text-zinc-200 font-mono">Eth-Trunk2.195</code> (PEVLAN 195). Sub-interface ini di-binding ke Virtual Switch Instance: <code class="text-zinc-200 font-mono">vsi WIFI_6_SBU_2851</code> (vsi-id: 245132851). Metro Akses membungkus frame ke dalam MPLS tunnel via LDP peer ke IP <code class="text-zinc-200 font-mono">172.31.64.106</code> (Metro Core Kebalen).
          </li>
          <li>
            <strong class="text-zinc-200">Metro Core Tier-1 (ME9-D5-KBL, STO Kebalen Surabaya)</strong>: Menerima paket MPLS dari IP <code class="text-zinc-200 font-mono">172.31.64.15</code>, mencocokkan vsi-id 245132851, melepas label MPLS, lalu menyalurkannya keluar melalui port downlink <code class="text-zinc-200 font-mono">Eth-Trunk23.2851</code> dengan tag <strong class="text-white">dot1q 2851</strong>.
          </li>
          <li>
            Dengan demikian, nama instance VSI <code class="text-zinc-200 font-mono">WIFI_6_SBU_2851</code> secara eksplisit menandakan bahwa seluruh stream AP WiFi 6 Witel Surabaya Utara yang masuk dari berbagai OLT cabang dialirkan menjadi VLAN agregasi <strong class="text-white">2851</strong>.
          </li>
        </ul>
      </div>

      <!-- Point 4 -->
      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-2">
        <div class="flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">4</span>
          <h3 class="text-sm font-bold text-white">Level SWAGGR: Bukti Bahwa SWAGGR-D5-KBL-CS Adalah Switch Layer 3 Murni</h3>
        </div>
        <p class="text-zinc-400 pl-8">
          SWAGGR menerima trunk 10G dari Metro Core pada <code class="text-zinc-200 font-mono">Port-channel10</code> (anggota interface <code class="text-zinc-200 font-mono">Te1/0/1</code> dan <code class="text-zinc-200 font-mono">Te1/0/2</code>). Pertanyaan operasional: <em>"Apakah SWAGGR ini Switch Layer 3?"</em>. Jawabannya adalah <strong>YA, MUTLAK LAYER 3</strong>, berdasarkan bukti teknis berikut:
        </p>
        <div class="pl-8 grid grid-cols-1 md:grid-cols-2 gap-3 pt-1">
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-emerald-400 font-semibold">1. Memiliki Switched Virtual Interface (SVI)</div>
            <div class="text-[11px] text-zinc-400 mt-1">Interface <code class="text-zinc-200 font-mono">Vlan2851</code> aktif dengan alamat IP <code class="text-white font-mono font-semibold">10.5.130.1/23</code>. SVI ini bertindak sebagai <strong>Default Gateway</strong> bagi seluruh AP di subnet 10.5.130.0/23. Switch L2 murni tidak memiliki routing engine SVI untuk subnet host client.</div>
          </div>
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-emerald-400 font-semibold">2. Menjalankan ARP Table Resolution</div>
            <div class="text-[11px] text-zinc-400 mt-1">Perintah <code class="text-zinc-200 font-mono">show ip arp c828.e58a.ee18</code> menghasilkan binding Layer 3: <code class="text-white font-mono">10.5.130.154 &harr; c828.e58a.ee18 (Vlan2851)</code>. Tabel ARP adalah mekanisme Layer 3 yang menghubungkan Network Layer (IP) ke Data Link Layer (MAC).</div>
          </div>
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-emerald-400 font-semibold">3. Menjalankan Inter-VLAN Routing</div>
            <div class="text-[11px] text-zinc-400 mt-1">SWAGGR mem-forward paket kontrol CAPWAP dari AP di subnet 10.5.130.0/23 menyeberang ke subnet Management WLC (<code class="text-zinc-200 font-mono">10.16.56.131</code> di VLAN 4035) via tabel routing internal CEF (Cisco Express Forwarding).</div>
          </div>
          <div class="p-3 rounded-lg bg-zinc-950 border border-zinc-800">
            <div class="font-mono text-emerald-400 font-semibold">4. Root Bridge STP &amp; VLAN Database</div>
            <div class="text-[11px] text-zinc-400 mt-1"><code class="text-zinc-200 font-mono">show spanning-tree summary</code> membuktikan SWAGGR bertindak sebagai <strong>Root Bridge</strong> untuk 43 VLAN, mengelola seluruh broadcast domain AP di regional Kebalen.</div>
          </div>
        </div>
      </div>

      <!-- Point 5 -->
      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-2">
        <div class="flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-white text-black font-mono font-bold text-xs flex items-center justify-center">5</span>
          <h3 class="text-sm font-bold text-white">Level WAC (Controller): Pembentukan CAPWAP Tunnel &amp; AP Grouping</h3>
        </div>
        <p class="text-zinc-400 pl-8">
          Setelah AP mendapatkan IP <code class="text-zinc-200 font-mono">10.5.130.154</code> via DHCP (diteruskan oleh SWAGGR), AP mengirimkan paket <em>CAPWAP Discovery Request</em> ke alamat IP Primary Controller <code class="text-zinc-200 font-mono">10.16.56.131</code> (<code class="text-zinc-200 font-mono">WLC02-D5-KBL-CS</code>).
        </p>
        <p class="text-zinc-400 pl-8">
          WLC menerima koneksi pada port UDP 5246 (Control) dan 5247 (Data), memvalidasi sertifikat AP, mendownload konfigurasi firmware versi <code class="text-zinc-200 font-mono">8.10.196.0</code>, dan menetapkan status <strong>Operational Status: REG (Registered)</strong>. Di WLC, AP dimasukkan ke dalam <strong class="text-white">AP Group: WARKOP_KORAMIL</strong>, yang memancarkan 3 SSID: <code class="text-zinc-200 font-mono">@wifi.id</code>, <code class="text-zinc-200 font-mono">seamless@wifi.id</code>, dan SSID private kustom <code class="text-zinc-200 font-mono">WARKOP KORAMIL@WIFI.ID</code>.
        </p>
      </div>

    </div>
  </div>

  <!-- ============================================================ -->
  <!-- 9 DEDICATED HOP DIAGNOSTIC CARDS -->
  <!-- ============================================================ -->
  <div class="space-y-8">
    <div class="border-b border-zinc-800 pb-3 flex items-center justify-between">
      <div>
        <div class="text-[10px] font-mono text-zinc-500 uppercase tracking-wider">DETAIL OPERASIONAL PER HOP</div>
        <h2 class="text-xl font-bold text-white tracking-tight">Kartu Diagnostik &amp; Hasil Eksekusi CLI 9 Hops</h2>
      </div>
      <span class="text-xs font-mono text-zinc-400">HOP 01 S/D 09</span>
    </div>

    <!-- ========================================== -->
    <!-- HOP 01: ACCESS POINT -->
    <!-- ========================================== -->
    <div id="hop-01" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">01</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 01 &middot; Access Point (Cisco C9105AXI-F)</h3>
            <p class="text-xs text-zinc-400 font-mono">GSGSK00415/TLK-WI31871627-0001 &bull; MAC: C8:28:E5:8A:EE:18</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">STATUS: UP &bull; JOIN TIME 1d 22h</span>
      </div>

      <!-- Parameter Table -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">IP ADDRESS</div>
          <div class="text-white font-mono font-semibold mt-1">10.5.130.154</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">DHCP from SWAGGR</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">SERIAL NUMBER</div>
          <div class="text-white font-mono font-semibold mt-1">FGL2702LHYR</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Range FGL27xx (VLAN 195)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">RADIO CLIENTS</div>
          <div class="text-white font-mono font-semibold mt-1">13 Klien Aktif</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">2.4G (5) + 5G (8)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">POE / ETH SPEED</div>
          <div class="text-white font-mono font-semibold mt-1">1000 Mbps Full</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Power Injector / Full Power</div>
        </div>
      </div>

      <!-- Screenshot Preview -->
      <div class="space-y-2">
        <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">EVIDENCE SCREENSHOT: SMARTHUB AP DETAILS</div>
        <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
          <img src="assets/images/e2e_smarthub_ap_detail.png" alt="Smarthub AP Detail" class="w-full max-h-80 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_smarthub_ap_detail.png', 'Smarthub AP Detail: GSGSK00415 Warkop Koramil')" />
          <button onclick="openLightbox('assets/images/e2e_smarthub_ap_detail.png', 'Smarthub AP Detail: GSGSK00415 Warkop Koramil')" class="absolute top-3 right-3 px-3 py-1.5 rounded-lg bg-black/80 hover:bg-black text-white text-xs font-mono border border-zinc-700 backdrop-blur transition-all flex items-center gap-1.5 cursor-pointer">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"/></svg>
            Perbesar Gambar
          </button>
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 02: MODEM ONT -->
    <!-- ========================================== -->
    <div id="hop-02" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">02</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 02 &middot; Modem Optical Network Terminal (ONT ZTE F609)</h3>
            <p class="text-xs text-zinc-400 font-mono">SN: ZTEGCF054F69 &bull; Port OLT: gpon-onu_1/8/16:7 &bull; Jarak: 6332m</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">OPTICAL REDAMAN: NORMAL (-21.1 dBm)</span>
      </div>

      <!-- Parameter Verification Table -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">TX POWER OLT</div>
          <div class="text-white font-mono font-semibold mt-1">+3.613 dBm</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Laser GPON Class B+</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">RX POWER OLT</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">-22.437 dBm</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Rentang ideal -8 s/d -27</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">RX POWER ONT</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">-21.136 dBm</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Sangat optimal (&lt; -24 dBm)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">ONLINE DURATION</div>
          <div class="text-white font-mono font-semibold mt-1">46 Jam 29 Menit</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Last offline cause: LOS</div>
        </div>
      </div>

      <!-- CLI Snippet: show onu running config -->
      <div class="space-y-2">
        <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
          <span>CLI OLT: SHOW ONU RUNNING CONFIG (PORT ETH &amp; VLAN MAPPING)</span>
          <button onclick="copyCode('cli-hop-02', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
        </div>
        <pre id="cli-hop-02" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
GPON04-D5-GSK-3#show onu running config gpon-onu_1/8/16:7 
pon-onu-mng gpon-onu_1/8/16:7
  service gemport1 gemport 1 vlan 197
  service VOIP gemport 2 vlan 100
  service WMS2 gemport 1 vlan 195
  voip protocol sip
  vlan port eth_0/1 mode tag vlan 195      <span class="text-emerald-400">&lt;-- Port LAN 1 ONT tagged VLAN 195 (Konek ke Cisco AP FGL2702LHYR)</span>
  vlan port eth_0/2 mode tag vlan 195      <span class="text-emerald-400">&lt;-- Port LAN 2 ONT tagged VLAN 195</span>
  vlan port eth_0/3 mode tag vlan 197      <span class="text-zinc-500">&lt;-- Port LAN 3 ONT tagged VLAN 197 (Untuk AP FGL17/18/KWC21)</span>
  vlan port eth_0/4 mode tag vlan 196
  dhcp-ip ethuni eth_0/1 from-internet
  dhcp-ip ethuni eth_0/2 from-internet
  dhcp-ip ethuni eth_0/3 from-internet
  dhcp-ip ethuni eth_0/4 from-internet
  veip 1 port udp 8080 host 2
  tr069-mgmt 1 acs http://acs.telkom.net:9090/web/tr069 validate basic username CPE password CPE
!</pre>
      </div>

      <!-- Screenshot Full Smarthub -->
      <div class="space-y-2">
        <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">EVIDENCE SCREENSHOT: SMARTHUB OVERVIEW &amp; FIBER ATTENUATION</div>
        <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
          <img src="assets/images/e2e_smarthub_ap_full.png" alt="Smarthub AP Full" class="w-full max-h-80 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_smarthub_ap_full.png', 'Smarthub Full Dashboard: Datek OLT, Fiber Length 6332m, & Redaman Optik')" />
          <button onclick="openLightbox('assets/images/e2e_smarthub_ap_full.png', 'Smarthub Full Dashboard: Datek OLT, Fiber Length 6332m, & Redaman Optik')" class="absolute top-3 right-3 px-3 py-1.5 rounded-lg bg-black/80 hover:bg-black text-white text-xs font-mono border border-zinc-700 backdrop-blur transition-all flex items-center gap-1.5 cursor-pointer">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"/></svg>
            Perbesar Gambar
          </button>
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 03: GPON / OLT -->
    <!-- ========================================== -->
    <div id="hop-03" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">03</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 03 &middot; Optical Line Terminal (ZTE ZXPON C300v2)</h3>
            <p class="text-xs text-zinc-400 font-mono">GPON04-D5-GSK-3 &bull; IP: 172.27.142.133 &bull; Uplink: xgei_1/10/1</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">UPLINK 10GE: 0 CRC ERROR</span>
      </div>

      <div class="space-y-4">
        
        <!-- Step 1: MAC Search & Port Resolution -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. VERIFIKASI MAC AP &amp; MAPPING ONU INTERFACE</span>
            <button onclick="copyCode('cli-hop-03a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-03a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
GPON04-D5-GSK-3#show mac C828.E58A.EE18                                        
Total mac address : 1

Mac address      Vlan  Type      Port                     Vc                      
-------------------------------------------------------------------------------
c828.e58a.ee18   195   Dynamic   gpon-onu_1/8/16:7        vport 1  

GPON04-D5-GSK-3#show gpon onu by sn ZTEGCF054F69
Search result          
-----------------
gpon-onu_1/8/16:7</pre>
        </div>

        <!-- Step 2: Interface Configuration -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>2. SERVICE-PORT &amp; TCONT CONFIGURATION (VLAN 195)</span>
            <button onclick="copyCode('cli-hop-03b', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-03b" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
GPON04-D5-GSK-3#show running-config interface gpon-onu_1/8/16:7 
interface gpon-onu_1/8/16:7
  name WIFI.ID WIFI.ID
  tcont 1 name WMS profile UP-37888KB0
  tcont 2 name VOIP profile UP-564KF5
  gemport 1 name WMS tcont 1 queue 1
  gemport 1 traffic-limit downstream DOWN-112640KB0 
  gemport 2 name VOIP tcont 2
  gemport 2 traffic-limit downstream DOWN-564KF5 
  service-port 1 vport 1 user-vlan 197 vlan 197 
  service-port 1 description WMS
  service-port 2 vport 2 user-vlan 100 vlan 877 
  service-port 2 description VOIP
  service-port 3 vport 1 user-vlan 195 vlan 195   <span class="text-emerald-400">&lt;-- Mapping user-vlan 195 ke VLAN 195</span>
  dhcpv4-l2-relay-agent enable vport 2
!</pre>
        </div>

        <!-- Step 3: Uplink Verification -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>3. CEK KESEHATAN PORT UPLINK 10GE (xgei_1/10/1) KE METRO</span>
            <button onclick="copyCode('cli-hop-03c', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-03c" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
GPON04-D5-GSK-3#show interface xgei_1/10/1
xgei_1/10/1 is up,  line protocol is up,  detect status is OK
  Description is ++++ To ME-D5-GS_Gi1/1/0 ++++
  The port negotiation is disable
  The port is optical
  Duplex full
   Packets       : 51238565933239       Bytes         : 55829088534745882   
   Oversizes     : 0                    <span class="text-emerald-400 font-bold">CRC-ERROR     : 0</span>                    
   MacRxErrs     : 0                    UnicErrors    : 0</pre>
        </div>

      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 04: METRO AKSES -->
    <!-- ========================================== -->
    <div id="hop-04" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">04</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 04 &middot; Metro Ethernet Akses (Huawei ME-D5-GS)</h3>
            <p class="text-xs text-zinc-400 font-mono">Host: &lt;ME-D5-GS&gt; &bull; Port: Eth-Trunk2.195 &bull; VSI: WIFI_6_SBU_2851</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">LDP PW PEER: 172.31.64.106 (UP)</span>
      </div>

      <div class="space-y-4">
        
        <!-- MAC Learning across slots -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. TABEL MAC ADDRESS PADA SELURUH SLOT SWITCHING</span>
            <button onclick="copyCode('cli-hop-04a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-04a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
&lt;ME-D5-GS&gt;display mac-address C828-E58A-EE18 
MAC address table of slot 1 s/d 8:
----------------------------------------------------------------------------------------------------------------------
MAC Address    VLAN/BD/VSI/SI/EVPN             PEVLAN CEVLAN Port/Peerip                        Type      LSP/LSR-ID
----------------------------------------------------------------------------------------------------------------------
c828-e58a-ee18 <span class="text-emerald-400 font-bold">WIFI_6_SBU_2851</span>                 <span class="text-white font-bold">195</span>    -      <span class="text-zinc-200">Eth-Trunk2.195</span>                     dynamic   1/-         
----------------------------------------------------------------------------------------------------------------------
Total matching items displayed = 1 (Telah ter-learning pada semua slot kartu ME-D5-GS)</pre>
        </div>

        <!-- VSI Configuration -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>2. KONFIGURASI INSTANCE MPLS L2VPN (VSI WIFI_6_SBU_2851)</span>
            <button onclick="copyCode('cli-hop-04b', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-04b" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
&lt;ME-D5-GS&gt;dis cur conf vsi WIFI_6_SBU_2851                                               
#
vsi WIFI_6_SBU_2851
 pwsignal ldp
  vsi-id 245132851
  mac-withdraw enable
  interface-status-change mac-withdraw enable
  peer 172.31.64.106                               <span class="text-emerald-400">&lt;-- Peer LDP terhubung ke ME9-D5-KBL (Kebalen)</span>
 isolate spoken
#
return</pre>
        </div>

      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 05: METRO CORE (TIER-1) -->
    <!-- ========================================== -->
    <div id="hop-05" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">05</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 05 &middot; Metro Ethernet Core Tier-1 (Huawei CX600-X16A)</h3>
            <p class="text-xs text-zinc-400 font-mono">Node: ME9-D5-KBL(TIER-1) &bull; STO Kebalen, Witel SBU &bull; Downlink: Eth-Trunk23</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">PW STATUS: UP &bull; L2 BINDING 2851</span>
      </div>

      <div class="space-y-4">
        
        <!-- VSI Services & Sub-interface -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. VERIFIKASI VSI SERVICE &amp; DOWNLINK KE SWAGGR</span>
            <button onclick="copyCode('cli-hop-05a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-05a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
&lt;ME9-D5-KBL-OLD&gt;dis vsi services WIFI_6_SBU_2851             
Total: 1 
Code: AS(Admin Status), PS(Physical Status)
--------------------------------------------------------------------------------
Interface/Bridge-domain             Vsi Name                        AS    PS
--------------------------------------------------------------------------------
<span class="text-white font-bold">Eth-Trunk23.2851</span>                    WIFI_6_SBU_2851                 up    up   
--------------------------------------------------------------------------------

&lt;ME9-D5-KBL-OLD&gt;dis cur int eth23.2851
#
interface Eth-Trunk23.2851
 vlan-type dot1q 2851                              <span class="text-emerald-400">&lt;-- Tagging dot1q ditranslasikan menjadi 2851</span>
 description WIFI6 KBL
 statistic enable
 l2 binding vsi WIFI_6_SBU_2851
#
return

&lt;ME9-D5-KBL-OLD&gt;dis cur int eth23               
#
interface Eth-Trunk23
 description LAG DOWNLINK TO SWAGGR-D5-KBL-CS      <span class="text-emerald-400">&lt;-- Fisik port-channel downlink ke Switch SWAGGR</span>
 set flow-stat interval 10
 mode lacp-static
 statistic enable
#
return</pre>
        </div>

      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 06: SWITCH AGGREGATOR L3 -->
    <!-- ========================================== -->
    <div id="hop-06" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">06</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 06 &middot; Switch Aggregator Layer 3 (Cisco Catalyst)</h3>
            <p class="text-xs text-zinc-400 font-mono">SWAGGR-D5-KBL-CS &bull; IP: 10.16.56.129 (NAT: 172.18.65.116) &bull; SVI Vlan2851</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">L3 GATEWAY: 10.5.130.1/23 (UP)</span>
      </div>

      <!-- Proof Grid -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2">
        <div class="text-[11px] font-mono font-bold text-white flex items-center gap-2">
          <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          KONFIRMASI: SWAGGR ADALAH SWITCH LAYER 3 (L3 CORE GATEWAY)
        </div>
        <p class="text-[11px] text-zinc-400 leading-relaxed">
          SWAGGR menghentikan broadcast domain L2 dari Metro Core dan menyediakan default gateway IP <code class="text-white font-mono">10.5.130.1</code> bagi seluruh AP WiFi 6 melalui SVI <code class="text-zinc-200 font-mono">Vlan2851</code>. SWAGGR juga memegang tabel ARP dan mem-forward kontrol traffic CAPWAP ke controller WLC.
        </p>
      </div>

      <div class="space-y-4">
        
        <!-- MAC & ARP on SWAGGR -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. TABEL MAC ADDRESS &amp; ARP RESOLUTION DI SWAGGR</span>
            <button onclick="copyCode('cli-hop-06a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
SWAGGR-D5-KBL-CS#show mac address-table address C828.E58A.EE18   
          Mac Address Table
-------------------------------------------
Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
<span class="text-white font-bold">2851</span>    <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>    DYNAMIC     <span class="text-zinc-200 font-bold">Po10</span>       <span class="text-zinc-500">&lt;-- Port-channel 10 (Uplink dari Metro Core)</span>
Total Mac Addresses for this criterion: 1

SWAGGR-D5-KBL-CS#show ip arp c828.e58a.ee18
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  <span class="text-white font-bold">10.5.130.154</span>            0   <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>  ARPA   <span class="text-white font-bold">Vlan2851</span>   <span class="text-emerald-400">&lt;-- Bukti L3 ARP Binding Sukses!</span></pre>
        </div>

        <!-- SVI & Port-channel 10 details -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>2. STATUS SVI GATEWAY (Vlan2851) &amp; PORT-CHANNEL 10</span>
            <button onclick="copyCode('cli-hop-06b', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06b" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
SWAGGR-D5-KBL-CS#show interfaces Vlan2851
Vlan2851 is up, line protocol is up , Autostate Enabled
  Hardware is Ethernet SVI, address is f4bd.9e32.8755 (bia f4bd.9e32.8755)
  Description: INT-VL_AP_WLC02_KBL_WIFI6_2851
  Internet address is <span class="text-white font-bold">10.5.130.1/23</span>
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec, reliability 255/255
  0 input errors, 0 CRC, 0 frame, 0 overrun, 0 output errors

SWAGGR-D5-KBL-CS#show interfaces po10
Port-channel10 is up, line protocol is up (connected) 
  Description: LAG-DOWNLINK-ME9-D5-KBL-Eth-23
  Members in this channel: Te1/0/1 Te1/0/2 (20 Gbps Aggregate)
  Input queue: 0/2000; Output queue: 0/40; 0 lost carrier</pre>
        </div>

      </div>

      <!-- Screenshot IP NAT List & SecureCRT -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
        <div class="space-y-2">
          <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">EVIDENCE: DAFTAR IP NAT SWAGGR ROC 5</div>
          <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
            <img src="assets/images/e2e_swaggr_ip_list.png" alt="SWAGGR IP List" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_swaggr_ip_list.png', 'Daftar IP SWAGGR: SWAGGR-D5-KBL-CS (IP: 10.16.56.129, NAT: 172.18.65.116)')" />
          </div>
        </div>
        <div class="space-y-2">
          <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">EVIDENCE: SESI SECURECRT SSH SWAGGR</div>
          <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
            <img src="assets/images/e2e_securecrt_ssh_swaggr.png" alt="SecureCRT SSH SWAGGR" class="w-full h-44 object-cover object-center filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_securecrt_ssh_swaggr.png', 'SecureCRT SSH ke SWAGGR-D5-KBL-CS via IP NAT 172.18.65.116')" />
          </div>
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 07: WIRELESS ACCESS CONTROLLER -->
    <!-- ========================================== -->
    <div id="hop-07" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-5">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">07</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 07 &middot; Wireless LAN Controller (Cisco WAC / WLC)</h3>
            <p class="text-xs text-zinc-400 font-mono">WLC02-D5-KBL-CS &bull; IP: 10.16.56.131 (NAT: 172.18.65.118) &bull; AireOS v8.10.196.0</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">STATUS: REG (REGISTERED) &bull; UP 93 DAYS</span>
      </div>

      <!-- Parameter Verification Table -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">WLC MGMT IP</div>
          <div class="text-white font-mono font-semibold mt-1">10.16.56.131</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">VLAN 4035 (Management)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">AP UP TIME</div>
          <div class="text-white font-mono font-semibold mt-1">2d 01h 35m</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Assoc Time: 1d 23h 01m</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">AP GROUP</div>
          <div class="text-white font-mono font-semibold mt-1">WARKOP_KORAMIL</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Country ID (Indonesia)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">ACTIVE CLIENTS</div>
          <div class="text-white font-mono font-semibold mt-1">8,909 Total di WLC</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">848 APs Connected</div>
        </div>
      </div>

      <!-- WLC Interfaces Table Breakdown -->
      <div class="space-y-2">
        <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">MAPPING INTERFACE VLAN WLC02 KE SSID &amp; GATEWAY WAG</div>
        <div class="overflow-x-auto rounded-xl border border-zinc-800 bg-black">
          <table class="w-full text-xs font-mono">
            <thead>
              <tr class="border-b border-zinc-800 text-left bg-zinc-900/60 text-zinc-400">
                <th class="p-3">Interface Name</th>
                <th class="p-3">VLAN ID</th>
                <th class="p-3">IP Address</th>
                <th class="p-3">Type</th>
                <th class="p-3">Tujuan / Service</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-zinc-800/60 text-zinc-300">
              <tr>
                <td class="p-3 font-semibold text-white">management</td>
                <td class="p-3 text-emerald-400">4035</td>
                <td class="p-3">10.16.56.131</td>
                <td class="p-3 text-zinc-500">Static (AP Mgmt)</td>
                <td class="p-3 text-zinc-400">Terminasi Tunnel CAPWAP dari AP</td>
              </tr>
              <tr>
                <td class="p-3 font-semibold text-white">seamless@wifi.id-internet</td>
                <td class="p-3 text-emerald-400">1102</td>
                <td class="p-3">172.17.61.180</td>
                <td class="p-3 text-zinc-500">Dynamic</td>
                <td class="p-3 text-zinc-400">SSID Seamless Auto-connect EAP-SIM</td>
              </tr>
              <tr>
                <td class="p-3 font-semibold text-white">ssid_biz_direct</td>
                <td class="p-3 text-emerald-400">208</td>
                <td class="p-3">172.17.61.212</td>
                <td class="p-3 text-zinc-500">Dynamic</td>
                <td class="p-3 text-zinc-400">SSID Enterprise / Dedicated Direct</td>
              </tr>
              <tr>
                <td class="p-3 font-semibold text-white">ssid_wifi.id</td>
                <td class="p-3 text-emerald-400">1370</td>
                <td class="p-3">172.17.61.20</td>
                <td class="p-3 text-zinc-500">Dynamic</td>
                <td class="p-3 text-zinc-400">SSID Publik @wifi.id (Voucher / Komunitas)</td>
              </tr>
              <tr>
                <td class="p-3 font-semibold text-white">ssid_wms</td>
                <td class="p-3 text-emerald-400">1372</td>
                <td class="p-3">172.17.61.52</td>
                <td class="p-3 text-zinc-500">Dynamic</td>
                <td class="p-3 text-zinc-400">SSID Venue WMS Venue Venue Pelanggan</td>
              </tr>
              <tr class="bg-zinc-900/30">
                <td class="p-3 font-semibold text-emerald-400">telkom.id-wag</td>
                <td class="p-3 text-emerald-400 font-bold">1378</td>
                <td class="p-3 font-bold text-white">172.17.67.3</td>
                <td class="p-3 text-zinc-500">Dynamic</td>
                <td class="p-3 text-white font-medium">&rarr; Uplink Langsung ke HOP 08 (WAG Gateway)</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- WLC GUI Screenshots Grid -->
      <div class="space-y-2">
        <div class="text-[11px] font-mono text-zinc-400 uppercase tracking-wider">EVIDENCE SCREENSHOTS: CISCO WLC 8.10 INTERFACE &amp; MONITORING</div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          
          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_monitor_summary.jpg" alt="WLC Monitor" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_monitor_summary.jpg', 'WLC Controller Summary: WLC02-D5-KBL-CS, 848 APs, 8909 Klien')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">Dashboard Monitor Summary WLC</div>
          </div>

          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_all_aps.png" alt="WLC All APs" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_all_aps.png', 'WLC All APs: AP Warkop Koramil Status REG (Registered) PoE Full')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">List All APs Filter FGL2702LHYR</div>
          </div>

          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_interfaces.png" alt="WLC Interfaces" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_interfaces.png', 'WLC Interfaces: VLAN 4035, 1102, 1370, 1372, 1378 (WAG)')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">Tabel Mapping Interface &amp; VLAN WLC</div>
          </div>

        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
          
          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_ap_general.png" alt="WLC AP General" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_ap_general.png', 'WLC AP Details General: Name, IP 10.5.130.154, Up Time')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">AP Details: Tab General &amp; IP Config</div>
          </div>

          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_ap_advanced.jpg" alt="WLC AP Advanced" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_ap_advanced.jpg', 'WLC AP Advanced: AP Group WARKOP_KORAMIL, Country ID')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">AP Details: Tab Advanced &amp; AP Group</div>
          </div>

          <div class="space-y-1">
            <div class="relative group rounded-xl overflow-hidden border border-zinc-800 bg-zinc-900">
              <img src="assets/images/e2e_wlc_ap_ha.png" alt="WLC AP High Availability" class="w-full h-44 object-cover object-top filter grayscale group-hover:grayscale-0 transition-all cursor-pointer" onclick="openLightbox('assets/images/e2e_wlc_ap_ha.png', 'WLC AP High Availability: Primary WLC02-D5-KBL-CS 10.16.56.131')" />
            </div>
            <div class="text-[10px] text-zinc-400 font-mono text-center">AP Details: Tab High Availability Controller</div>
          </div>

        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 08: WIRELESS ACCESS GATEWAY (PENDING) -->
    <!-- ========================================== -->
    <div id="hop-08" class="p-6 rounded-2xl border border-dashed border-zinc-700 bg-zinc-950/80 space-y-4">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-zinc-800 text-zinc-400 font-mono font-bold text-xs flex items-center justify-center">08</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 08 &middot; Wireless Access Gateway (Cisco ISG / BNG)</h3>
            <p class="text-xs text-zinc-400 font-mono">Uplink Interface WLC: telkom.id-wag &bull; VLAN 1378 &bull; IP: 172.17.67.3</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-zinc-900 border border-zinc-700 text-zinc-300 font-semibold self-start sm:self-auto">[SLOT TERSEDIA &middot; MENUNGGU INPUT USER]</span>
      </div>

      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-3">
        <div class="text-xs text-zinc-300 font-semibold">Fungsi Hop 08 pada Arsitektur WiFi.id:</div>
        <p class="text-xs text-zinc-400 leading-relaxed">
          WAG (Wireless Access Gateway) mengelola <em>subscriber session</em>, penegakan QoS/bandwidth profile pelanggan, pengiriman CoA (Change of Authorization) port UDP 3799, dan melakukan terminasi sesi sebelum diteruskan ke Captive Portal / RADIUS AAA WPGEN.
        </p>
        <div class="p-3 rounded-lg bg-black border border-dashed border-zinc-700 text-xs text-zinc-400 font-mono leading-relaxed">
          <span class="text-white font-bold">&gt;&gt; NOTICE KE REKAN ENGINEER:</span><br/>
          Silakan kirimkan: Hostname WAG, IP WAG, output perintah verifikasi sesi klien (misal: <code class="text-zinc-200">show subscriber session mac c828.e58a.ee18</code> atau sejenisnya) agar kami langsung update kartu ini dengan datek operasional Anda.
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- HOP 09: PE / BRAS & AAA (PENDING) -->
    <!-- ========================================== -->
    <div id="hop-09" class="p-6 rounded-2xl border border-dashed border-zinc-700 bg-zinc-950/80 space-y-4">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-zinc-800 text-zinc-400 font-mono font-bold text-xs flex items-center justify-center">09</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 09 &middot; Internet Core Gateway (PE / BRAS &amp; AAA Portal WPGEN)</h3>
            <p class="text-xs text-zinc-400 font-mono">BGP Default Routing &bull; Public IP NAT Pool &bull; welcome2.wifi.id AAA</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-zinc-900 border border-zinc-700 text-zinc-300 font-semibold self-start sm:self-auto">[SLOT TERSEDIA &middot; MENUNGGU INPUT USER]</span>
      </div>

      <div class="p-4 rounded-xl bg-zinc-900/40 border border-zinc-800/80 space-y-3">
        <div class="text-xs text-zinc-300 font-semibold">Fungsi Hop 09 pada Arsitektur WiFi.id:</div>
        <p class="text-xs text-zinc-400 leading-relaxed">
          PE / BRAS bertindak sebagai gerbang keluar menuju jaringan global Internet. Mengelola alokasi IP publik/private CGNAT, routing BGP ke Tier-1 transit, dan interkoneksi ke server Captive Portal AAA WPGEN (<code class="text-zinc-200 font-mono">welcome2.wifi.id</code>) untuk validasi login voucher, WMS user/password, dan seamless SIM auth.
        </p>
        <div class="p-3 rounded-lg bg-black border border-dashed border-zinc-700 text-xs text-zinc-400 font-mono leading-relaxed">
          <span class="text-white font-bold">&gt;&gt; NOTICE KE REKAN ENGINEER:</span><br/>
          Silakan kirimkan: Hostname BRAS/PE, format perintah show rute atau status BGP/NAT yang digunakan di tim ROC Anda. Slot ini siap diintegrasikan seketika data Anda kirimkan.
        </div>
      </div>
    </div>

  </div>

  <!-- ============================================================ -->
  <!-- BOTTOM NAVIGATION BUTTONS -->
  <!-- ============================================================ -->
  <div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
    <button onclick="switchTab('tab-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
      <span>Kembali ke Modul 07: Tracing CLI</span>
    </button>
    <button onclick="switchTab('tab-quick-ops')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
      <span>Lanjut ke Modul 09: Quick Notes</span>
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
    </button>
  </div>

</div>
'@

# Save to e2e_tracing_content.html
[System.IO.File]::WriteAllText("$PSScriptRoot\e2e_tracing_content.html", $html, [System.Text.Encoding]::UTF8)
Write-Host "e2e_tracing_content.html generated. Size: $($html.Length) chars."
