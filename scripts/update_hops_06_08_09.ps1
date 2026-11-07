# Helper to update Hop 06, Hop 08, Hop 09, and CCNA Lab in scripts/e2e_tracing_content.html
$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Read Hop 06 replacement
$newHop06 = @'
    <!-- ========================================== -->
    <!-- HOP 06: SWITCH AGGREGATOR L3 -->
    <!-- ========================================== -->
    <div id="hop-06" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">06</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 06 &middot; Switch Aggregator Layer 3 (Cisco Catalyst)</h3>
            <p class="text-xs text-zinc-400 font-mono">SWAGGR-D5-KBL-CS &bull; IP: 10.16.56.129 (NAT: 172.18.65.116) &bull; SVI Vlan2851 &bull; LAG Po10</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">L3 GATEWAY &amp; AGGREGATION CORE (ONLINE)</span>
      </div>

      <!-- Proof Grid -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2">
        <div class="text-[11px] font-mono font-bold text-white flex items-center gap-2">
          <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          KONFIRMASI ARSITEKTUR: SWAGGR ADALAH MULTILAYER CORE SWITCH (L3 SVI GATEWAY)
        </div>
        <p class="text-[11px] text-zinc-400 leading-relaxed">
          SWAGGR bertindak sebagai sentral agregasi L3 di STO Kebalen. Menghentikan broadcast domain L2 dari Metro Core melalui link agregasi <code class="text-emerald-400 font-mono">Port-channel10</code> (20 Gbps), menyediakan gateway IP <code class="text-white font-mono">10.5.130.1/23</code> bagi seluruh AP WiFi 6 melalui SVI <code class="text-zinc-200 font-mono">Vlan2851</code>, dan menghubungkan trunking kontroler WLC ke Gateway WAG melalui port <code class="text-zinc-200 font-mono">Te1/0/7</code>.
        </p>
      </div>

      <!-- Quick Metrics Grid -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">SVI GATEWAY</div>
          <div class="text-white font-mono font-semibold mt-1">10.5.130.1/23</div>
          <div class="text-[10px] text-emerald-400 mt-0.5">VLAN 2851 (WiFi 6 AP)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">DOWNLINK LAG</div>
          <div class="text-white font-mono font-semibold mt-1">Port-channel 10</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">20 Gbps (Te1/0/1 + Te1/0/2)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">LIVE THROUGHPUT</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">4.24 Gbps Out</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">In: 572 Mbps (Po10)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">UPLINK TO WAG</div>
          <div class="text-white font-mono font-semibold mt-1">Te1/0/7 &rarr; GE6/0/0</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">WAG-D5-KBL Sub-Int</div>
        </div>
      </div>

      <div class="space-y-5">
        
        <!-- 1. MAC Address Table on VLAN 2851 & ARP -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. TABEL MAC ADDRESS VLAN 2851 (99 MACs) &amp; ARP RESOLUTION AP KORAMIL</span>
            <button onclick="copyCode('cli-hop-06a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed max-h-96 overflow-y-auto">
SWAGGR-D5-KBL-CS#sho mac address-table vlan 2851
          Mac Address Table
-------------------------------------------
Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
2851    0072.7828.1a88    DYNAMIC     Po10
2851    0072.7828.2210    DYNAMIC     Po10
2851    0072.782c.1a40    DYNAMIC     Po10
2851    0072.782c.3798    DYNAMIC     Po10
2851    0077.8dd6.17e8    DYNAMIC     Po10
2851    00a5.bf72.5cc8    DYNAMIC     Po10
2851    00b6.705e.1998    DYNAMIC     Po10
2851    24d7.9c87.44c8    DYNAMIC     Po10
2851    308b.b260.0998    DYNAMIC     Po10
2851    345d.a848.2260    DYNAMIC     Po10
2851    3891.b736.2aac    DYNAMIC     Po10
2851    488b.0a08.0490    DYNAMIC     Po10
2851    7018.a714.6598    DYNAMIC     Po10
2851    84f1.47bc.3d40    DYNAMIC     Po10
2851    8c1e.8055.127c    DYNAMIC     Po10
2851    a0f8.497c.1140    DYNAMIC     Po10
2851    c4b3.6a10.5c00    DYNAMIC     Po10
2851    c828.e58a.5b2c    DYNAMIC     Po10
2851    c828.e58a.6128    DYNAMIC     Po10
<span class="text-white font-bold">2851</span>    <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>    DYNAMIC     <span class="text-white font-bold">Po10</span>        <span class="text-emerald-400">&lt;-- EXACT MATCH: MAC AP WARKOP KORAMIL TERDETEKSI DI Po10!</span>
2851    c828.e58a.f95c    DYNAMIC     Po10
2851    c828.e58b.0de4    DYNAMIC     Po10
2851    c828.e58b.aa24    DYNAMIC     Po10
2851    c884.a148.0ec8    DYNAMIC     Po10
2851    f4bd.9e32.8755    STATIC      Vl2851      <span class="text-zinc-500">&lt;-- Static SVI Hardware MAC SWAGGR</span>
2851    fc44.9f0a.45c3    DYNAMIC     Po10
Total Mac Addresses for this criterion: 99

