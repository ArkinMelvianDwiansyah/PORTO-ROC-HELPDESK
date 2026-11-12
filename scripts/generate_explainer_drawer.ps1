# Generate Explainer Drawer HTML and Script for "Jelasin Dong! 🧠"
$ps1File = "d:\ARKIN\tes aim\scripts\generate_tabbed_site.ps1"
$ps1Content = [System.IO.File]::ReadAllText($ps1File, [System.Text.Encoding]::UTF8)

# Explainer Drawer HTML
$explainerDrawerHtml = @'
  <!-- ============================================================ -->
  <!-- "JELASIN DONG! 🧠" DEEP EXPLAINER SLIDE-OUT DRAWER -->
  <!-- ============================================================ -->
  <!-- Explainer Backdrop -->
  <div id="explainer-backdrop" onclick="toggleExplainer()" class="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm hidden transition-opacity duration-500 ease-in-out"></div>

  <!-- Explainer Slide-out Drawer (Smooth 500ms Slow Animation) -->
  <aside id="explainer-drawer" class="fixed top-0 right-0 z-50 h-screen w-full sm:w-[600px] lg:w-[680px] bg-zinc-950 border-l border-zinc-800 shadow-2xl flex flex-col justify-between transform translate-x-full transition-transform duration-500 ease-in-out">
    
    <!-- Drawer Header -->
    <div class="p-5 border-b border-zinc-800 bg-zinc-900/70 flex items-center justify-between shrink-0">
      <div class="flex items-center gap-3">
        <div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400 font-black font-mono text-base shadow-sm">
          🧠
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h3 class="text-base font-bold text-white tracking-tight">JELASIN DONG!</h3>
            <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-300 font-bold">DEEP DIVE 9 HOPS</span>
          </div>
          <p class="text-[11px] font-mono text-zinc-400">Bedah Teknis Mendalam, Alur Data, &amp; Problem Solving Lapangan</p>
        </div>
      </div>
      <button onclick="toggleExplainer()" class="p-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white transition-colors cursor-pointer border border-zinc-700">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
      </button>
    </div>

    <!-- Quick Hop Navigator Pills -->
    <div class="p-3 border-b border-zinc-800/80 bg-zinc-950 shrink-0 overflow-x-auto">
      <div class="flex items-center gap-1.5 text-[10px] font-mono min-w-[540px]">
        <button onclick="scrollToExplainerHop('01')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">01 AP</button>
        <button onclick="scrollToExplainerHop('02')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">02 ONT</button>
        <button onclick="scrollToExplainerHop('03')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">03 OLT</button>
        <button onclick="scrollToExplainerHop('04')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">04 ME Akses</button>
        <button onclick="scrollToExplainerHop('05')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">05 ME Core</button>
        <button onclick="scrollToExplainerHop('06')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">06 SWAGGR</button>
        <button onclick="scrollToExplainerHop('07')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">07 WLC</button>
        <button onclick="scrollToExplainerHop('08')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">08 WAG</button>
        <button onclick="scrollToExplainerHop('09')" class="px-2.5 py-1 rounded-lg bg-zinc-900 hover:bg-emerald-950 border border-zinc-800 hover:border-emerald-700 text-zinc-300 hover:text-white transition-colors">09 PE Core</button>
      </div>
    </div>

    <!-- Search in Explainer -->
    <div class="px-4 py-3 border-b border-zinc-800/80 bg-zinc-950 shrink-0">
      <div class="flex items-center gap-2.5 px-3 py-2 rounded-xl bg-zinc-900 border border-zinc-800 text-xs">
        <svg class="w-4 h-4 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        <input id="explainer-search" type="text" placeholder="Cari topik penjelasan (misal: kenapa VLAN 195 jadi 2851, Po10, WAG sub-int, CoA)..." class="w-full bg-transparent text-white placeholder-zinc-500 focus:outline-none font-mono text-xs" oninput="filterExplainer(this.value)" />
      </div>
    </div>

    <!-- Explainer Cards Container (Scrollable) -->
    <div id="explainer-cards-container" class="flex-1 overflow-y-auto p-5 space-y-6">
      
      <!-- CARD HOP 01 -->
      <div id="explainer-card-hop-01" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">01</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 01 &middot; Access Point (Cisco Catalyst 9105AXI-F)</h4>
              <p class="text-[10px] font-mono text-emerald-400">Venue Warkop Koramil &bull; MAC: c828.e58a.ee18 &bull; SN: FGL2702LHYR</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">Wi-Fi 6 (802.11ax)</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Kenapa AP Memakai VLAN 195? (Rahasia Serial Number)</div>
            <p class="text-zinc-400 text-[11px]">
              Di jaringan Telkom Regional 5, helpdesk tidak perlu menebak VLAN AP. Cukup lihat <strong>Prefix Serial Number</strong>! AP seri Wi-Fi 6 Cisco C9105 ber-prefix <code class="text-white font-mono">FGL27xx</code> secara mutlak dialokasikan ke <strong class="text-white">VLAN 195</strong>. Berbeda dengan seri legacy Aironet 1800/2800 (<code class="text-zinc-300 font-mono">FGL17/18</code>) yang masuk ke <strong class="text-zinc-300">VLAN 197</strong>.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Kenapa Frame Keluar dari AP Berstatus Untagged?</div>
            <p class="text-zinc-400 text-[11px]">
              Smartphone atau laptop yang memancarkan sinyal radio nirkabel (802.11) tidak menyisipkan tag 802.1Q. AP menerima sinyal RF ini, mengubahnya menjadi frame Ethernet 802.3 murni, dan mengeluarkannya lewat port LAN RJ45 secara <strong>Untagged</strong>. Tagging pertama kali dilakukan oleh modem ONT di Hop 02.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-amber-300 font-bold text-[11px]">&bull; 3. Troubleshooting Lapangan (Helpdesk Checklist)</div>
            <p class="text-zinc-400 text-[11px]">
              Jika AP disconnected: cek LED fisik pada unit AP. LED kedip hijau lambat menandakan AP sudah dapat listrik dari PoE adaptor namun masih mencari IP DHCP dari SWAGGR atau sedang membangun tunnel CAPWAP ke WLC.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 02 -->
      <div id="explainer-card-hop-02" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">02</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 02 &middot; Optical Network Terminal (ONT ZTE F670L)</h4>
              <p class="text-[10px] font-mono text-emerald-400">Modem CPE Venue &bull; SN: ZTEGC80E6E92 &bull; Dropcore: 6.332 Meter</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">CPE Bridge</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Jembatan Elektrik ke Cahaya &amp; Injeksi Tag 802.1Q</div>
            <p class="text-zinc-400 text-[11px]">
              Port LAN ONT (<code class="text-white font-mono">eth_0/1</code>) dikonfigurasi melalui protokol OMCI OLT: <code class="text-emerald-400 font-mono">vlan port eth_0/1 mode tag vlan 195</code>. Setiap paket untagged dari AP otomatis disuntikkan header 4-byte 802.1Q dengan VLAN ID 195.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Enkapsulasi TCONT 1 &amp; GEMPORT 1</div>
            <p class="text-zinc-400 text-[11px]">
              Paket bertag VLAN 195 dimasukkan ke saluran pipa <strong class="text-white">GEMPORT 1</strong> yang dibatasi kecepatan downstream-nya (<code class="text-zinc-300 font-mono">DOWN-112640KB0</code> = ~112 Mbps) dan diangkut dalam wadah upstream <strong class="text-white">TCONT 1</strong> (profil DBA <code class="text-zinc-300 font-mono">UP-37888KB0</code>).
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-amber-300 font-bold text-[11px]">&bull; 3. Analisis Redaman &amp; Alarm Dying Gasp</div>
            <p class="text-zinc-400 text-[11px]">
              Nilai Rx optik tercatat <strong class="text-emerald-400 font-mono">-20.65 dBm</strong> pada jarak 6.332 meter. Ini sangat sehat karena batas sensitivitas receiver ZTE adalah -28 dBm. Counter <strong class="text-white font-mono">Dying Gasp: 0</strong> membuktikan unit ONT tidak mengalami gangguan mati listrik PLN mendadak.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 03 -->
      <div id="explainer-card-hop-03" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">03</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 03 &middot; Optical Line Terminal (OLT ZTE C300v2)</h4>
              <p class="text-[10px] font-mono text-emerald-400">GPON04-D5-GSK-3 &bull; Slot 1/8/16:7 &bull; smartgroup1 (20G)</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">Central GPON</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Service-Port Mapping &amp; Pembongkaran GEMPORT</div>
            <p class="text-zinc-400 text-[11px]">
              Perintah <code class="text-emerald-400 font-mono">service-port 3 vport 1 user-vlan 195 vlan 195</code> memetakan aliran GEMPORT virtual port 1 dari linecard GTGH langsung ke VLAN 195 di switch backplane OLT. MAC AP <code class="text-white font-mono">c828.e58a.ee18</code> dicatat pada tabel distributed forwarding slot 8.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Pipa Agregasi 20 Gbps Smartgroup1</div>
            <p class="text-zinc-400 text-[11px]">
              Frame VLAN 195 di-trunk keluar melalui port-channel uplink <strong class="text-white">smartgroup1</strong> (anggota port optik 10GE: <code class="text-zinc-300 font-mono">xgei_1/10/1</code>, <code class="text-zinc-300 font-mono">xgei_1/10/2</code>, dan <code class="text-zinc-300 font-mono">xgei_1/11/1</code>) menuju Metro Akses. Pengecekan interface mencatat <strong class="text-emerald-400">0 CRC Error dan 0 Drop</strong>.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 04 -->
      <div id="explainer-card-hop-04" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">04</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 04 &middot; Metro Akses (Huawei CX600)</h4>
              <p class="text-[10px] font-mono text-emerald-400">ME-D5-GSK-3 (STO Gresik) &bull; Sub-Int: Eth-Trunk2.195</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">MPLS VPLS Ingress</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Masuk ke Virtual Switch Instance (VSI)</div>
            <p class="text-zinc-400 text-[11px]">
              Sub-interface <code class="text-white font-mono">Eth-Trunk2.195</code> menerima frame tagged 195 dari OLT. Perintah <code class="text-emerald-400 font-mono">control-vid 195 dot1q-termination</code> mengakhiri frame L2 fisik dan memasukkannya ke dalam switch virtual: <strong class="text-white font-mono">vsi WIFI_6_SBU_2851</strong> (vsi-id: 245132851).
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Mengapa Namanya 2851 Padahal Inputnya 195?</div>
            <p class="text-zinc-400 text-[11px]">
              Inilah kunci standarisasi Telkom: VLAN 195 adalah VLAN lokal akses di OLT Gresik, namun ketika masuk ke terowongan MPLS backbone, seluruh stream AP WiFi 6 se-Regional disiapkan untuk keluar menjadi <strong class="text-white">VLAN 2851</strong> di sentral Surabaya Kebalen.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 05 -->
      <div id="explainer-card-hop-05" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">05</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 05 &middot; Metro Core Tier-1 (Huawei CX600)</h4>
              <p class="text-[10px] font-mono text-emerald-400">ME9-D5-KBL (STO Kebalen) &bull; Downlink: Eth-Trunk23.2851</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">MPLS VPLS Egress</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Melepas Label MPLS &amp; Translasi ke VLAN 2851</div>
            <p class="text-zinc-400 text-[11px]">
              Router Core Kebalen menerima paket MPLS dari IP <code class="text-white font-mono">172.31.64.15</code> (Metro Akses Gresik), memvalidasi VSI ID 245132851, melepas label MPLS (pop label), dan menyalurkannya keluar melalui <code class="text-emerald-400 font-mono">Eth-Trunk23.2851</code> dengan tag fisik <strong class="text-white">dot1q 2851</strong>.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Penghubung Antara Gresik &amp; Switch SWAGGR Kebalen</div>
            <p class="text-zinc-400 text-[11px]">
              Port fisik <code class="text-zinc-300 font-mono">Gi1/1/19</code> dan <code class="text-zinc-300 font-mono">Gi1/1/21</code> tercolok langsung ke transceiver 10G SWAGGR (<code class="text-white font-mono">Te1/0/1</code> dan <code class="text-white font-mono">Te1/0/2</code>), membentuk jalur pipa trunk berkapasitas 20 Gbps.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 06 -->
      <div id="explainer-card-hop-06" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">06</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 06 &middot; Switch Aggregator Layer 3 (SWAGGR-D5-KBL-CS)</h4>
              <p class="text-[10px] font-mono text-emerald-400">Cisco Catalyst 6800 &bull; IP: 10.16.56.129 (NAT: 172.18.65.116)</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-300 font-bold">L3 CORE SVI</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Kenapa SWAGGR Disebut Switch Layer 3 Murni?</div>
            <p class="text-zinc-400 text-[11px]">
              SWAGGR menghentikan broadcast domain L2 dari Metro Core. Interface <code class="text-white font-mono">Vlan2851</code> memegang IP Gateway <strong class="text-emerald-400 font-mono">10.5.130.1/23</strong> bagi seluruh AP WiFi 6. SWAGGR juga menjalankan tabel ARP (<code class="text-zinc-300 font-mono">show ip arp</code>) yang memetakan IP AP <code class="text-white font-mono">10.5.130.154</code> ke MAC <code class="text-emerald-400 font-mono">c828.e58a.ee18</code>.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Exact Match 99 Dynamic MAC di Port-channel10</div>
            <p class="text-zinc-400 text-[11px]">
              Dari output live lapangan: perintah <code class="text-zinc-200 font-mono">show mac address-table vlan 2851</code> mencatat 99 MAC dinamis pada <code class="text-white font-mono">Po10</code>, termasuk <strong class="text-emerald-400 font-mono">c828.e58a.ee18 DYNAMIC Po10</strong>. Ini bukti tak terbantahkan bahwa paket melintasi OLT &amp; Metro tanpa dropped!
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-amber-300 font-bold text-[11px]">&bull; 3. Analisis Port Down (Te1/1/3 &amp; Te1/1/4)</div>
            <p class="text-zinc-400 text-[11px]">
              Port <code class="text-zinc-300 font-mono">Te1/1/3</code> dan <code class="text-zinc-300 font-mono">Te1/1/4</code> down (notconnect) dengan last input 6 tahun lalu adalah <strong>slot transceiver fisik kosong</strong> (bukan kabel putus), karena seluruh trunk produksi aktif bertumpu pada <strong class="text-white font-mono">Port-channel10</strong>.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 07 -->
      <div id="explainer-card-hop-07" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">07</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 07 &middot; Wireless LAN Controller (Cisco 8540 AireOS)</h4>
              <p class="text-[10px] font-mono text-emerald-400">WLC02-D5-KBL-CS &bull; IP: 10.16.56.131 (NAT: 172.18.65.118)</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">WLAN Core</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Pembentukan Tunnel CAPWAP</div>
            <p class="text-zinc-400 text-[11px]">
              AP membangun terowongan terenkripsi <strong class="text-white">CAPWAP</strong> (UDP port 5246 untuk sinyal kontrol &amp; UDP port 5247 untuk data payload) ke IP WLC <code class="text-white font-mono">10.16.56.131</code>. Ini memungkinkan konfigurasi radio, SSID, dan keamanan dikendalikan secara terpusat dari STO Kebalen.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. AP Grouping &amp; Interface telkom.id-wag</div>
            <p class="text-zinc-400 text-[11px]">
              AP Warkop Koramil didaftarkan ke AP Group <code class="text-emerald-400 font-mono">WARKOP_KORAMIL</code>. Klien yang connect ke SSID WMS akan dialirkan melalui dynamic interface <code class="text-white font-mono">telkom.id-wag</code> (VLAN 1378, IP <code class="text-zinc-300 font-mono">172.17.67.3</code>) menuju WAG Gateway.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 08 -->
      <div id="explainer-card-hop-08" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">08</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 08 &middot; Wireless Access Gateway (Huawei ME60 BNG)</h4>
              <p class="text-[10px] font-mono text-emerald-400">WAG-D5-KBL &bull; Downlink: GE6/0/0 (10G) &bull; 10 Sub-Interfaces</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-300 font-bold">SUBSCRIBER BNG</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. Penegakan Sesi Subscriber &amp; Bandwidth Shaping</div>
            <p class="text-zinc-400 text-[11px]">
              WAG bertindak sebagai Broadband Network Gateway (BNG). Menerima traffic dari SWAGGR <code class="text-white font-mono">Te1/0/7</code> pada interface 10G <code class="text-emerald-400 font-mono">GE6/0/0</code>. Di sinilah bandwidth profile diterapkan: paket SSID WMS dibatasi 20 Mbps, sedangkan @wifi.id publik dibatasi sesuai kuota voucher.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. 10 Sub-Interface dot1Q Multi-SSID</div>
            <p class="text-zinc-400 text-[11px]">
              &bull; <code class="text-white font-mono">GE6/0/0.1372 &amp; .1382</code>: Terminasi pelanggan <strong class="text-white">SSID WMS (Warkop Koramil)</strong>.<br/>
              &bull; <code class="text-zinc-200 font-mono">GE6/0/0.1370</code>: Terminasi publik <strong class="text-zinc-200">SSID @wifi.id</strong>.<br/>
              &bull; <code class="text-zinc-200 font-mono">GE6/0/0.1101 &amp; .1102</code>: Terminasi seluler <strong class="text-zinc-200">seamless@wifi.id</strong> via EAP-SIM.<br/>
              &bull; <code class="text-zinc-200 font-mono">GE6/0/0.1378</code>: Uplink interface <strong class="text-zinc-200">telkom.id-wag</strong> WLC.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-amber-300 font-bold text-[11px]">&bull; 3. Change of Authorization (CoA UDP 3799)</div>
            <p class="text-zinc-400 text-[11px]">
              Saat login voucher sukses di portal, server RADIUS menembakkan sinyal <strong class="text-white">CoA (RFC 3576 / UDP 3799)</strong> ke WAG untuk membuka blokir firewall dan mengaktifkan meteran billing seketika tanpa perlu re-connect Wi-Fi.
            </p>
          </div>
        </div>
      </div>

      <!-- CARD HOP 09 -->
      <div id="explainer-card-hop-09" class="explainer-hop-card p-5 rounded-2xl bg-zinc-900/60 border border-zinc-800 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2.5">
            <span class="w-7 h-7 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">09</span>
            <div>
              <h4 class="text-sm font-bold text-white">HOP 09 &middot; Core Internet Gateway (PE-D5-KBL-HSI &amp; AAA Portal)</h4>
              <p class="text-[10px] font-mono text-emerald-400">Provider Edge Router &bull; 3x Redundant Trunks &bull; welcome2.wifi.id</p>
            </div>
          </div>
          <span class="text-[9px] font-mono px-2 py-0.5 rounded bg-emerald-950 border border-emerald-800 text-emerald-300 font-bold">CORE BGP &amp; CGNAT</span>
        </div>
        <div class="space-y-3 text-xs leading-relaxed text-zinc-300 font-sans">
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 1. 3x Link Fisik Redundan Antara WAG dan PE</div>
            <p class="text-zinc-400 text-[11px]">
              WAG-D5-KBL terhubung ke PE-D5-KBL-HSI melalui 3 port interkoneksi langsung: <code class="text-white font-mono">GE1/0/0 &rarr; Port 654</code>, <code class="text-white font-mono">GE4/0/0 &rarr; Port 600</code>, dan <code class="text-white font-mono">GE7/1/0 &rarr; Port 678</code>. Desain tripel-trunk ini memastikan zero downtime jika ada maintenance port.
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 2. Alur Pencegatan Captive Portal (welcome2.wifi.id)</div>
            <p class="text-zinc-400 text-[11px]">
              Sebelum login, paket HTTP port 80 dicegat oleh WAG dan di-redirect via <strong class="text-white">HTTP 302</strong> ke landing page <code class="text-emerald-400 font-mono">welcome2.wifi.id</code> (WPGEN). Validasi username/password WMS diproses oleh kluster server RADIUS AAA (UDP port 1812/1813).
            </p>
          </div>
          <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 3. Translasi CGNAT &amp; Egress Internet Global (BGP AS7713)</div>
            <p class="text-zinc-400 text-[11px]">
              Setelah diautentikasi, trafik dialirkan ke PE-D5-KBL-HSI. PE melakukan translasi IP private pelanggan ke IP publik melalui pool <strong class="text-white">Carrier-Grade NAT (CGNAT)</strong> dan merutekannya via eBGP peering AS7713 ke Tier-1 Gateway Surabaya menuju jaringan internet global.
            </p>
          </div>
        </div>
      </div>

    </div>

    <!-- Drawer Footer -->
    <div class="p-4 border-t border-zinc-800 bg-zinc-900/50 flex items-center justify-between text-[11px] font-mono text-zinc-400 shrink-0">
      <span>Tekan <kbd class="px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-300">ESC</kbd> untuk menutup</span>
      <span class="text-emerald-400 font-semibold">9 Hops E2E Explainer Ready</span>
    </div>

  </aside>
