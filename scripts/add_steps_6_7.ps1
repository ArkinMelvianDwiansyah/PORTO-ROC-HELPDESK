$filePath = "d:\ARKIN\tes aim\scripts\e2e_tracing_content.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

$step6and7 = @'
      <!-- STEP 6: HUAWEI WAG ME60 BNG -->
      <div class="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-2.5">
            <span class="w-6 h-6 rounded-lg bg-emerald-500 text-black font-mono font-bold text-xs flex items-center justify-center">6</span>
            <span class="text-sm font-bold text-white">STEP 6 &middot; HUAWEI WAG ME60 (DOT1Q SUB-INTERFACE &amp; BAS SUBSCRIBER)</span>
          </div>
          <span class="text-[10px] font-mono text-emerald-400 px-2 py-0.5 rounded bg-zinc-800">BNG SUBSCRIBER MGMT</span>
        </div>
        <p class="text-zinc-400 leading-relaxed">
          Tujuan: Mengonfigurasi sub-interface dot1q pada interface 10G <code class="text-white font-mono">GE6/0/0</code>, mengaktifkan modul Broadband Access Server (BAS), menerapkan domain otentikasi portal web untuk SSID WMS &amp; WiFi.id, serta membuka port listener CoA UDP 3799 untuk pembaruan QoS dinamis dari RADIUS.
        </p>
        <div class="space-y-1">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>SKRIP KONFIGURASI CLI HUAWEI WAG:</span>
            <button onclick="copyCode('cli-prov-wag', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin Skrip</button>
          </div>
          <pre id="cli-prov-wag" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
<span class="text-zinc-500"># 1. Konfigurasi Sub-Interface WMS di GE6/0/0 (VLAN 1372 / 1382)</span>
system-view
interface GigabitEthernet6/0/0.1372
 description SSID_wms TO WAC06-D5-KBL-CS
 control-vid 1372 dot1q-termination
 dot1q termination vid 1372
 <span class="text-zinc-500"># 2. Aktifkan BAS Subscriber Interface</span>
 bas
 #
  access-type layer2-subscriber default-domain authentication wms-telkom
  authentication-method web
 #
 statistic enable
quit

<span class="text-zinc-500"># 3. Konfigurasi RADIUS Server &amp; CoA UDP 3799 untuk WPGEN</span>
radius-server group WPGEN-AAA
 radius-server authentication 172.16.100.15 1812
 radius-server accounting 172.16.100.15 1813
 radius-server shared-key cipher TelkomWifiId2026!
 radius-server coa-enable
 radius-server coa-port 3799
quit</pre>
        </div>
      </div>

      <!-- STEP 7: PE CORE INTERNET GATEWAY -->
      <div class="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-2.5">
            <span class="w-6 h-6 rounded-lg bg-emerald-500 text-black font-mono font-bold text-xs flex items-center justify-center">7</span>
            <span class="text-sm font-bold text-white">STEP 7 &middot; PE CORE ROUTER (3x INTERCONNECT TRUNKS, CGNAT POOL &amp; BGP TRANSIT)</span>
          </div>
          <span class="text-[10px] font-mono text-emerald-400 px-2 py-0.5 rounded bg-zinc-800">CORE INTERNET EGRESS</span>
        </div>
        <p class="text-zinc-400 leading-relaxed">
          Tujuan: Menghubungkan trunk interkoneksi ke WAG (Port 654, 600, 678), mengonfigurasi translasi IP publik (Carrier-Grade NAT) untuk pool IP pelanggan WiFi.id, serta mengalirkan default route via eBGP peering ke Backbone IP-MPLS Telkom (AS7713).
        </p>
        <div class="space-y-1">
          <div class="flex items-center justify-between text-[11px] font-mono text-zinc-400">
            <span>SKRIP KONFIGURASI CLI PE ROUTER:</span>
            <button onclick="copyCode('cli-prov-pe', this)" class="px-2 py-0.5 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[10px] transition-colors cursor-pointer">Salin Skrip</button>
          </div>
          <pre id="cli-prov-pe" class="p-4 rounded-xl bg-black border border-zinc-800 text-[11px] font-mono text-zinc-300 overflow-x-auto leading-relaxed">
<span class="text-zinc-500">! 1. Konfigurasi Interconnect Trunk ke WAG-D5-KBL</span>
interface GigabitEthernet654
 description TRUNK-1-FROM-WAG-D5-KBL-GE1/0/0
 mtu 9216
 no shutdown
exit

<span class="text-zinc-500">! 2. Konfigurasi CGNAT Pool untuk Egress Subscriber WiFi.id</span>
ip nat pool CGNAT-WIFIID-POOL 180.252.64.1 180.252.64.254 prefix-length 24
ip nat inside source list ACL-SUBSCRIBERS pool CGNAT-WIFIID-POOL overload

<span class="text-zinc-500">! 3. Peering eBGP ke Backbone Core Telkom Regional (AS 7713)</span>
router bgp 7713
 neighbor 10.255.0.1 remote-as 7713
 neighbor 10.255.0.1 description PEER-TO-CORE-IGW-SURABAYA
 address-family ipv4 unicast
  network 180.252.64.0 mask 255.255.255.0
  neighbor 10.255.0.1 activate
 exit-address-family
exit</pre>
        </div>
      </div>
'@

$target = 'config ap group-name WARKOP_KORAMIL GSGSK00415/TLK-WI31871627-0001' + "`r`n" + 'save config</pre>' + "`r`n" + '        </div>' + "`r`n" + '      </div>'

if ($content.Contains($target)) {
    $replacement = $target + "`r`n`r`n" + $step6and7
    $content = $content.Replace($target, $replacement)
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Steps 6 & 7 successfully added."
} else {
    Write-Warning "Target for Step 5 not matched, trying with normalized newline."
    $targetNorm = $target.Replace("`r`n", "`n")
    $contentNorm = $content.Replace("`r`n", "`n")
    if ($contentNorm.Contains($targetNorm)) {
        $replacementNorm = $targetNorm + "`n`n" + $step6and7.Replace("`r`n", "`n")
        $contentNorm = $contentNorm.Replace($targetNorm, $replacementNorm)
        [System.IO.File]::WriteAllText($filePath, $contentNorm.Replace("`n", "`r`n"), [System.Text.Encoding]::UTF8)
        Write-Host "Steps 6 & 7 added with normalized newlines."
    } else {
        Write-Error "Could not find target for Step 5."
    }
}