SWAGGR-D5-KBL-CS#show ip arp c828.e58a.ee18
Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  <span class="text-white font-bold">10.5.130.154</span>            0   <span class="text-emerald-400 font-bold">c828.e58a.ee18</span>  ARPA   <span class="text-white font-bold">Vlan2851</span>   <span class="text-emerald-400">&lt;-- IP Binding Sukses!</span></pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Dari total 99 MAC address yang dipelajari secara dinamis pada VLAN 2851 di interface <code class="text-white font-mono">Po10</code>, MAC target studi kasus kita <code class="text-emerald-400 font-mono">c828.e58a.ee18</code> tercatat dengan status <strong class="text-white">DYNAMIC di Po10</strong>. Ini membuktikan frame ethernet AP berhasil menempuh jalur OLT &rarr; Metro Akses &rarr; VSI MPLS Core &rarr; Po10 SWAGGR tanpa terbuang. Serta entri <code class="text-zinc-300 font-mono">STATIC Vl2851</code> adalah MAC gateway SVI internal switch.
          </div>
        </div>

        <!-- 2. Port-Channel 10 (20Gbps LAG) & Te1/0/1 Member -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>2. STATUS PORT-CHANNEL 10 (20 Gbps LAG) &amp; MEMBER TE1/0/1</span>
            <button onclick="copyCode('cli-hop-06b', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06b" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
SWAGGR-D5-KBL-CS#show inter Po10
Port-channel10 is up, line protocol is up (connected) 
  Hardware is EtherChannel, address is f4bd.9e32.8701 (bia f4bd.9e32.8701)
  Description: <span class="text-white font-bold">LAG-DOWNLINK-ME9-D5-KBL-Eth-23</span>
  MTU 1500 bytes, <span class="text-emerald-400 font-bold">BW 20000000 Kbit/sec</span> (20 Gbps), DLY 10 usec, 
     reliability 255/255, txload 54/255, rxload 7/255
  Encapsulation ARPA, loopback not set, Keepalive set (10 sec)
  Full-duplex, 10Gb/s, link type is auto, media type is N/A
  Members in this channel: <span class="text-white font-bold">Te1/0/1 Te1/0/2</span>
  <span class="text-zinc-300">5 minute input rate 572304000 bits/sec, 201216 packets/sec</span>  (~572 Mbps)
  <span class="text-emerald-400 font-bold">5 minute output rate 4247539000 bits/sec, 451603 packets/sec</span> (~4.24 Gbps)
     50991789523790 packets input, 47620257043403169 bytes
     82307932805788 packets output, 589163247151913686 bytes
     0 output errors, 0 collisions, 3 interface resets

SWAGGR-D5-KBL-CS#show interfaces Te1/0/1
TenGigabitEthernet1/0/1 is up, line protocol is up (connected) 
  Hardware is Ten Gigabit Ethernet, address is f4bd.9e32.8701 (bia f4bd.9e32.8701)
  Description: <span class="text-white font-bold">TO ME9-D5-KBL 1/1/19</span>
  MTU 1500 bytes, BW 10000000 Kbit/sec, DLY 10 usec, reliability 255/255
  Full-duplex, 10Gb/s, media type is <span class="text-white font-bold">SFP-10GBase-LR</span>
  5 minute input rate 310677000 bits/sec, 5 minute output rate 1715151000 bits/sec
  0 watchdog, 0 output buffer failures</pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Port-channel 10 adalah tulang punggung agregasi utama yang menggabungkan port optik 10G <code class="text-zinc-200 font-mono">Te1/0/1</code> dan <code class="text-zinc-200 font-mono">Te1/0/2</code> (transceiver SFP-10GBase-LR 1310nm Long-Range) menjadi bandwidth agregat 20 Gbps. Output traffic 4.24 Gbps menunjukkan performa transmisi stabil tanpa botol leher (bottleneck).
          </div>
        </div>

        <!-- 3. Complete VLAN Table (show vlan brief) -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>3. TABEL VLAN LENGKAP SWAGGR (SHOW VLAN BRIEF)</span>
            <button onclick="copyCode('cli-hop-06c', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06c" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed max-h-80 overflow-y-auto">