'@

# Explainer JavaScript Controller
$explainerJs = @'
    // Explainer "Jelasin Dong! 🧠" Controller
    function toggleExplainer() {
      const drawer = document.getElementById('explainer-drawer');
      const backdrop = document.getElementById('explainer-backdrop');
      if (!drawer || !backdrop) return;
      if (drawer.classList.contains('translate-x-full')) {
        // Close glossary if open
        const gDrawer = document.getElementById('glossary-drawer');
        const gBackdrop = document.getElementById('glossary-backdrop');
        if (gDrawer && !gDrawer.classList.contains('translate-x-full')) {
          gDrawer.classList.add('translate-x-full');
          if (gBackdrop) gBackdrop.classList.add('hidden');
        }
        drawer.classList.remove('translate-x-full');
        backdrop.classList.remove('hidden');
        setTimeout(() => document.getElementById('explainer-search')?.focus(), 250);
      } else {
        drawer.classList.add('translate-x-full');
        backdrop.classList.add('hidden');
      }
    }

    function scrollToExplainerHop(hopNum) {
      const el = document.getElementById('explainer-card-hop-' + hopNum);
      if (el) {
        el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        el.classList.add('ring-2', 'ring-emerald-400', 'bg-zinc-900');
        setTimeout(() => {
          el.classList.remove('ring-2', 'ring-emerald-400', 'bg-zinc-900');
        }, 2200);
      }
    }

    function openExplainerHop(hopNum) {
      const drawer = document.getElementById('explainer-drawer');
      if (drawer && drawer.classList.contains('translate-x-full')) {
        toggleExplainer();
      }
      setTimeout(() => {
        scrollToExplainerHop(hopNum);
      }, 350);
    }

    function filterExplainer(val) {
      const q = val.toLowerCase().trim();
      const items = document.querySelectorAll('.explainer-hop-card');
      items.forEach(el => {
        const text = el.innerText.toLowerCase();
        if (!q || text.includes(q)) {
          el.classList.remove('hidden');
        } else {
          el.classList.add('hidden');
        }
      });
    }
