# UTF-8 Script to create the Tracing E2E & Problem Solving Tab and update generate_tabbed_site.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$tabE2EHtmlCode = @'
# =========================================================================
# TAB 8: END-TO-END TRACING & PROBLEM SOLVING
# ( AP - ONT - GPON - METRO - METRO - WAC - WAG - PORTAL AAA/WPGEN - PE/BRAS )
# =========================================================================
$tabE2EHtml = @'
<div class="space-y-8">
  <!-- Module Header -->
  <div class="border-b border-zinc-800/80 pb-6 mb-8">
    <div class="flex items-center gap-2 mb-2">
      <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 08 &middot; E2E TRACING &amp; PROBLEM SOLVING</span>
      <span class="text-xs font-mono text-zinc-500">9 HOPS ARCHITECTURE</span>
    </div>
    <h1 class="text-3xl font-extrabold text-white tracking-tight">Tracing Data End-to-End &amp; Problem Solving WiFi.id</h1>
    <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
      Panduan penelusuran alur paket data lengkap dan pemecahan masalah (root cause isolation) dari titik akses fisik hingga gateway internet: <code class="text-zinc-200 font-mono">AP &rarr; ONT &rarr; GPON &rarr; METRO ACCESS &rarr; METRO CORE &rarr; WAC &rarr; WAG &rarr; PORTAL AAA (WPGEN) &rarr; PE/BRAS</code>.
    </p>
  </div>

  <!-- User Input Ready Alert Banner -->
  <div class="p-4 rounded-xl border border-dashed border-zinc-700 bg-zinc-950/80 flex items-start gap-3.5 shadow-sm">
    <div class="p-2 rounded-lg bg-zinc-900 border border-zinc-800 text-zinc-300 shrink-0">
      <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    </div>
    <div class="flex-1">
      <div class="flex items-center justify-between">
        <div class="text-xs font-mono font-bold uppercase tracking-wider text-white">TEMPLATE WORKSPACE TRACING E2E TELAH SIAP</div>
        <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300 border border-zinc-700">INPUT READY</span>
      </div>
      <p class="text-xs text-zinc-400 mt-1 leading-relaxed">
        Seluruh struktur 9 Hop telah dikonstruksi secara modular dengan visualisasi alur, matriks diagnostik, dan slot kartu per segmen. Anda dapat segera mengirimkan detail teknis, format perintah CLI, skrip TACACS, dan catatan operasional untuk langsung diintegrasikan ke modul ini.
      </p>
    </div>
  </div>

  <!-- INTERACTIVE 9-HOP VISUAL PIPELINE -->
  <div class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950 shadow-sm">
    <div class="flex items-center justify-between mb-4">
      <div>
        <span class="text-[11px] font-mono uppercase tracking-wider text-zinc-400">Diagram Alur Data Transmisi</span>
        <h3 class="text-lg font-bold text-white tracking-tight mt-0.5">Pipeline Penelusuran 9 Segmen (Hop-by-Hop)</h3>
      </div>
      <span class="text-xs font-mono text-zinc-500">KLIK UNTUK MELOMPAT KE DETAIL HOP</span>
    </div>

    <!-- Flowchart Chain -->
    <div class="overflow-x-auto pb-2">
      <div class="flex items-center gap-2 min-w-[1050px]">
        <!-- 01. AP -->
        <a href="#hop-01" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 01</div>
          <div class="text-xs font-bold text-white mt-0.5">AP</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">Radio 802.11</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 02. ONT -->
        <a href="#hop-02" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 02</div>
          <div class="text-xs font-bold text-white mt-0.5">ONT</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">SC/UPC Fiber</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 03. GPON -->
        <a href="#hop-03" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 03</div>
          <div class="text-xs font-bold text-white mt-0.5">GPON / OLT</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">VLAN 4090</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 04. METRO 1 -->
        <a href="#hop-04" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 04</div>
          <div class="text-xs font-bold text-white mt-0.5">METRO 1</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">Switch Agg</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 05. METRO 2 -->
        <a href="#hop-05" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 05</div>
          <div class="text-xs font-bold text-white mt-0.5">METRO 2</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">VSI WAC_2888</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 06. WAC -->
        <a href="#hop-06" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 06</div>
          <div class="text-xs font-bold text-white mt-0.5">WAC (WLC)</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">CAPWAP WISM</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 07. WAG -->
        <a href="#hop-07" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 07</div>
          <div class="text-xs font-bold text-white mt-0.5">WAG</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">ISG Gateway</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 08. AAA -->
        <a href="#hop-08" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 08</div>
          <div class="text-xs font-bold text-white mt-0.5">AAA / WPGEN</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">RADIUS Portal</div>
        </a>
        <svg class="w-4 h-4 text-zinc-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>

        <!-- 09. BRAS -->
        <a href="#hop-09" class="flex-1 p-3 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800 hover:border-zinc-700 transition-all text-center group cursor-pointer">
          <div class="text-[10px] font-mono text-zinc-500 group-hover:text-zinc-300">HOP 09</div>
          <div class="text-xs font-bold text-white mt-0.5">PE / BRAS</div>
          <div class="text-[10px] text-zinc-400 mt-0.5 font-mono">Internet GW</div>
        </a>
      </div>
    </div>
  </div>

  <!-- MATRIKS DIAGNOSTIK END-TO-END -->
  <div class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950 shadow-sm overflow-hidden">
    <div class="mb-4">
      <span class="text-[11px] font-mono uppercase tracking-wider text-zinc-400">Tabel Diagnostik Cepat</span>
      <h3 class="text-lg font-bold text-white tracking-tight mt-0.5">Matriks Pengecekan Kunci &amp; Indikator Masalah 9 Hop</h3>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left text-xs font-mono border-collapse">
        <thead>
          <tr class="border-b border-zinc-800 bg-zinc-900/60 text-zinc-400">
            <th class="p-3 font-semibold">Hop</th>
            <th class="p-3 font-semibold">Perangkat / Node</th>
            <th class="p-3 font-semibold">Handover / Protokol</th>
            <th class="p-3 font-semibold">Parameter Standar Normal</th>
            <th class="p-3 font-semibold">Perintah Pengecekan</th>
            <th class="p-3 font-semibold">Gejala Masalah Khas</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-zinc-800/60 text-zinc-300">
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">01</td>
            <td class="p-3 text-white font-medium">Access Point (AP)</td>
            <td class="p-3">Radio 802.11a/b/g/n/ac/ax</td>
            <td class="p-3 text-emerald-400">Power PoE OK, SSID broadcast, Oper-Status Associated</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show ap summary</code></td>
            <td class="p-3 text-zinc-400">AP Down (LOSS), PoE flapping, Radio disabled</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">02</td>
            <td class="p-3 text-white font-medium">ONT Pelanggan</td>
            <td class="p-3">GPON SC/UPC &amp; LAN GigE</td>
            <td class="p-3 text-emerald-400">Rx -18 s/d -24 dBm, PON steady, LAN 1000M Full</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show pon power</code></td>
            <td class="p-3 text-zinc-400">Redaman tinggi (&gt; -27 dBm), PON blinking</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">03</td>
            <td class="p-3 text-white font-medium">GPON / OLT (ZTE)</td>
            <td class="p-3">TCONT, GEMPORT, VLAN 4090</td>
            <td class="p-3 text-emerald-400">Status ONU Working, DHCP Option 82 Aktif</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show gpon onu state</code></td>
            <td class="p-3 text-zinc-400">Port Locating silang merah (X), Gemport unmapped</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">04</td>
            <td class="p-3 text-white font-medium">Metro Aggregation</td>
            <td class="p-3">802.1Q Trunk / VLAN 4090</td>
            <td class="p-3 text-emerald-400">Port Up/Up, 0 CRC error, MAC learning normal</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">dis cur int &lt;port&gt;</code></td>
            <td class="p-3 text-zinc-400">Mismatch trunk allow-vlan, link flapping</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">05</td>
            <td class="p-3 text-white font-medium">Metro Core PE</td>
            <td class="p-3">VSI WAC_2888 / MPLS L2VPN</td>
            <td class="p-3 text-emerald-400">MAC WAC &amp; AP learned dynamic, PW State Up</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">dis mac dynamic vsi</code></td>
            <td class="p-3 text-zinc-400">MAC tidak tembus ke controller, MPLS L2VC down</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">06</td>
            <td class="p-3 text-white font-medium">WAC / WLC Cisco</td>
            <td class="p-3">CAPWAP UDP 5246/5247</td>
            <td class="p-3 text-emerald-400">AP State Registered, AP Group match SSID</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show ap cdp neighbors</code></td>
            <td class="p-3 text-zinc-400">AP Stuck Downloading, IP NAT WISM unreach</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">07</td>
            <td class="p-3 text-white font-medium">WAG (ISG Gateway)</td>
            <td class="p-3">ISG Subscriber Session</td>
            <td class="p-3 text-emerald-400">Subscriber state Authenticated, CoA ACK</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show isg session detail</code></td>
            <td class="p-3 text-zinc-400">Zombie / hung session, throttle policy failed</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">08</td>
            <td class="p-3 text-white font-medium">Portal AAA / WPGEN</td>
            <td class="p-3">RADIUS WISPr (1812/1813)</td>
            <td class="p-3 text-emerald-400">Location-ID synced, Security Open System</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">Audit Profile WPGEN</code></td>
            <td class="p-3 text-zinc-400">WP-Error URL loop, Invalid Credentials</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-bold text-white">09</td>
            <td class="p-3 text-white font-medium">PE / BRAS Gateway</td>
            <td class="p-3">DHCP Pool &amp; BGP Internet</td>
            <td class="p-3 text-emerald-400">IP assigned, Default Route 0.0.0.0/0 OK, DNS UP</td>
            <td class="p-3"><code class="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-200">show ip dhcp binding</code></td>
            <td class="p-3 text-zinc-400">Connected no Internet, IP Pool exhausted</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- SECTION: 9 DETAILED HOP CARDS -->
  <div class="space-y-6">

    <!-- HOP 01 CARD -->
    <div id="hop-01" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 01 &middot; RADIO &amp; FISIK</span>
          <span class="text-xs font-mono text-zinc-500">SEGMEN AKSES</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: ASSOCIATED</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">Access Point (Cisco / Vendor AP)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Perangkat pemancar sinyal nirkabel (SSID @wifi.id, seamless@wifi.id, atau custom WMS) ke perangkat pengguna akhir (end-user station) pada pita frekuensi 2.4 GHz dan 5 GHz.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Daya PoE Switch: 802.3at (PoE+) / 802.3af</div>
          <div class="text-zinc-300">&bull; Admin Status Radio: UP (2.4 GHz &amp; 5 GHz)</div>
          <div class="text-zinc-300">&bull; Channel Bandwidth: 20/40 MHz (2.4G) | 80 MHz (5G)</div>
          <div class="text-zinc-300">&bull; Data Teknis: AP-MAC, AP-SN, AP-Name, AP-Group</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>AP DOWN / LOSS:</strong> Cek kabel UTP, adaptor PoE, dan port switch.</div>
          <div class="text-zinc-300">&bull; <strong>AP Flapping:</strong> Cek daya PoE drop atau kabel UTP korosi/tekuk.</div>
          <div class="text-zinc-300">&bull; <strong>SSID Hilang:</strong> Verifikasi AP Group binding di controller WAC.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 01 (AP)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Parameter command CLI diagnostik AP, data penarikan datek dari Telegram APEHBOT, dan SOP penggantian fisik unit AP gress.
        </p>
      </div>
    </div>

    <!-- HOP 02 CARD -->
    <div id="hop-02" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 02 &middot; CPE OPTICAL</span>
          <span class="text-xs font-mono text-zinc-500">SEGMEN PELANGGAN</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: -18 S/D -24 DBM</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">Optical Network Terminal (ONT ZTE / Huawei)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Terminal optik di sisi pelanggan yang mengonversi sinyal GPON menjadi data ethernet. Berperan langsung sebagai pemancar pada WMS Lite, atau sebagai transport bridge bagi AP Eksternal pada WMS Reguler.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Rx Optical Power: -18.00 s/d -24.00 dBm</div>
          <div class="text-zinc-300">&bull; Tx Optical Power: +2.00 s/d +3.50 dBm</div>
          <div class="text-zinc-300">&bull; Status PON Lamp: Steady Green (Hijau Diam)</div>
          <div class="text-zinc-300">&bull; Port LAN Negotiation: 1000 Mbps Full Duplex</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>Redaman &gt; -27 dBm:</strong> Redaman drop; order perbaikan kabel drop optik / patchcord ke CCAN.</div>
          <div class="text-zinc-300">&bull; <strong>PON Blinking:</strong> ONT belum ter-provisioning di OLT atau kabel putus.</div>
          <div class="text-zinc-300">&bull; <strong>LAN Terbaca 100M:</strong> Kabel UTP patchcord bermasalah; wajib diganti Cat5e/Cat6.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 02 (ONT)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Prosedur cek redaman via ACS I-Booster, pemetaan port LAN1/LAN2, dan sinkronisasi Serial Number ONT induk di Smarthub.
        </p>
      </div>
    </div>

    <!-- HOP 03 CARD -->
    <div id="hop-03" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 03 &middot; ACCESS AGGREGATION</span>
          <span class="text-xs font-mono text-zinc-500">STO TELKOM</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: WORKING &amp; OPTION 82 ON</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">GPON / OLT (ZTE C300/C320 &amp; Huawei)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Konsentrator optik di Sentral Telepon Otomat (STO) yang mengelola alokasi bandwidth GPON (TCONT/GEMPORT) serta menginjeksi tag DHCP Option 82 untuk identifikasi port pelanggan.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; VLAN WMS: 4090 | VLAN VOIP: 500 / 100</div>
          <div class="text-zinc-300">&bull; TCONT Bandwidth Profile &amp; GEMPORT Binding</div>
          <div class="text-zinc-300">&bull; Service-Port Status: Up / Forwarding</div>
          <div class="text-zinc-300">&bull; DHCP Option 82 (Circuit-ID / Remote-ID): Enabled</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>Port Locating Silang Merah (X):</strong> Option 82 belum enable di OLT TACACS.</div>
          <div class="text-zinc-300">&bull; <strong>ONU Dying-Gasp:</strong> Power loss total pada ONT pelanggan.</div>
          <div class="text-zinc-300">&bull; <strong>Gemport Unmapped:</strong> Skrip TACACS ganti ONT belum dieksekusi sempurna.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 03 (GPON/OLT)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Skrip perintah CLI TACACS lengkap untuk aktivasi DHCP Option 82, cek status ONU ID, dan format service-port OLT ZTE.
        </p>
      </div>
    </div>

    <!-- HOP 04 CARD -->
    <div id="hop-04" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 04 &middot; METRO ACCESS</span>
          <span class="text-xs font-mono text-zinc-500">TRANSPORT LOKAL</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: TRUNK FORWARDING 0 CRC</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">Metro Ethernet 1 (Switch Access / Aggregation)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Switch Metro Ethernet Huawei/ZTE di sisi akses yang mengumpulkan traffic VLAN dari berbagai OLT di STO dan meneruskannya melalui link trunk 10GE.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Port Trunk: GE / XGE Interface State UP/UP</div>
          <div class="text-zinc-300">&bull; Allowed VLAN: 4090 (Lite), 2888/2858 (Reguler)</div>
          <div class="text-zinc-300">&bull; Error Statistics: 0 CRC, 0 Drops, 0 Runts</div>
          <div class="text-zinc-300">&bull; MAC Table: Dynamic MAC terbaca pada port downlink</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>VLAN Not Passing:</strong> Mismatch trunk port allow-vlan antara OLT dan Metro.</div>
          <div class="text-zinc-300">&bull; <strong>CRC Errors Naik:</strong> SFP optik kotor atau degradasi redaman patchcord antar-rak.</div>
          <div class="text-zinc-300">&bull; <strong>Broadcast Storm:</strong> Cek loop kabel pada sisi switch pelanggan.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 04 (METRO 1)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Perintah CLI Huawei/ZTE untuk tracing downlink port Metro, cek interface traffic rate, dan error counters.
        </p>
      </div>
    </div>

    <!-- HOP 05 CARD -->
    <div id="hop-05" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 05 &middot; METRO CORE</span>
          <span class="text-xs font-mono text-zinc-500">BACKBONE VSI</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: VSI WAC_2888 UP</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">Metro Ethernet 2 (Core Transport &amp; VSI WAC_2888)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Jaringan core transport MPLS L2VPN / VSI yang menghubungkan traffic WMS dari seluruh STO regional ke pusat controller WAC/WLC Cisco dan WAG.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Nama VSI: WAC_2888 / WAC_2858</div>
          <div class="text-zinc-300">&bull; Dynamic MAC: AP MAC &amp; Gateway MAC ter-learning</div>
          <div class="text-zinc-300">&bull; Eth-Trunk Interface: Status Selected &amp; Bandwidth OK</div>
          <div class="text-zinc-300">&bull; MPLS Pseudowire (PW) Status: Up</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>MAC AP Tidak Muncul di VSI:</strong> Link Metro putus atau VLAN drop di Hop 4.</div>
          <div class="text-zinc-300">&bull; <strong>PW State DOWN:</strong> Gangguan routing MPLS LDP/RSVP antar core PE Metro.</div>
          <div class="text-zinc-300">&bull; <strong>High Jitter / Latency:</strong> Link core utilitas di atas 85%; lakukan rerouting traffic.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 05 (METRO CORE)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Perintah CLI Huawei Metro Core <code class="text-zinc-300 font-mono">display mac-address dynamic vsi WAC_2888</code> dan pemetaan nomor port uplink ke WAC Cisco.
        </p>
      </div>
    </div>

    <!-- HOP 06 CARD -->
    <div id="hop-06" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 06 &middot; WIRELESS CONTROLLER</span>
          <span class="text-xs font-mono text-zinc-500">CISCO WLC / WISM</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: CAPWAP ESTABLISHED</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">WAC / WLC Cisco (Wireless Controller)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Pusat kendali operasional Access Point enterprise (Cisco 5508/8540). Mengatur enkapsulasi tunnel CAPWAP (Control UDP 5246, Data UDP 5247), mapping AP Group, dan alokasi SSID.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; IP WAC Asli &amp; IP NAT WISM (172.18.66.xx)</div>
          <div class="text-zinc-300">&bull; Status Asosiasi AP: Associated / Registered</div>
          <div class="text-zinc-300">&bull; AP Group: Binding profil SSID WMS sesuai WPGEN</div>
          <div class="text-zinc-300">&bull; High Availability: Primary Controller IP Management</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>AP Stuck 'Downloading':</strong> Mismatch software image; reset AP atau tunggu boot loop.</div>
          <div class="text-zinc-300">&bull; <strong>Ganti AP Beda WISM:</strong> Update Primary Controller IP &amp; Name di AP settings.</div>
          <div class="text-zinc-300">&bull; <strong>Gagal Akses WISM GUI:</strong> Gunakan Mozilla Firefox frameset link (<code class="text-zinc-300 font-mono">/screens/frameset.html</code>).</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 06 (WAC)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Perintah CLI Cisco WAC <code class="text-zinc-300 font-mono">show mac address-table address</code>, <code class="text-zinc-300 font-mono">show ip arp</code>, serta konfigurasi WLAN &amp; AP Groups.
        </p>
      </div>
    </div>

    <!-- HOP 07 CARD -->
    <div id="hop-07" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 07 &middot; SERVICE GATEWAY</span>
          <span class="text-xs font-mono text-zinc-500">ISG SUBSCRIBER</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: SESSION ACTIVE</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">WAG (Wireless Access Gateway / ISG)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Gateway pembatas sesi layanan (Intelligent Services Gateway). Menjembatani session traffic nirkabel sebelum pengguna terautentikasi dan menegakkan kebijakan QoS serta pembatasan kecepatan bandwidth.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Session State: Unauthenticated &rarr; Authenticated</div>
          <div class="text-zinc-300">&bull; CoA Port: UDP 3799 (Change of Authorization)</div>
          <div class="text-zinc-300">&bull; Tunnel Termination: VLAN Interface De-encapsulation</div>
          <div class="text-zinc-300">&bull; Shaper Policy: Download / Upload Rate-Limit (Policer)</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>Zombie Session:</strong> Sesi pelanggan lama menggantung; kirim perintah CoA disconnect atau clear session di WAG.</div>
          <div class="text-zinc-300">&bull; <strong>Bandwidth Throttled:</strong> Profil policy shaper tertahan di default 512 Kbps karena belum validasi akun.</div>
          <div class="text-zinc-300">&bull; <strong>Redirect Drop:</strong> Rule redirect port 80 pada ISG policy tidak aktif.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 07 (WAG)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Perintah CLI Cisco ISG/WAG untuk mengecek session subscriber berdasarkan MAC address atau IP klien, serta prosedur clear zombie session.
        </p>
      </div>
    </div>

    <!-- HOP 08 CARD -->
    <div id="hop-08" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 08 &middot; CAPTIVE &amp; AAA</span>
          <span class="text-xs font-mono text-zinc-500">RADIUS &amp; PORTAL</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: REDIRECT 200 OK &amp; RADIUS ACCEPT</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">Portal AAA &amp; WPGEN (Captive Portal welcome2.wifi.id)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Server portal autentikasi terpusat (welcome2.wifi.id) dan sistem manajemen WPGEN. Bertanggung jawab atas redirect halaman login, verifikasi kredensial via RADIUS (UDP 1812/1813), dan matching Location-ID.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; Location-ID: Sinkron antara WPGEN dan Radius Profile</div>
          <div class="text-zinc-300">&bull; Security Type: Wajib Open System (Tanpa WPA Key)</div>
          <div class="text-zinc-300">&bull; URL Parameters: gw_id, mac, ip, url, ssid, nas_id</div>
          <div class="text-zinc-300">&bull; Status Billing: Aktif (Bukan status Isolir/Bukis)</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>WP-Error Kasus 1:</strong> Security type di ACS berubah ke WPA; ubah kembali ke Open System.</div>
          <div class="text-zinc-300">&bull; <strong>WP-Error Kasus 2:</strong> Mismatch Location-ID / SSID name di WPGEN; samakan dengan datek AP.</div>
          <div class="text-zinc-300">&bull; <strong>Buka Isolir (Bukis):</strong> Update status pembayaran pelanggan pada portal WPGEN.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 08 (AAA/WPGEN)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Log error spesifik portal welcome2.wifi.id, format respons RADIUS Access-Reject, dan verifikasi profil bisnis WMS (Silver/Gold/Platinum).
        </p>
      </div>
    </div>

    <!-- HOP 09 CARD -->
    <div id="hop-09" class="scroll-mt-6 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/70 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-3">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">HOP 09 &middot; INTERNET GATEWAY</span>
          <span class="text-xs font-mono text-zinc-500">CORE ROUTING</span>
        </div>
        <span class="text-xs font-mono text-emerald-400 flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-500"></span>NORMAL: POOL AVAILABLE &amp; BGP FORWARDING</span>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight">PE / BRAS (Broadband Remote Access Server &amp; Gateway)</h3>
      <p class="text-xs text-zinc-400 mt-1 mb-5 leading-relaxed">
        Router gateway utama pelanggan menuju internet global (Juniper/Cisco/Huawei). Mengelola alokasi pool IP dinamis (DHCP), Carrier-Grade NAT (CGNAT), dan routing IP backbone BGP.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Parameter Kunci Verifikasi:</div>
          <div class="text-zinc-300">&bull; IP Pool DHCP Availability: &gt; 15% Free</div>
          <div class="text-zinc-300">&bull; Default Route (0.0.0.0/0): Active via BGP Backbone</div>
          <div class="text-zinc-300">&bull; DNS Server Telkom: 202.134.0.155 / 202.134.1.10</div>
          <div class="text-zinc-300">&bull; CGNAT Translation Table Status: Normal (No Exhaustion)</div>
        </div>
        <div class="p-4 rounded-xl border border-zinc-800/80 bg-zinc-900/40 space-y-2">
          <div class="text-zinc-200 font-semibold font-sans uppercase text-[11px] tracking-wider text-zinc-400">Problem Solving &amp; Solusi:</div>
          <div class="text-zinc-300">&bull; <strong>IP Pool Full (Exhausted):</strong> Klien gagal dapat IP; tambahkan subnet / expand DHCP pool di BRAS.</div>
          <div class="text-zinc-300">&bull; <strong>Login Sukses No Internet:</strong> Cek default routing atau routing return route ke subnet WMS.</div>
          <div class="text-zinc-300">&bull; <strong>DNS Failure:</strong> Server DNS recursive down; alihkan ke DNS secondary.</div>
        </div>
      </div>

      <!-- User Specific Detail Slot -->
      <div class="mt-4 p-3.5 rounded-xl border border-dashed border-zinc-700 bg-zinc-900/30 text-xs">
        <div class="flex items-center gap-2 text-zinc-300 font-mono font-semibold">
          <span class="w-2 h-2 rounded-full bg-zinc-500"></span>
          <span>SLOT DETAIL DARI REKAN ROC &middot; HOP 09 (PE/BRAS)</span>
        </div>
        <p class="text-zinc-400 text-[11px] mt-1 leading-relaxed">
          [Menunggu input detail]: Perintah CLI BRAS untuk verifikasi binding IP DHCP klien, cek status NAT overload, dan konfigurasi rute gateway internet.
        </p>
      </div>
    </div>

  </div>

  <!-- Bottom Navigation Buttons -->
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
'@

# Save snippet
[System.IO.File]::WriteAllText("$PSScriptRoot\tab_e2e_snippet.ps1", $tabE2EHtmlCode, [System.Text.Encoding]::UTF8)
Write-Output "tab_e2e_snippet.ps1 written successfully."