SWAGGR-D5-KBL-CS#sho vlan bri           

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Te1/0/5, Te1/0/6, Te1/0/8
                                                Te1/0/9, Te1/0/10, Te1/0/12
535  p2p-PE                           active    <span class="text-zinc-500">&lt;-- P2P Peering ke Core PE Router</span>
580  VLAN-P2P-WC-U17-TEMP             active    
1102 seamless@wifi.id-internet        active    <span class="text-zinc-500">&lt;-- VLAN Klien Seamless EAP-SIM</span>
1245 ssid_iot                         active    <span class="text-zinc-500">&lt;-- VLAN Khusus Perangkat IoT Venue</span>
1370 ssid_wifi.id                     active    <span class="text-zinc-500">&lt;-- VLAN Klien Publik @wifi.id Voucher</span>
1372 ssid_wms                         active    <span class="text-zinc-500">&lt;-- VLAN Klien WMS Reguler Venue</span>
1378 telkom.id-wag                    active    <span class="text-emerald-400">&lt;-- VLAN Uplink Interface ke WAG Gateway</span>
1379 SSID_seamless                    active    
1382 ssid_wms_WAG-KBL                 active    <span class="text-emerald-400">&lt;-- VLAN Direct WMS WAG Kebalen</span>
2850 VL_AP_WLC02_KBL_WIFI6_2850       active    Te1/1/3
<span class="text-white font-bold">2851 VL_AP_WLC02_KBL_WIFI6_2851</span>       active    <span class="text-emerald-400">&lt;-- POOL VLAN AP KITA (WARKOP KORAMIL)</span>
2852 VL_AP_WLC02_KBL_WIFI6_2852       active    
2853 VL_AP_WLC02_KBL_WIFI6_2853       active    
2854 VL_AP_WLC02_KBL_WIFI6_2854       active    
2855 VL_AP_WLC02_KBL_WIFI6_2855       active    
2856 VL_AP_WLC02_KBL_WIFI6_2856       active    
2860 VLANAP2860_WLC01_KBL             active    
2861 VLANAP2861_WLC02_KBL             active    
2862-2875 VL_AP_WLC02_KBL_WIFI6_*     active    
2880-2885 VL_AP_WLC02_KBL_WIFI6_*     active    
2890-2895 VL_AP_WLC02_KBL_WIFI6_*     active    
4035 MGMT                             active    Te1/1/1, Te1/1/2, Te1/1/4 <span class="text-zinc-500">&lt;-- Management WLC</span>
4090 MGMT-PROCERA                     active    <span class="text-zinc-500">&lt;-- Management Procera DPI (Down)</span></pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Output ini merinci arsitektur segmentasi Telkom. VLAN 2850&ndash;2895 dialokasikan untuk subnet manajemen AP WiFi 6, sedangkan VLAN 1102, 1245, 1370, 1372, dan 1382 membawa payload trafik data pelanggan (SSID) yang di-trunk secara independen ke WAG dan WLC.
          </div>
        </div>

        <!-- 4. Peta Interface Description Lengkap -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>4. PETA INTERKONEKSI FISIK &amp; LOGIKA (SHOW INTER DESCRIPTION)</span>
            <button onclick="copyCode('cli-hop-06d', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-06d" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed max-h-80 overflow-y-auto">