'@

# Insert Explainer Drawer right before </aside> of glossary drawer or right after
$targetAside = '</aside>'
$idxAside = $ps1Content.IndexOf($targetAside)

if ($idxAside -ge 0) {
    $insertPos = $idxAside + $targetAside.Length
    $ps1Content = $ps1Content.Substring(0, $insertPos) + "`r`n`r`n" + $explainerDrawerHtml + $ps1Content.Substring($insertPos)
    Write-Host "Explainer Drawer HTML inserted into generate_tabbed_site.ps1."
} else {
    Write-Error "Could not find </aside> in generate_tabbed_site.ps1."
}

# Insert Explainer JS functions right before function toggleGlossary()
$targetToggle = 'function toggleGlossary()'
$idxToggle = $ps1Content.IndexOf($targetToggle)

if ($idxToggle -ge 0) {
    $ps1Content = $ps1Content.Substring(0, $idxToggle) + $explainerJs + "`r`n`r`n    " + $ps1Content.Substring($idxToggle)
    Write-Host "Explainer JS functions inserted into generate_tabbed_site.ps1."
} else {
    Write-Error "Could not find function toggleGlossary() in generate_tabbed_site.ps1."
}

# Update ESC key handling to also close explainer drawer
$oldEsc = "const drawer = document.getElementById('glossary-drawer');"
$newEsc = @"
const expDrawer = document.getElementById('explainer-drawer');
        if (expDrawer && !expDrawer.classList.contains('translate-x-full')) {
          toggleExplainer();
        }
        const drawer = document.getElementById('glossary-drawer');
"@

if ($ps1Content.Contains($oldEsc)) {
    $ps1Content = $ps1Content.Replace($oldEsc, $newEsc)
    Write-Host "ESC key handler updated."
}

[System.IO.File]::WriteAllText($ps1File, $ps1Content, [System.Text.Encoding]::UTF8)
Write-Host "generate_tabbed_site.ps1 successfully updated with Explainer Drawer."