SWAGGR-D5-KBL-CS#show inter description 
Interface                      Status         Protocol Description
Vl1                            admin down     down     
Vl535                          up             up       SWAGGR to PE P2P
Vl580                          up             up       
Vl2850                         up             up       INT-VL_AP_WLC02_KBL_WIFI6_2850
Vl2851                         up             up       INT-VL_AP_WLC02_KBL_WIFI6_2851  <span class="text-emerald-400">&lt;-- SVI AP Subnet</span>
Vl2860                         up             up       VLAN_AP_2860_WLC01_KBL
Vl2861                         up             up       VLAN_AP_2861_WLC02_KBL
Vl4035                         up             up       MGMT 
Vl4090                         down           down     MGMT-PROCERA
Gi0/0                          admin down     down     
<span class="text-white font-bold">Te1/0/1                        up             up       TO ME9-D5-KBL 1/1/19</span>            <span class="text-zinc-500">&lt;-- Member Po10</span>
<span class="text-white font-bold">Te1/0/2                        up             up       TO ME9-D5-KBL 1/1/21</span>            <span class="text-zinc-500">&lt;-- Member Po10</span>
Te1/0/3                        up             up       TO WLC01-D5-KBL-CS Port 1
Te1/0/4                        up             up       TO WLC02-D5-KBL-CS Port 1
Te1/0/5                        down           down     
Te1/0/6                        down           down     
<span class="text-white font-bold">Te1/0/7                        up             up       To WAG-D5-KBL Te 6/0/0</span>          <span class="text-emerald-400">&lt;-- UPLINK KE WAG GATEWAY!</span>
Te1/0/8 - Te1/0/11             down           down     
Te1/0/12                       down           down     to-SW-NEXUS-PROCERA
<span class="text-white font-bold">Te1/1/1                        up             up       TO WAC05-D5-KBL-CS Port MGMT</span>    <span class="text-zinc-500">&lt;-- VLAN 4035</span>
<span class="text-white font-bold">Te1/1/2                        up             up       TO WAC06-D5-KBL-CS Port MGMT</span>    <span class="text-zinc-500">&lt;-- VLAN 4035</span>
Te1/1/3                        down           down     
Te1/1/4                        down           down     
<span class="text-white font-bold">Po10                           up             up       LAG-DOWNLINK-ME9-D5-KBL-Eth-23</span>  <span class="text-emerald-400">&lt;-- 20G Trunk ME9</span>
Lo85401                        up             up       WLC01-D5-KBL-CS Port2 to WAG-D5-KBL Te 4/1/0
Lo85402                        up             up       WLC02-D5-KBL-CS Port2 to WAG-D5-KBL Te 6/0/0</pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Deskripsi interface ini membuka seluruh matriks topologi fisik STO Kebalen: <code class="text-white font-mono">Te1/0/7</code> menyambung langsung ke <code class="text-emerald-400 font-mono">WAG-D5-KBL Te 6/0/0</code>, sedangkan loopback inter-VRF <code class="text-zinc-200 font-mono">Lo85402</code> menghubungkan traffic controller WLC02 ke WAG Te 6/0/0.
          </div>
        </div>

        <!-- 5. LLDP Neighbors & Port Diagnostics -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="space-y-1.5">
            <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
              <span>5. LLDP NEIGHBOR DISCOVERY SWAGGR</span>
              <button onclick="copyCode('cli-hop-06e', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin</button>
            </div>
            <pre id="cli-hop-06e" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
SWAGGR-D5-KBL-CS#sho lldp neighbors 
Device ID           Local Intf   Capability   Port ID
ME9-D5-KBL-OLD      Te1/0/2      B,R          GigabitEthernet1/1/21
ME9-D5-KBL-OLD      Te1/0/1      B,R          GigabitEthernet1/1/19
<span class="text-white font-bold">WAG-D5-KBL</span>          <span class="text-emerald-400 font-bold">Te1/0/7</span>      B,R          <span class="text-white font-bold">GigabitEthernet6/0/0</span>
Total entries displayed: 3</pre>
            <div class="p-2 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[10px] text-zinc-400">
              <span class="text-emerald-400 font-semibold">&bull; Konfirmasi Kabel:</span> Port Te1/0/7 SWAGGR terpasang valid secara optik ke GE6/0/0 pada router WAG-D5-KBL.
            </div>
          </div>

          <div class="space-y-1.5">
            <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
              <span>6. AUDIT DIAGNOSTIK PORT TE1/1/1, 2, 3, 4</span>
              <button onclick="copyCode('cli-hop-06f', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin</button>
            </div>
            <pre id="cli-hop-06f" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
Te1/1/1: <span class="text-emerald-400 font-bold">UP (connected)</span> &bull; TO WAC05-D5-KBL-CS Port MGMT (1G)
Te1/1/2: <span class="text-emerald-400 font-bold">UP (connected)</span> &bull; TO WAC06-D5-KBL-CS Port MGMT (1G)
Te1/1/3: <span class="text-amber-400 font-bold">DOWN (notconnect)</span> &bull; Last in: 6y40w &bull; drops: 475k
Te1/1/4: <span class="text-zinc-500">DOWN (notconnect)</span> &bull; Port SFP kosong
Te1/0/5: <span class="text-zinc-500">DOWN (notconnect)</span> &bull; Port cadangan 10G</pre>
            <div class="p-2 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[10px] text-zinc-400">
              <span class="text-amber-400 font-semibold">&bull; Catatan Operasional:</span> Port Te1/1/3 &amp; Te1/1/4 down adalah port transceiver fisik yang tidak terpasang modul, bukan gangguan sistem.
            </div>
          </div>
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
'@

# Read Hop 08 replacement
$newHop08 = @'
    <!-- ========================================== -->
    <!-- HOP 08: WIRELESS ACCESS GATEWAY (ONLINE) -->
    <!-- ========================================== -->
    <div id="hop-08" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">08</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 08 &middot; Wireless Access Gateway (Huawei WAG / BNG)</h3>
            <p class="text-xs text-zinc-400 font-mono">WAG-D5-KBL &bull; Huawei NE / ME60 Multiservice BNG &bull; Downlink GE6/0/0 (10G) ke SWAGGR &amp; WAC</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">SUBSCRIBER GATEWAY &amp; DOT1Q TERMINATION (ONLINE)</span>
      </div>

      <!-- Overview Grid -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2">
        <div class="text-[11px] font-mono font-bold text-white flex items-center gap-2">
          <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          PERAN HOP 08 PADA ARSITEKTUR WIFI.ID: SUBSCRIBER BNG &amp; QOS ENFORCEMENT
        </div>
        <p class="text-[11px] text-zinc-400 leading-relaxed">
          WAG (Wireless Access Gateway) mengelola <em>subscriber session</em>, penegakan profil bandwidth QoS pelanggan (misal WMS 20 Mbps, WiFi.id 100 Mbps), menangani pesan Change of Authorization (CoA UDP 3799) dari RADIUS, dan mengisolasi traffic multi-SSID melalui sub-interface dot1q berkecepatan 10G.
        </p>
      </div>

      <!-- Quick Metrics Grid -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">DOWNLINK TRUNK</div>
          <div class="text-white font-mono font-semibold mt-1">GE6/0/0 (10G)</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Ke SWAGGR Te1/0/7</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">ACTIVE SUB-INT</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">10 Sub-interfaces</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">VLAN 208, 1102, 1370, 1372..</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">CORE UPLINK</div>
          <div class="text-white font-mono font-semibold mt-1">3x High-Speed Trunks</div>
          <div class="text-[10px] text-emerald-400 mt-0.5">PE-D5-KBL-HSI (654, 600, 678)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">LLDP NEIGHBORS</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">6 Active Peers</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">PE, ME9, WAC03, WAC04, SWAGGR</div>
        </div>
      </div>

      <div class="space-y-5">
        
        <!-- 1. LLDP Neighbors on WAG -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>1. TABEL TETANGGA PROTOKOL LLDP DI WAG-D5-KBL</span>
            <button onclick="copyCode('cli-hop-08a', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-08a" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
WAG-D5-KBL&gt;disp lldp neighbor brief 
Local Intf              Neighbor Dev         Neighbor Intf        Exptime (sec)
------------------------------------------------------------------------------- 
<span class="text-white font-bold">GigabitEthernet1/0/0    PE-D5-KBL-HSI        654</span>                            104  <span class="text-emerald-400">&lt;-- Core Uplink #1</span>
GigabitEthernet1/1/0    ME9-D5-KBL-OLD       GigabitEthernet3/1/22          113
GigabitEthernet2/0/0    WAC03-D5-KBL-CS.wifi.id Te1/2                       94
GigabitEthernet2/1/0    ME9-D5-KBL-OLD       GigabitEthernet11/1/6          111
GigabitEthernet3/1/0    WAC04-D5-KBL-CS.wifi.id Te1/3                      117
<span class="text-white font-bold">GigabitEthernet4/0/0    PE-D5-KBL-HSI        600</span>                             99  <span class="text-emerald-400">&lt;-- Core Uplink #2</span>
<span class="text-white font-bold">GigabitEthernet6/0/0    SWAGGR-D5-KBL-CS.SWAGGRKBL.wifi.id Te1/0/7</span>          109  <span class="text-emerald-400">&lt;-- Downlink SWAGGR!</span>
GigabitEthernet6/1/0    WAC03-D5-KBL-CS.wifi.id Te5/4                       92
GigabitEthernet7/0/0    L2SW-5KBL-HW01       XGigabitEthernet1/0/10          91
<span class="text-white font-bold">GigabitEthernet7/1/0    PE-D5-KBL-HSI        678</span>                            119  <span class="text-emerald-400">&lt;-- Core Uplink #3</span>
GigabitEthernet8/0/0    ME9-D5-KBL-OLD       GigabitEthernet7/1/3            95
&lt;WAG-D5-KBL&gt;</pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Output LLDP menegaskan posisi sentral WAG-D5-KBL: <code class="text-white font-mono">GE6/0/0</code> menerima agregasi traffic SSID dari switch SWAGGR (Te1/0/7), interkoneksi langsung ke controller WAC03 &amp; WAC04, dan memiliki <strong>3 jalur redundan</strong> ke Core Internet Gateway <code class="text-emerald-400 font-mono">PE-D5-KBL-HSI</code> (port 654, 600, dan 678) untuk menjamin keandalan akses tanpa single-point-of-failure.
          </div>
        </div>

        <!-- 2. Dot1Q Sub-Interfaces on GE6/0/0 -->
        <div class="space-y-1.5">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>2. TERMINASI SUB-INTERFACE DOT1Q MULTI-SSID DI GE6/0/0 (10G)</span>
            <button onclick="copyCode('cli-hop-08b', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin CLI</button>
          </div>
          <pre id="cli-hop-08b" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
WAG-D5-KBL&gt;disp inte des | in 6/0/0
Interface                     PHY     Protocol Description            
GE6/0/0(10G)                  up      down     DOWNLINK TO WAC06-D5-KBL-CS
<span class="text-white font-bold">GE6/0/0.208                   up      up       ssid_biz_direct WLC02-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1101                  up      up       SSID_seamless@wifi.id-internet TO WAC06-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1102                  up      up       SSID_seamless@wifi.id-internet TO WLC02-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1245                  up      up       WMS-AP x IoT</span>
<span class="text-white font-bold">GE6/0/0.1370                  up      up       SSID_wifi.id TO WAC06-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1372                  up      up       SSID_wms TO WAC06-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1373                  up      up       ssid_biz_wms WLC02-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1378                  up      up       SSID_telkom.id TO WLC01-D5-KBL-CS</span>
<span class="text-white font-bold">GE6/0/0.1382                  up      up       SSID_WMS to WLC02-D5-KBL-CS direct WAG</span></pre>
          <div class="p-2.5 rounded-lg bg-zinc-900/60 border border-zinc-800 text-[11px] text-zinc-400 leading-relaxed">
            <span class="text-emerald-400 font-semibold font-mono">&bull; Analisis Engineer:</span> Setiap sub-interface beroperasi sebagai L3 Broadband Access Server (BAS):
            <br/>&bull; <code class="text-white font-mono">GE6/0/0.1372</code> &amp; <code class="text-white font-mono">GE6/0/0.1382</code>: Menampung traffic pelanggan <strong class="text-white">SSID WMS (Warkop Koramil)</strong>.
            <br/>&bull; <code class="text-zinc-200 font-mono">GE6/0/0.1370</code>: Menampung traffic publik <strong class="text-zinc-200">SSID @wifi.id</strong> dengan otentikasi portal voucher.
            <br/>&bull; <code class="text-zinc-200 font-mono">GE6/0/0.1101 / .1102</code>: Menampung traffic pelanggan seluler <strong class="text-zinc-200">seamless@wifi.id</strong> via EAP-SIM.
            <br/>&bull; <code class="text-zinc-200 font-mono">GE6/0/0.1378</code>: Menghubungkan dynamic interface <code class="text-emerald-400 font-mono">telkom.id-wag</code> WLC (Hop 07) untuk otentikasi internal.
          </div>
        </div>

      </div>
    </div>
'@

# Read Hop 09 replacement
$newHop09 = @'
    <!-- ========================================== -->
    <!-- HOP 09: PE / BRAS CORE INTERNET & AAA -->
    <!-- ========================================== -->
    <div id="hop-09" class="p-6 rounded-2xl border border-zinc-800 bg-zinc-950/80 space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 border-b border-zinc-800/80 gap-2">
        <div class="flex items-center gap-3">
          <span class="w-8 h-8 rounded-xl bg-white text-black font-mono font-bold text-xs flex items-center justify-center">09</span>
          <div>
            <h3 class="text-base font-bold text-white">HOP 09 &middot; Internet Core Gateway (PE / BRAS &amp; AAA Portal WPGEN)</h3>
            <p class="text-xs text-zinc-400 font-mono">PE-D5-KBL-HSI &bull; Provider Edge Router &bull; 3x Interconnect Trunks dari WAG-D5-KBL &bull; AAA welcome2.wifi.id</p>
          </div>
        </div>
        <span class="text-[10px] font-mono px-2.5 py-1 rounded-full bg-emerald-950/80 border border-emerald-800 text-emerald-400 font-semibold self-start sm:self-auto">BGP TRANSIT &amp; PUBLIC CGNAT (HSI) (ONLINE)</span>
      </div>

      <!-- Overview Grid -->
      <div class="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800/80 space-y-2">
        <div class="text-[11px] font-mono font-bold text-white flex items-center gap-2">
          <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          PERAN HOP 09 PADA ARSITEKTUR WIFI.ID: CORE EGRESS &amp; OTENTIKASI AAA
        </div>
        <p class="text-[11px] text-zinc-400 leading-relaxed">
          PE-D5-KBL-HSI adalah gerbang keluar Tier-1 yang menghubungkan seluruh subscriber WiFi.id Regional 5 menuju jaringan internet global. Menyediakan pool IP publik via Carrier-Grade NAT (CGNAT), routing default BGP ke Core Backbone Telkom, serta integrasi redirection HTTP ke Captive Portal Engine <code class="text-white font-mono">welcome2.wifi.id</code> (WPGEN).
        </p>
      </div>

      <!-- Quick Metrics Grid -->
      <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">CORE ROUTER</div>
          <div class="text-white font-mono font-semibold mt-1">PE-D5-KBL-HSI</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">High Speed Internet (HSI)</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">WAG TRUNK LINKS</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">Ports 654, 600, 678</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Direct Interconnect WAG</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">AAA ENGINE</div>
          <div class="text-white font-mono font-semibold mt-1">welcome2.wifi.id</div>
          <div class="text-[10px] text-emerald-400 mt-0.5">WPGEN / RADIUS RFC 2865</div>
        </div>
        <div class="p-3 rounded-xl bg-zinc-900/50 border border-zinc-800/80">
          <div class="text-zinc-500 text-[10px] font-mono">ROUTING PROTOCOL</div>
          <div class="text-emerald-400 font-mono font-semibold mt-1">eBGP Default Transit</div>
          <div class="text-[10px] text-zinc-400 mt-0.5">Telkom Backbone AS7713</div>
        </div>
      </div>

      <!-- End-to-End Authentication & Egress Workflow -->
      <div class="p-5 rounded-xl bg-black border border-zinc-800 space-y-4">
        <div class="text-xs font-mono font-bold text-white uppercase tracking-wider flex items-center gap-2">
          <span>ALUR LOGIKA KONEKSI SUBSCRIBER DARI LOGIN HINGGA AKSES INTERNET</span>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-4 gap-3 text-xs">
          
          <div class="p-3 rounded-lg bg-zinc-900/60 border border-zinc-800 space-y-2">
            <div class="flex items-center gap-2">
              <span class="w-5 h-5 rounded-full bg-zinc-800 text-zinc-300 font-mono font-bold text-[10px] flex items-center justify-center">1</span>
              <span class="font-bold text-white text-[11px]">HTTP Intercept</span>
            </div>
            <p class="text-[10px] text-zinc-400 leading-relaxed">
              Saat HP klien terhubung ke SSID WMS/WiFi.id tapi belum login, paket HTTP port 80 dicegat oleh WAG-D5-KBL. WAG mengembalikan respon HTTP 302 Redirect ke portal.
            </p>
          </div>

          <div class="p-3 rounded-lg bg-zinc-900/60 border border-zinc-800 space-y-2">
            <div class="flex items-center gap-2">
              <span class="w-5 h-5 rounded-full bg-zinc-800 text-zinc-300 font-mono font-bold text-[10px] flex items-center justify-center">2</span>
              <span class="font-bold text-white text-[11px]">AAA WPGEN Validasi</span>
            </div>
            <p class="text-[10px] text-zinc-400 leading-relaxed">
              Browser membuka <code class="text-zinc-200 font-mono">welcome2.wifi.id</code>. Klien memasukkan voucher/password. Engine WPGEN memverifikasi kredensial ke Server RADIUS AAA.
            </p>
          </div>

          <div class="p-3 rounded-lg bg-zinc-900/60 border border-zinc-800 space-y-2">
            <div class="flex items-center gap-2">
              <span class="w-5 h-5 rounded-full bg-zinc-800 text-zinc-300 font-mono font-bold text-[10px] flex items-center justify-center">3</span>
              <span class="font-bold text-white text-[11px]">CoA UDP 3799 Push</span>
            </div>
            <p class="text-[10px] text-zinc-400 leading-relaxed">
              RADIUS mengirimkan paket <code class="text-emerald-400 font-mono">Change of Authorization (CoA)</code> ke port UDP 3799 WAG. WAG membuka firewall dan menerapkan shaping bandwidth.
            </p>
          </div>

          <div class="p-3 rounded-lg bg-zinc-900/60 border border-zinc-800 space-y-2">
            <div class="flex items-center gap-2">
              <span class="w-5 h-5 rounded-full bg-emerald-500 text-black font-mono font-bold text-[10px] flex items-center justify-center">4</span>
              <span class="font-bold text-emerald-400 text-[11px]">Egress via PE Core</span>
            </div>
            <p class="text-[10px] text-zinc-400 leading-relaxed">
              Trafik internet klien diteruskan via 3 trunk interconnect WAG menuju <strong class="text-white">PE-D5-KBL-HSI</strong>, ditranslasi via CGNAT pool publik, dan meluncur bebas ke Internet.
            </p>
          </div>

        </div>

      </div>

    </div>
'@

# Replacement for Hop 06
$marker06 = '<div id="hop-06"'
$marker07 = '<div id="hop-07"'

$idx06 = $content.IndexOf($marker06)
$idx07 = $content.IndexOf($marker07)

if ($idx06 -ge 0 -and $idx07 -gt $idx06) {
    # Find the comment right above hop 07: <!-- =====...
    $searchBack = $content.LastIndexOf('<!-- =====', $idx07)
    if ($searchBack -gt $idx06) {
        $idx07 = $searchBack
    }
    $before06 = $content.Substring(0, $idx06)
    $after06 = $content.Substring($idx07)
    $content = $before06 + $newHop06 + "`r`n`r`n    " + $after06
    Write-Host "Hop 06 successfully replaced."
} else {
    Write-Warning "Failed to locate Hop 06 boundaries."
}

# Replacement for Hop 08 & Hop 09
$marker08 = '<div id="hop-08"'
$markerLab = '<div id="ccna-lab-section"'

$idx08 = $content.IndexOf($marker08)
$idxLab = $content.IndexOf($markerLab)

if ($idx08 -ge 0 -and $idxLab -gt $idx08) {
    $searchBack08 = $content.LastIndexOf('<!-- =====', $idx08)
    if ($searchBack08 -ge 0) {
        $idx08 = $searchBack08
    }
    $searchBackLab = $content.LastIndexOf('<!-- =====', $idxLab)
    if ($searchBackLab -gt $idx08) {
        $idxLab = $searchBackLab
    }
    $before08 = $content.Substring(0, $idx08)
    $after09 = $content.Substring($idxLab)
    $replacement = $newHop08 + "`r`n`r`n" + $newHop09 + "`r`n`r`n  </div>`r`n`r`n  "
    $content = $before08 + $replacement + $after09
    Write-Host "Hop 08 & Hop 09 successfully replaced."
} else {
    Write-Warning "Failed to locate Hop 08 / 09 boundaries."
}

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
Write-Host "Updated Hop 06, 08, 09 successfully."
