# UTF-8 Script to build the modular tabbed documentation site for WIFI-ID NOTES ROC REGIONAL 5
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rootDir = Split-Path -Parent $PSScriptRoot
$blocksFile = Join-Path $rootDir "data\all_blocks_complete.json"
$imgMapFile = Join-Path $rootDir "data\image_map.json"

$blocks = Get-Content -Raw -Encoding UTF8 $blocksFile | ConvertFrom-Json
$imgMap = Get-Content -Raw -Encoding UTF8 $imgMapFile | ConvertFrom-Json

$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

function Sanitize-Text($text) {
    if (-not $text) { return "" }
    $s = $text
    $s = $s.Replace("âš", "").Replace("ï¸", "").Replace("â€¦", "...").Replace("â€ ", "- ").Replace("â‡’", "-> ").Replace("Â", "")
    return $s
}

function Get-RichHtml($prop) {
    if (-not $prop) { return "" }
    $out = ""
    foreach ($chunk in $prop) {
        $raw = Sanitize-Text $chunk[0]
        $text = [System.Net.WebUtility]::HtmlEncode($raw)
        if ($chunk.Count -gt 1) {
            foreach ($annot in $chunk[1]) {
                $type = $annot[0]
                switch ($type) {
                    "b" { $text = "<strong class='font-semibold text-white'>$text</strong>" }
                    "i" { $text = "<em class='italic text-zinc-300'>$text</em>" }
                    "s" { $text = "<del class='line-through text-zinc-500'>$text</del>" }
                    "c" { $text = "<code class='px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700/60 font-mono text-xs text-zinc-200'>$text</code>" }
                    "a" { 
                        $url = [System.Net.WebUtility]::HtmlEncode($annot[1])
                        $text = "<a href='$url' target='_blank' rel='noopener' class='text-zinc-200 hover:text-white underline underline-offset-4 decoration-zinc-600 hover:decoration-white transition-colors'>$text</a>" 
                    }
                }
            }
        }
        $out += $text
    }
    return $out
}

function Render-Block-Tree($id, [System.Collections.Generic.List[string]]$htmlList, $visited) {
    if ($visited.Contains($id)) { return }
    $visited.Add($id) | Out-Null
    
    $b = $blockMap[$id]
    if (-not $b) { return }
    
    $type = $b.type
    $rawText = ""
    if ($b.properties -and $b.properties.title) {
        $rawText = Get-RichHtml $b.properties.title
    }
    
    switch ($type) {
        "header" {
            $htmlList.Add("<h3 class='text-lg font-bold text-white mt-8 mb-3 pb-2 border-b border-zinc-800 flex items-center gap-2'><span class='w-2 h-2 rounded-full bg-zinc-400'></span>$rawText</h3>")
        }
        "sub_header" {
            $htmlList.Add("<h4 class='text-base font-semibold text-zinc-200 mt-6 mb-2 flex items-center gap-2'>$rawText</h4>")
        }
        "sub_sub_header" {
            $htmlList.Add("<h5 class='text-xs font-mono uppercase tracking-wider text-zinc-400 mt-4 mb-1.5'>$rawText</h5>")
        }
        "text" {
            if ($rawText) {
                $htmlList.Add("<p class='text-zinc-300 leading-relaxed text-sm mb-3'>$rawText</p>")
            } else {
                $htmlList.Add("<div class='h-2'></div>")
            }
        }
        "bulleted_list" {
            $htmlList.Add("<li class='text-zinc-300 text-sm ml-5 list-disc leading-relaxed mb-1 marker:text-zinc-500'>$rawText</li>")
        }
        "numbered_list" {
            $htmlList.Add("<li class='text-zinc-300 text-sm ml-5 list-decimal leading-relaxed mb-1 marker:text-zinc-500'>$rawText</li>")
        }
        "to_do" {
            $checked = if ($b.properties.checked -and $b.properties.checked[0][0] -eq "Yes") { "checked" } else { "" }
            $textClass = if ($checked) { "line-through text-zinc-500" } else { "text-zinc-300" }
            $htmlList.Add("<div class='flex items-start gap-2.5 my-1.5'><input type='checkbox' $checked disabled class='mt-1 rounded border-zinc-700 bg-zinc-900 text-white focus:ring-0 cursor-default'><span class='text-sm $textClass'>$rawText</span></div>")
        }
        "callout" {
            $htmlList.Add("<div class='my-4 p-4 rounded-xl bg-zinc-900/90 border border-zinc-800 text-sm text-zinc-300 flex items-start gap-3 shadow-inner'><div class='p-1.5 rounded bg-zinc-800 text-zinc-300 shrink-0'><svg class='w-4 h-4' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg></div><div class='flex-1 leading-relaxed'>$rawText</div></div>")
        }
        "quote" {
            $htmlList.Add("<blockquote class='border-l-2 border-zinc-600 pl-4 py-1 my-3 text-zinc-400 text-sm italic'>$rawText</blockquote>")
        }
        "divider" {
            $htmlList.Add("<hr class='border-zinc-800/80 my-6' />")
        }
        "code" {
            $lang = if ($b.properties.language) { $b.properties.language[0][0] } else { "bash" }
            $cleanCode = if ($b.properties.title) { ($b.properties.title | ForEach-Object { $_[0] }) -join "" } else { "" }
            $cleanCode = Sanitize-Text $cleanCode
            $encodedCode = [System.Net.WebUtility]::HtmlEncode($cleanCode)
            $codeId = "code_" + ([System.Guid]::NewGuid().ToString("N"))
            $tpl = @'
<div class="my-4 rounded-xl border border-zinc-800 bg-zinc-950 overflow-hidden shadow-sm">
  <div class="flex items-center justify-between px-3.5 py-2 bg-zinc-900/90 border-b border-zinc-800/80 text-xs text-zinc-400">
    <div class="flex items-center gap-2">
      <div class="flex gap-1.5">
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
      </div>
      <span class="font-mono text-zinc-400 font-medium lowercase ml-1">__LANG__</span>
    </div>
    <button onclick="copyCode('__CODE_ID__', this)" class="flex items-center gap-1.5 px-2.5 py-1 rounded bg-zinc-800/60 hover:bg-zinc-800 text-zinc-300 hover:text-white transition-all text-[11px] font-mono cursor-pointer border border-zinc-700/60 hover:border-zinc-600">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
      <span>Salin</span>
    </button>
  </div>
  <pre class="p-4 text-xs font-mono text-zinc-200 overflow-x-auto leading-relaxed"><code id="__CODE_ID__">__CODE_BODY__</code></pre>
</div>
'@
            $blockHtml = $tpl.Replace("__LANG__", $lang).Replace("__CODE_ID__", $codeId).Replace("__CODE_BODY__", $encodedCode)
            $htmlList.Add($blockHtml)
        }
        "image" {
            $localImg = $imgMap.$id
            $caption = if ($b.properties.caption) { Get-RichHtml $b.properties.caption } else { "" }
            if ($localImg) {
                $capHtml = if ($caption) { "<div class='text-xs text-zinc-400 mt-2 px-1 flex items-center gap-1.5'><svg class='w-3.5 h-3.5 text-zinc-500 shrink-0' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg><span>$caption</span></div>" } else { "" }
                $cleanCapAttr = [System.Net.WebUtility]::HtmlEncode($caption)
                $imgTpl = @'
<div class="my-4 group">
  <div class="relative overflow-hidden rounded-xl border border-zinc-800 bg-zinc-950 p-2 transition-all hover:border-zinc-600 shadow-sm">
    <img src="__SRC__" alt="Dokumentasi WIFI.ID" loading="lazy" class="w-full max-h-[540px] object-contain rounded-lg cursor-zoom-in transition-transform duration-200 group-hover:scale-[1.002]" onclick="openLightbox('__SRC__', '__CAPTION__')" />
    <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-900/95 text-zinc-200 text-xs px-2.5 py-1 rounded-lg border border-zinc-700 pointer-events-none flex items-center gap-1.5 backdrop-blur shadow-lg font-mono">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"></path></svg>
      Perbesar
    </div>
  </div>
  __CAP_HTML__
</div>
'@
                $blockHtml = $imgTpl.Replace("__SRC__", $localImg).Replace("__CAPTION__", $cleanCapAttr).Replace("__CAP_HTML__", $capHtml)
                $htmlList.Add($blockHtml)
            }
        }
        "bookmark" {
            $link = if ($b.properties.link) { $b.properties.link[0][0] } else { "#" }
            $bmTpl = @'
<div class="my-3">
  <a href="__LINK__" target="_blank" rel="noopener" class="flex items-center justify-between p-3.5 rounded-xl border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800/80 hover:border-zinc-700 transition-all text-sm group">
    <div class="flex items-center gap-2.5 truncate">
      <svg class="w-4 h-4 text-zinc-400 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
      <span class="text-zinc-200 font-medium truncate">__TEXT__</span>
    </div>
    <span class="text-xs text-zinc-500 font-mono ml-4 shrink-0">__LINK__</span>
  </a>
</div>
'@
            $blockHtml = $bmTpl.Replace("__LINK__", $link).Replace("__TEXT__", $rawText)
            $htmlList.Add($blockHtml)
        }
        default {
            if ($rawText) {
                $htmlList.Add("<div class='text-xs text-zinc-400 font-mono my-1'>[$type] $rawText</div>")
            }
        }
    }
    
    if ($b.content -and $type -ne "page") {
        foreach ($childId in $b.content) {
            Render-Block-Tree $childId $htmlList $visited
        }
    }
}

function Render-Subpage-Card($pageId, $sectionAnchor, $sectionBadge, $sectionDesc = "") {
    $p = $blockMap[$pageId]
    if (-not $p) { return "" }
    
    $pTitle = if ($p.properties -and $p.properties.title) {
        ($p.properties.title | ForEach-Object { $_[0] }) -join ""
    } else { "Subpage" }
    $pTitle = Sanitize-Text $pTitle
    
    $lines = [System.Collections.Generic.List[string]]::new()
    $vSet = [System.Collections.Generic.HashSet[string]]::new()
    
    if ($p.content) {
        foreach ($cid in $p.content) {
            Render-Block-Tree $cid $lines $vSet
        }
    }
    
    $innerContent = $lines -join "`n"
    $descHtml = if ($sectionDesc) { "<p class='text-zinc-400 text-sm mt-1.5 mb-5 leading-relaxed'>$sectionDesc</p>" } else { "" }
    $shortId = if ($p.id.Length -ge 8) { $p.id.Substring(0, 8) } else { $p.id }
    
    $cardTpl = @'
    <div id="__ANCHOR__" class="mb-10 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/60 shadow-sm">
      <div class="flex items-center justify-between gap-4 mb-2">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">__BADGE__</span>
          <span class="text-xs font-mono text-zinc-500">ID: __SHORT_ID__...</span>
        </div>
      </div>
      <h3 class="text-xl font-bold text-white tracking-tight flex items-center gap-3">
        __TITLE__
      </h3>
      __DESC_HTML__
      <div class="mt-5 space-y-2">
        __CONTENT__
      </div>
    </div>
'@
    return $cardTpl.Replace("__ANCHOR__", $sectionAnchor).Replace("__BADGE__", $sectionBadge).Replace("__SHORT_ID__", $shortId).Replace("__TITLE__", $pTitle).Replace("__DESC_HTML__", $descHtml).Replace("__CONTENT__", $innerContent)
}

Write-Output "Building individual tabs..."

# =========================================================================
# TAB 1: TOPOLOGI & ARSITEKTUR LAYANAN (Ditaruh Paling Atas!)
# =========================================================================
$tab1Html = @'
<div class="space-y-8">
  <!-- Header Title -->
  <div class="border-b border-zinc-800/80 pb-6">
    <div class="flex items-center gap-2 mb-2">
      <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 02 &middot; ARSITEKTUR &amp; TOPOLOGI</span>
      <span class="text-xs font-mono text-zinc-500">REV. 2026.11</span>
    </div>
    <h1 class="text-3xl font-extrabold text-white tracking-tight">Topologi Jaringan WiFi.id &amp; Arsitektur Layanan</h1>
    <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
      Gambaran arsitektur jaringan end-to-end WiFi Managed Service (WMS Lite &amp; WMS Reguler), alur data captive portal, pemetaan VLAN, dan direktori akses portal operasional internal ROC Regional 5.
    </p>
  </div>

  <!-- Internal Confidentiality Banner (Clean SVGs, No Broken Encoding) -->
  <div class="p-4 rounded-xl border border-zinc-800 bg-zinc-950 flex items-start gap-3.5 shadow-sm">
    <div class="p-2 rounded-lg bg-zinc-900 border border-zinc-800 text-zinc-300 shrink-0">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
    </div>
    <div>
      <div class="text-xs font-mono font-bold uppercase tracking-wider text-white">PERINGATAN KERAHASIAAN TIM</div>
      <p class="text-xs text-zinc-400 mt-0.5 leading-relaxed">
        JANGAN DI-SHARE KELUAR TIM! Seluruh data kredensial, IP NAT WISM, format perintah CLI TACACS/WAC, dan prosedur rekonsiliasi merupakan panduan operasional internal tim ROC Regional 5 dan CCAN Witel.
      </p>
    </div>
  </div>

  <!-- TOPOLOGY MASTER DIAGRAM (DETAILED VIEW AT THE TOP!) -->
  <div class="rounded-2xl border border-zinc-800 bg-zinc-950 p-6 shadow-sm">
    <div class="flex items-center justify-between mb-4">
      <div>
        <span class="text-[11px] font-mono uppercase tracking-wider text-zinc-400">Diagram Arsitektur Utama</span>
        <h2 class="text-xl font-bold text-white tracking-tight mt-0.5">Topologi WiFi.id Secara Lengkap</h2>
      </div>
      <button onclick="openLightbox('assets/images/340bc60a-349d-80f7-8bf2-cbee5f186482.png', 'Diagram Lengkap Topologi Layanan WiFi.id')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-xs font-mono text-zinc-200 border border-zinc-700/80 transition-all cursor-pointer">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"></path></svg>
        <span>Perbesar Diagram</span>
      </button>
    </div>

    <div class="relative rounded-xl border border-zinc-800 bg-black/60 p-3 group cursor-zoom-in" onclick="openLightbox('assets/images/340bc60a-349d-80f7-8bf2-cbee5f186482.png', 'Diagram Lengkap Topologi Layanan WiFi.id')">
      <img src="assets/images/340bc60a-349d-80f7-8bf2-cbee5f186482.png" alt="Topologi WiFi.id Lengkap" class="w-full h-auto max-h-[850px] object-contain rounded-lg transition-transform duration-200 group-hover:scale-[1.002]" />
      <div class="absolute bottom-4 right-4 bg-zinc-900/90 text-zinc-300 text-xs px-3 py-1.5 rounded-lg border border-zinc-700 pointer-events-none flex items-center gap-2 backdrop-blur shadow">
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path></svg>
        <span>Klik untuk Zoom Resolusi Penuh</span>
      </div>
    </div>
    <p class="text-xs text-zinc-400 mt-3 text-center">
      Gambar 1.0: End-to-End Service Flow Layanan WMS: CPE/Modem &amp; Access Point &rarr; Metro Ethernet &rarr; Cisco WAC/WISM &rarr; RADIUS WISPr &amp; Captive Portal (<code class="font-mono text-zinc-300">welcome2.wifi.id</code>).
    </p>
  </div>

  <!-- Dual Architecture Breakdown (WMS Lite vs WMS Reguler) -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <!-- WMS LITE -->
    <div class="rounded-2xl border border-zinc-800 bg-zinc-950 p-6 flex flex-col justify-between">
      <div>
        <div class="flex items-center justify-between mb-3">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-800">CPE INTEGRATED</span>
          <span class="text-xs font-mono text-zinc-500">VLAN 4090 / 500</span>
        </div>
        <h3 class="text-xl font-bold text-white tracking-tight">1. WMS Lite (Modem Langsung)</h3>
        <p class="text-xs text-zinc-400 mt-1 mb-4 leading-relaxed">
          Layanan berbasis Optical Network Terminal (ONT) pelanggan di mana perangkat ONT bertindak langsung sebagai access point pemancar sinyal WiFi.
        </p>
        <ul class="space-y-2.5 text-xs text-zinc-300">
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Perangkat:</strong> ONT ZTE (F609, F670) atau Huawei (HG8245A/H).</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>VLAN 4090:</strong> Traffic data captive portal WMS (welcome2.wifi.id).</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>VLAN 500 / 100:</strong> Traffic telephony / voice (VOIP).</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Konfigurasi:</strong> Dipush via OLT TACACS CLI atau ACS I-Booster (TR-069).</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Port Locating:</strong> Wajib DHCP Option 82 aktif di OLT agar tidak muncul error X.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Identifikasi:</strong> Cukup menggunakan SID / Nomor Internet pelanggan.</span>
          </li>
        </ul>
      </div>
      <div class="mt-6 pt-4 border-t border-zinc-800/80 flex items-center justify-between text-xs font-mono text-zinc-400">
        <span>Pengendali: OLT ZTE &amp; ACS</span>
        <span class="text-zinc-500">Tanpa WLC Cisco</span>
      </div>
    </div>

    <!-- WMS REGULER -->
    <div class="rounded-2xl border border-zinc-800 bg-zinc-950 p-6 flex flex-col justify-between">
      <div>
        <div class="flex items-center justify-between mb-3">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-800">ENTERPRISE AP</span>
          <span class="text-xs font-mono text-zinc-500">CAPWAP / WLC</span>
        </div>
        <h3 class="text-xl font-bold text-white tracking-tight">2. WMS Reguler (AP Eksternal)</h3>
        <p class="text-xs text-zinc-400 mt-1 mb-4 leading-relaxed">
          Layanan berbasis Access Point terpisah kelas enterprise (Cisco) yang terhubung ke Switch Metro dan dikontrol terpusat oleh controller WLC/WISM.
        </p>
        <ul class="space-y-2.5 text-xs text-zinc-300">
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Perangkat:</strong> Cisco Aironet (1702, 1852, 2802, 3802) / Catalyst.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>CAPWAP Tunnel:</strong> UDP 5246 (Control) dan UDP 5247 (Data) ke WLC/WAC.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>AP Groups:</strong> Mapping SSID kustom, RF channel, dan interface VLAN di WLC.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>VLAN Uplink:</strong> VSI WAC_2888 / VLAN 2858 pada Metro Ethernet.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Sinkronisasi:</strong> Wajib sinkron antara datek APOSE, WPGEN, dan WISM GUI.</span>
          </li>
          <li class="flex items-start gap-2">
            <span class="w-1.5 h-1.5 rounded-full bg-zinc-400 mt-1.5 shrink-0"></span>
            <span><strong>Identifikasi:</strong> Memerlukan SID + AP-SN + AP-MAC + IP WAC.</span>
          </li>
        </ul>
      </div>
      <div class="mt-6 pt-4 border-t border-zinc-800/80 flex items-center justify-between text-xs font-mono text-zinc-400">
        <span>Pengendali: Cisco WLC/WISM</span>
        <span class="text-zinc-500">APEHBOT &amp; Mozilla</span>
      </div>
    </div>
  </div>

  <!-- End-to-End Traffic Architecture Table -->
  <div class="rounded-2xl border border-zinc-800 bg-zinc-950 p-6 shadow-sm overflow-hidden">
    <div class="mb-4">
      <span class="text-[11px] font-mono uppercase tracking-wider text-zinc-400">Parameter Teknis</span>
      <h3 class="text-lg font-bold text-white tracking-tight mt-0.5">Tabel Matriks Protokol &amp; VLAN Jaringan</h3>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left text-xs font-mono border-collapse">
        <thead>
          <tr class="border-b border-zinc-800 bg-zinc-900/60 text-zinc-400">
            <th class="p-3 font-semibold">Tipe Layanan</th>
            <th class="p-3 font-semibold">VLAN Tag</th>
            <th class="p-3 font-semibold">Protokol / Port</th>
            <th class="p-3 font-semibold">Mekanisme Autentikasi</th>
            <th class="p-3 font-semibold">Sistem Pengendali</th>
            <th class="p-3 font-semibold">Alokasi IP Klien</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-zinc-800/60 text-zinc-300">
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-medium text-white">WMS Lite Data</td>
            <td class="p-3"><span class="px-2 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-200">4090</span></td>
            <td class="p-3">HTTP/HTTPS (80, 443)</td>
            <td class="p-3">WISPr Captive Portal / RADIUS</td>
            <td class="p-3">OLT ZTE &amp; ACS TR-069</td>
            <td class="p-3">DHCP Pool BRAS (Opt 82)</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-medium text-white">WMS Reguler AP</td>
            <td class="p-3"><span class="px-2 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-200">2888 / 2858</span></td>
            <td class="p-3">CAPWAP (UDP 5246, 5247)</td>
            <td class="p-3">Centralized WLC AP-Group</td>
            <td class="p-3">Cisco WLC 5508 / 8540</td>
            <td class="p-3">DHCP Pool WAC / Interface</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-medium text-white">VOIP / Telephony</td>
            <td class="p-3"><span class="px-2 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-200">500 / 100</span></td>
            <td class="p-3">SIP (5060) / RTP Voice</td>
            <td class="p-3">SIP Digest Authentication</td>
            <td class="p-3">Softswitch Telkom</td>
            <td class="p-3">Static / DHCP Subnet VOIP</td>
          </tr>
          <tr class="hover:bg-zinc-900/30">
            <td class="p-3 font-medium text-white">ACS TR-069</td>
            <td class="p-3"><span class="px-2 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-200">100</span></td>
            <td class="p-3">CWMP / SOAP (HTTP 7547)</td>
            <td class="p-3">Digest / TLS ACS Certificate</td>
            <td class="p-3">I-Booster ACS Telkom</td>
            <td class="p-3">IP Managemen ONT</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Operational Portals Quick Directory -->
  <div class="rounded-2xl border border-zinc-800 bg-zinc-950 p-6 shadow-sm">
    <div class="mb-4">
      <span class="text-[11px] font-mono uppercase tracking-wider text-zinc-400">Akses Cepat</span>
      <h3 class="text-lg font-bold text-white tracking-tight mt-0.5">Portal &amp; Tools Operasional Utama</h3>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
      <a href="https://smarthub.wifi.id/" target="_blank" rel="noopener" class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">SMARTHUB</span>
          <svg class="w-3.5 h-3.5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Dashboard tiket reactive AP down, reactive service logic, datek APOSE, dan inventory.</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">smarthub.wifi.id</div>
      </a>

      <a href="https://wms.wifi.id/wp-wms/" target="_blank" rel="noopener" class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">WPGEN WMS</span>
          <svg class="w-3.5 h-3.5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Cek status profile WMS, AP Group, Location-ID, buka isolir (bukis), dan reset kata sandi SSID.</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">wms.wifi.id/wp-wms</div>
      </a>

      <a href="https://acs-ibooster.telkom.co.id/index.php" target="_blank" rel="noopener" class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">ACS I-BOOSTER</span>
          <svg class="w-3.5 h-3.5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Konfigurasi TR-069 ONT pelanggan, troubleshooting security type (Open System), dan ubah channel RF.</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">acs-ibooster.telkom.co.id</div>
      </a>

      <a href="http://insera.telkom.co.id/" target="_blank" rel="noopener" class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900 hover:border-zinc-700 transition-all group">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">INSERA TELKOM</span>
          <svg class="w-3.5 h-3.5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Sistem ticketing nasional Telkom. Menggunakan No Nossa dari Smarthub untuk tracking tiket CCAN.</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">insera.telkom.co.id</div>
      </a>

      <div class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">APEHBOT (TELEGRAM)</span>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">BOT INTERNAL</span>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Bot pencarian datek AP cepat via command <code class="text-zinc-200">/apsn [SN]</code> untuk mendapatkan IP WAC dan IP NAT WISM.</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">Telegram: @apehbot / APOSE</div>
      </div>

      <div class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-mono font-semibold text-white">WEB MOJANG REGIONAL 5</span>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-300">REKONSILIASI</span>
        </div>
        <p class="text-xs text-zinc-400 leading-relaxed">Aplikasi upload data rekap harian hasil rekonsiliasi Excel VLOOKUP (Sugar H-1 vs Prabac).</p>
        <div class="mt-3 text-[11px] font-mono text-zinc-500 truncate">Internal Web Mojang ROC5</div>
      </div>
    </div>
  </div>

  <!-- Bottom Navigation Buttons -->
  <div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
    <button onclick="switchTab('tab-e2e-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
      <span>Kembali ke Modul 01: Tracing E2E</span>
    </button>
    <button onclick="switchTab('tab-ticketing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
      <span>Lanjut ke Modul 03: Tiketing WiFi.id</span>
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
    </button>
  </div>
</div>
'@

# =========================================================================
# TAB 2: TIKETING WIFI-ID
# =========================================================================
$tab2List = [System.Collections.Generic.List[string]]::new()
$tab2Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 03 &middot; SOP TIKETING</span>
    <span class="text-xs font-mono text-zinc-500">SMARTHUB &amp; INSERA</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Tiketing WiFi.id &amp; Penanganan Gangguan</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Klasifikasi jenis gangguan (Reactive AP Mati vs Reactive Service Logic), verifikasi nomor Nossa di Insera, dan prosedur order eskalasi tiket ke CCAN Witel.
  </p>
</div>
'@
$tab2List.Add($tab2Header)
$tab2List.Add((Render-Subpage-Card "340bc60a-349d-80f2-9d4e-e97691869aba" "sub-ticketing" "SOP UTAMA" "Alur monitoring, klasifikasi tiket gangguan, dan eskalasi ke CCAN Witel."))
$tab2List.Add((Render-Subpage-Card "340bc60a-349d-8078-b957-db39a075300c" "sub-open-tiket" "DISPATCH" "Prosedur pembukaan tiket gangguan baru."))
$tab2Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-topologi')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 02: Topologi Jaringan</span>
  </button>
  <button onclick="switchTab('tab-ganti-ap')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 04: SOP Ganti AP</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab2List.Add($tab2Footer)
$tab2Html = $tab2List -join "`n"

# =========================================================================
# TAB 3: GANTI AP (WLC CISCO)
# =========================================================================
$tab3List = [System.Collections.Generic.List[string]]::new()
$tab3Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 04 &middot; ACCESS POINT &amp; WLC</span>
    <span class="text-xs font-mono text-zinc-500">CISCO WISM / WAC</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">SOP Ganti Access Point (WLC Cisco)</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Panduan lengkap penggantian AP lama ke AP baru, pencarian IP NAT via APEHBOT, akses browser Mozilla Firefox frameset, serta sinkronisasi AP Group di WPGEN &amp; APOSE.
  </p>
</div>
'@
$tab3List.Add($tab3Header)
$tab3List.Add((Render-Subpage-Card "340bc60a-349d-80f9-bdd1-f004dbd11ed2" "sub-ganti-ap" "SOP GANTI AP" "Prosedur penggantian unit AP pada WISM yang sama beserta sinkronisasi parameter APOSE dan WPGEN."))
$tab3List.Add((Render-Subpage-Card "340bc60a-349d-81ee-93aa-cacbb6ef33a2" "sub-login-wism" "LOGIN WLC" "Langkah resolusi IP NAT via Telegram Bot APEHBOT dan panduan browser Mozilla Firefox untuk akses controller WISM Cisco."))
$tab3List.Add((Render-Subpage-Card "340bc60a-349d-80b6-a7ea-f2a88be9038d" "sub-ganti-ap-beda" "WISM MIGRATION" "Prosedur penyesuaian jika penggantian Access Point melibatkan controller WISM / WAC yang berbeda."))
$tab3List.Add((Render-Subpage-Card "340bc60a-349d-80ac-93ba-f7bb8263f82a" "sub-ap-gress" "AP GRESS" "Registrasi unit Access Point baru (gress) yang belum pernah terasosiasi ke controller."))
$tab3Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-ticketing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 03: Tiketing WiFi.id</span>
  </button>
  <button onclick="switchTab('tab-wp-error')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 05: WP-Error &amp; Captive</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab3List.Add($tab3Footer)
$tab3Html = $tab3List -join "`n"

# =========================================================================
# TAB 4: WP-ERROR / URL ERROR
# =========================================================================
$tab4List = [System.Collections.Generic.List[string]]::new()
$tab4Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 05 &middot; CAPTIVE PORTAL</span>
    <span class="text-xs font-mono text-zinc-500">WELCOME2.WIFI.ID</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Troubleshooting WP-Error &amp; Captive Portal</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Solusi kegagalan redirect halaman login welcome2.wifi.id: studi kasus keamanan ACS, mismatch Location-ID/SSID di WPGEN, dan perbaikan DHCP Port Locating silang merah (X).
  </p>
</div>
'@
$tab4List.Add($tab4Header)
$tab4List.Add((Render-Subpage-Card "340bc60a-349d-8028-ad88-e48661065286" "sub-wp-error" "CAPTIVE PORTAL" "Analisis mendalam 3 kasus utama WP-Error (ACS Security Type Open System, Mismatch Location-ID di WPGEN, dan URL parameter)."))
$tab4List.Add((Render-Subpage-Card "340bc60a-349d-80ff-93ad-ed04e4254f4e" "sub-port-locating" "DHCP OPTION 82" "Perbaikan status Port Locating silang merah (X) pada ONT GPON yang belum terinjeksi parameter DHCP."))
$tab4Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-ganti-ap')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 04: SOP Ganti AP</span>
  </button>
  <button onclick="switchTab('tab-gpon-ont')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 06: GPON &amp; ONT Config</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab4List.Add($tab4Footer)
$tab4Html = $tab4List -join "`n"

# =========================================================================
# TAB 5: KONFIGURASI GPON, OLT TACACS & ONT
# =========================================================================
$tab5List = [System.Collections.Generic.List[string]]::new()
$tab5Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 06 &middot; GPON &amp; OLT</span>
    <span class="text-xs font-mono text-zinc-500">ZTE TACACS &amp; WPGEN</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Konfigurasi GPON, OLT TACACS &amp; ONT</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Skrip CLI lengkap OLT ZTE untuk layanan WMS Lite (VLAN 4090 &amp; VLAN 500), prosedur buka isolir (bukis), pencarian SN ONT induk di Smarthub, dan ganti password SSID.
  </p>
</div>
'@
$tab5List.Add($tab5Header)
$tab5List.Add((Render-Subpage-Card "340bc60a-349d-800f-9785-dd6f0114c2a2" "sub-tacacs" "TACACS CLI" "Skrip konfigurasi OLT ZTE GPON saat penggantian ONT baru untuk WMS Lite (VLAN 4090, 500/100, TCONT, GEMPORT)."))
$tab5List.Add((Render-Subpage-Card "340bc60a-349d-80f3-abe1-fbea9a8c2de8" "sub-sn-ont" "SMARTHUB" "Pencarian Serial Number perangkat ONT induk berdasarkan Serial Number Access Point (AP-SN)."))
$tab5List.Add((Render-Subpage-Card "386bc60a-349d-804c-bffe-ff22dfab5499" "sub-bukis" "BILLING / ISOLIR" "Prosedur aktivasi kembali layanan pelanggan yang terisolir (buka isolir) melalui portal WPGEN."))
$tab5List.Add((Render-Subpage-Card "340bc60a-349d-805d-a0a5-ccaaa5369cc8" "sub-password" "CREDENTIALS" "Pengecekan dan perubahan kata sandi SSID layanan WMS melalui portal WPGEN."))
$tab5List.Add((Render-Subpage-Card "340bc60a-349d-809a-b3b1-edad2b75ee0e" "sub-client-usage" "MONITORING" "Monitoring statistik traffic dan perangkat klien terhubung pada frekuensi 2.4 GHz dan 5 GHz."))
$tab5Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-wp-error')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 05: WP-Error &amp; Captive</span>
  </button>
  <button onclick="switchTab('tab-mojang')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 07: Rekonsiliasi Mojang</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab5List.Add($tab5Footer)
$tab5Html = $tab5List -join "`n"

# =========================================================================
# TAB 6: REKONSILIASI MOJANG (EXCEL SOP)
# =========================================================================
$tab6List = [System.Collections.Generic.List[string]]::new()
$tab6Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 07 &middot; REKAPITULASI</span>
    <span class="text-xs font-mono text-zinc-500">EXCEL &amp; WEB MOJANG</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Rekonsiliasi Harian Mojang (Excel SOP)</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Panduan pengolahan data rekap harian AP gangguan menggunakan Microsoft Excel: perbandingan VLOOKUP Sugar Report H-1 terhadap Master Inventory Prabac, pembersihan prefix witel, dan upload ke Web Mojang ROC5.
  </p>
</div>
'@
$tab6List.Add($tab6Header)
$tab6List.Add((Render-Subpage-Card "386bc60a-349d-80b9-9a98-dad9aa97c58e" "sub-mojang" "REKONSILIASI" "Langkah detail langkah demi langkah Excel VLOOKUP, formula pembersihan string, dan upload hasil rekap harian."))
$tab6Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-gpon-ont')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 06: GPON &amp; ONT Config</span>
  </button>
  <button onclick="switchTab('tab-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 08: Network Tracing CLI</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab6List.Add($tab6Footer)
$tab6Html = $tab6List -join "`n"

# =========================================================================
# TAB 7: NETWORK TRACING & CISCO CLI
# =========================================================================
$tab7List = [System.Collections.Generic.List[string]]::new()
$tab7Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 08 &middot; NETWORK TRACING</span>
    <span class="text-xs font-mono text-zinc-500">CISCO WAC &amp; METRO ETHERNET</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Network Tracing CLI &amp; Cisco WAC</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Pencarian data teknis AP via Bot Telegram APEHBOT, trace MAC address di Cisco WAC remote CLI, identifikasi interface downlink port Metro Ethernet, serta pembuatan SSID &amp; AP Group di Cisco WLC.
  </p>
</div>
'@
$tab7List.Add($tab7Header)

# Render root block index 42 to end into Tab 7
$rootBlock = $blockMap["340bc60a-349d-8029-8c50-e2ff294097b4"]
$tracingLines = [System.Collections.Generic.List[string]]::new()
$tracingVSet = [System.Collections.Generic.HashSet[string]]::new()

if ($rootBlock.content) {
    for ($i = 42; $i -lt $rootBlock.content.Count; $i++) {
        $rcid = $rootBlock.content[$i]
        $rb = $blockMap[$rcid]
        if ($rb -and $rb.type -ne "page") {
            Render-Block-Tree $rcid $tracingLines $tracingVSet
        }
    }
}

$tab7CardTpl = @'
<div class="mb-10 p-6 rounded-2xl border border-zinc-800 bg-zinc-950/60 shadow-sm">
  <div class="flex items-center gap-2.5 mb-2">
    <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-900 text-zinc-300 border border-zinc-700/80 font-medium">CLI &amp; TELEGRAM</span>
    <span class="text-xs font-mono text-zinc-500">ROOT OPERATIONAL NOTES</span>
  </div>
  <h3 class="text-xl font-bold text-white tracking-tight">Pencarian Datek APEHBOT, Tracing MAC WAC &amp; Konfigurasi Cisco WLC</h3>
  <div class="mt-5 space-y-2">
    __TRACING_LINES__
  </div>
</div>
'@
$tab7List.Add($tab7CardTpl.Replace("__TRACING_LINES__", ($tracingLines -join "`n")))

$tab7Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-mojang')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 07: Rekonsiliasi Mojang</span>
  </button>
  <button onclick="switchTab('tab-quick-ops')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Lanjut ke Modul 09: Quick Notes &amp; Tips</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
  </button>
</div>
'@
$tab7List.Add($tab7Footer)
$tab7Html = $tab7List -join "`n"

# =========================================================================
# TAB 8: END-TO-END TRACING & PROBLEM SOLVING (FROM e2e_tracing_content.html)
# =========================================================================
$tabE2EHtml = [System.IO.File]::ReadAllText("$PSScriptRoot\e2e_tracing_content.html", [System.Text.Encoding]::UTF8)

# =========================================================================
# TAB 9: OPERATIONAL QUICK NOTES & TIPS
# =========================================================================
$tab8List = [System.Collections.Generic.List[string]]::new()
$tab8Header = @'
<div class="border-b border-zinc-800/80 pb-6 mb-8">
  <div class="flex items-center gap-2 mb-2">
    <span class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-medium tracking-wide uppercase bg-zinc-900 border border-zinc-800 text-zinc-300">MODUL 09 &middot; QUICK NOTES</span>
    <span class="text-xs font-mono text-zinc-500">OPERATIONAL REFERENCE</span>
  </div>
  <h1 class="text-3xl font-extrabold text-white tracking-tight">Catatan Singkat &amp; Tips Operasional</h1>
  <p class="text-sm text-zinc-400 mt-2 leading-relaxed">
    Panduan cepat optimasi frekuensi radio (Ganti Channel), mitigasi AP flapping/intermitten, konfigurasi otomasi RSA key, resend email kredensial, dan persiapan arsitektur WiFi 6.
  </p>
</div>
'@
$tab8List.Add($tab8Header)
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8036-b123-dab53afd82c8" "sub-channel" "RADIO FREQ" "Pengaturan frekuensi dan channel AP via ACS I-Booster untuk menghindari interferensi sinyal."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-80ba-8ab6-ecc230b933e8" "sub-intermitten" "QUALITY" "Penanganan masalah AP flapping / intermitten akibat degradasi optik atau daya PoE."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8026-9aa7-f457eeed4ab0" "sub-rsa" "SECURITY" "Pembuatan kunci enkripsi RSA untuk otentikasi aman server."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8067-99f0-c5e085b0594b" "sub-rsa-auto" "AUTOMATION" "Skrip otomasi registrasi kunci RSA pada host target."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8011-bfc3-fa722365c73e" "sub-resend-email" "NOTIFICATION" "Kirim ulang email notifikasi akun pelanggan yang belum menerima kredensial login."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8059-9de2-ee3a6bc16cae" "sub-wifiv6" "NEXT-GEN" "Standarisasi implementasi Access Point generasi WiFi 6 (802.11ax)."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-8099-bd22-d63b314e03a1" "sub-create-ssid" "WLAN CONFIG" "Pembuatan profil SSID kustom."))
$tab8List.Add((Render-Subpage-Card "340bc60a-349d-802e-943a-d0272cc53185" "sub-groping-ssid" "AP GROUPING" "Pengelompokan SSID ke dalam target AP Group."))
$tab8Footer = @'
<div class="pt-6 border-t border-zinc-800 flex items-center justify-between">
  <button onclick="switchTab('tab-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-zinc-200 border border-zinc-700 text-xs transition-colors cursor-pointer">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
    <span>Kembali ke Modul 08: Network Tracing CLI</span>
  </button>
  <button onclick="switchTab('tab-e2e-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-xl bg-white hover:bg-zinc-200 text-black font-semibold text-xs transition-colors cursor-pointer">
    <span>Kembali ke Modul 01: Tracing E2E</span>
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>
  </button>
</div>
'@
$tab8List.Add($tab8Footer)
$tab8Html = $tab8List -join "`n"


# =========================================================================
# ASSEMBLE MASTER HTML SHELL
# =========================================================================
Write-Output "Assembling master HTML file..."

$fullTpl = @'
<!DOCTYPE html>
<html lang="id" class="bg-black text-zinc-100 antialiased selection:bg-zinc-800 selection:text-white">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WIFI-ID NOTES &middot; ROC REGIONAL 5</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
            mono: ['JetBrains Mono', 'ui-monospace', 'SFMono-Regular', 'Menlo', 'Consolas', 'monospace'],
          }
        }
      }
    }
  </script>
  <style>
    /* Custom scrollbars */
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: #09090b; }
    ::-webkit-scrollbar-thumb { background: #27272a; border-radius: 9999px; }
    ::-webkit-scrollbar-thumb:hover { background: #3f3f46; }

    .nav-active {
      background-color: #ffffff !important;
      color: #000000 !important;
      font-weight: 600 !important;
      border-color: #ffffff !important;
    }
    .nav-active span.badge-num {
      background-color: #000000 !important;
      color: #ffffff !important;
    }
    .nav-active svg {
      color: #000000 !important;
    }
  </style>
</head>
<body class="bg-black text-zinc-100 min-h-screen flex flex-col font-sans">

  <!-- Mobile Top Bar (Only visible on small mobile screens md:hidden) -->
  <div class="md:hidden sticky top-0 z-40 w-full border-b border-zinc-800/80 bg-zinc-950/95 px-4 h-14 flex items-center justify-between backdrop-blur">
    <div class="flex items-center gap-2.5">
      <div class="w-7 h-7 rounded-lg bg-white text-black flex items-center justify-center font-black font-mono text-xs">W5</div>
      <div>
        <div class="text-xs font-bold text-white tracking-tight">WIFI-ID NOTES</div>
        <div class="text-[9px] font-mono text-zinc-400">ROC REGIONAL 5</div>
      </div>
    </div>
    <button onclick="openSearchModal()" class="p-2 rounded-lg border border-zinc-800 bg-zinc-900 text-zinc-400 hover:text-white">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
    </button>
  </div>

  <!-- Main Container -->
  <div class="flex-1 w-full flex min-h-screen">
    
    <!-- LEFT SIDEBAR NAVIGATION (PERMANENT & FULL-HEIGHT) -->
    <aside class="w-72 sm:w-80 shrink-0 border-r border-zinc-800/80 bg-zinc-950/70 p-5 hidden md:flex flex-col justify-between sticky top-0 h-screen overflow-y-auto">
      <div class="space-y-6">
        <!-- Brand Header & Quick Search inside Sidebar -->
        <div class="pb-5 border-b border-zinc-800/80 space-y-4">
          <div class="flex items-center gap-3">
            <div class="w-9 h-9 rounded-xl bg-white text-black flex items-center justify-center font-black font-mono text-sm tracking-tighter shadow-sm">
              W5
            </div>
            <div>
              <div class="flex items-center gap-1.5">
                <span class="text-sm font-bold text-white tracking-tight">WIFI-ID NOTES</span>
                <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-300 border border-zinc-700">v2026.11</span>
              </div>
              <p class="text-[10px] text-zinc-400 font-mono">ROC REGIONAL 5 &middot; INTERNAL SOP</p>
            </div>
          </div>

          <!-- Quick Search Button inside Sidebar -->
          <button onclick="openSearchModal()" class="w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl border border-zinc-800 bg-zinc-900/90 hover:bg-zinc-800/90 hover:border-zinc-700 text-xs text-zinc-400 hover:text-white transition-all cursor-pointer group shadow-inner">
            <div class="flex items-center gap-2.5">
              <svg class="w-3.5 h-3.5 text-zinc-400 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
              <span class="text-xs">Cari materi atau CLI...</span>
            </div>
            <kbd class="px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-[10px] font-mono text-zinc-400">Ctrl K</kbd>
          </button>
        </div>

        <div>
          <div class="px-2 mb-2.5 text-[10px] font-mono uppercase tracking-wider text-zinc-500 font-semibold">
            DAFTAR MODUL SOP
          </div>
          <nav class="space-y-1">
            <!-- Nav 1: Tracing E2E & Problem Solving (9 Hops) - DEFAULT ACTIVE -->
            <button onclick="switchTab('tab-e2e-tracing')" data-tab="tab-e2e-tracing" class="tab-nav-btn nav-active w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                <div>
                  <div class="text-xs font-medium">Tracing E2E &amp; Solved</div>
                  <div class="text-[10px] text-zinc-400">AP &rarr; GPON &rarr; Metro &rarr; BRAS</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-300 font-medium">01</span>
            </button>

            <!-- Nav 2: Topologi Jaringan -->
            <button onclick="switchTab('tab-topologi')" data-tab="tab-topologi" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 5a1 1 0 011-1h14a1 1 0 011 1v2a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM4 13a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H5a1 1 0 01-1-1v-6zM16 13a1 1 0 011-1h2a1 1 0 011 1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-6z"/></svg>
                <div>
                  <div class="text-xs font-medium">Topologi Jaringan</div>
                  <div class="text-[10px] text-zinc-400">Arsitektur WMS &amp; Diagram</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">02</span>
            </button>

            <!-- Nav 3: Tiketing WiFi.id -->
            <button onclick="switchTab('tab-ticketing')" data-tab="tab-ticketing" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
                <div>
                  <div class="text-xs font-medium">Tiketing WiFi.id</div>
                  <div class="text-[10px] text-zinc-400">Reactive AP &amp; CCAN Witel</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">03</span>
            </button>

            <!-- Nav 4: SOP Ganti AP (WLC) -->
            <button onclick="switchTab('tab-ganti-ap')" data-tab="tab-ganti-ap" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/></svg>
                <div>
                  <div class="text-xs font-medium">SOP Ganti AP (WLC)</div>
                  <div class="text-[10px] text-zinc-400">APEHBOT &amp; WISM Cisco</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">04</span>
            </button>

            <!-- Nav 5: WP-Error & Captive -->
            <button onclick="switchTab('tab-wp-error')" data-tab="tab-wp-error" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <div>
                  <div class="text-xs font-medium">WP-Error &amp; Captive</div>
                  <div class="text-[10px] text-zinc-400">Redirect &amp; Port Locating</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">05</span>
            </button>

            <!-- Nav 6: GPON & ONT Config -->
            <button onclick="switchTab('tab-gpon-ont')" data-tab="tab-gpon-ont" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"/></svg>
                <div>
                  <div class="text-xs font-medium">GPON &amp; ONT Config</div>
                  <div class="text-[10px] text-zinc-400">OLT ZTE TACACS &amp; Bukis</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">06</span>
            </button>

            <!-- Nav 7: Rekonsiliasi Mojang -->
            <button onclick="switchTab('tab-mojang')" data-tab="tab-mojang" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                <div>
                  <div class="text-xs font-medium">Rekonsiliasi Mojang</div>
                  <div class="text-[10px] text-zinc-400">Excel VLOOKUP H-1</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">07</span>
            </button>

            <!-- Nav 8: Network Tracing CLI -->
            <button onclick="switchTab('tab-tracing')" data-tab="tab-tracing" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                <div>
                  <div class="text-xs font-medium">Network Tracing CLI</div>
                  <div class="text-[10px] text-zinc-400">Trace MAC WAC &amp; Metro</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">08</span>
            </button>

            <!-- Nav 9: Quick Notes & Tips -->
            <button onclick="switchTab('tab-quick-ops')" data-tab="tab-quick-ops" class="tab-nav-btn w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-transparent text-left transition-all cursor-pointer group hover:bg-zinc-900/60 text-zinc-300 hover:text-white">
              <div class="flex items-center gap-3">
                <svg class="w-4 h-4 text-zinc-400 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                <div>
                  <div class="text-xs font-medium">Quick Notes &amp; Tips</div>
                  <div class="text-[10px] text-zinc-400">Channel RF, RSA, WiFi 6</div>
                </div>
              </div>
              <span class="badge-num text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-medium">09</span>
            </button>
          </nav>
        </div>

        <!-- Sidebar Footer Info -->
        <div class="p-3.5 rounded-xl border border-zinc-800/80 bg-zinc-900/40 text-xs space-y-1">
          <div class="flex items-center gap-2 text-zinc-300 font-medium">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            <span class="font-semibold text-white">ROC REGIONAL 5</span>
          </div>
          <p class="text-[11px] text-zinc-400 leading-relaxed">
            Dokumentasi SOP resmi operasional WiFi.id, WMS Lite, dan WMS Reguler.
          </p>
        </div>
      </div>

      <!-- Quick status indicator & external tools -->
      <div class="pt-4 border-t border-zinc-800/80 space-y-2.5">
        <a href="https://smarthub.wifi.id/" target="_blank" rel="noopener" class="flex items-center justify-between px-3 py-2 rounded-xl border border-zinc-800/80 bg-zinc-900/50 hover:bg-zinc-800 text-xs text-zinc-300 hover:text-white transition-all group">
          <span class="text-xs font-mono font-medium">Portal Smarthub</span>
          <svg class="w-3.5 h-3.5 text-zinc-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </a>
        <div class="px-1 text-[10px] font-mono text-zinc-500 flex items-center justify-between">
          <span>INTERNAL TEAM ONLY</span>
          <span>130 SCREENSHOTS</span>
        </div>
      </div>
    </aside>

  <!-- ============================================================ -->
  <!-- "EXPLANATION" DEEP TECHNICAL SLIDE-OUT DRAWER -->
  <!-- ============================================================ -->
  <!-- Explainer Backdrop -->
  <div id="explainer-backdrop" onclick="toggleExplainer()" class="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm hidden transition-opacity duration-500 ease-in-out"></div>

  <!-- Explainer Slide-out Drawer (Smooth 500ms Slow Animation) -->
  <aside id="explainer-drawer" class="fixed top-0 right-0 z-50 h-screen w-full sm:w-[600px] lg:w-[680px] bg-zinc-950 border-l border-zinc-800 shadow-2xl flex flex-col justify-between transform translate-x-full transition-transform duration-500 ease-in-out">
    
    <!-- Drawer Header -->
    <div class="p-5 border-b border-zinc-800 bg-zinc-900/70 flex items-center justify-between shrink-0">
      <div class="flex items-center gap-3">
        <div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/50 flex items-center justify-center text-emerald-400 font-black font-mono text-base shadow-sm">
          ðŸ§ 
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h3 class="text-base font-bold text-white tracking-tight">EXPLANATION</h3>
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
              Dari output live Mas Adi: perintah <code class="text-zinc-200 font-mono">show mac address-table vlan 2851</code> mencatat 99 MAC dinamis pada <code class="text-white font-mono">Po10</code>, termasuk <strong class="text-emerald-400 font-mono">c828.e58a.ee18 DYNAMIC Po10</strong>. Ini bukti tak terbantahkan bahwa paket melintasi OLT &amp; Metro tanpa dropped!
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

                <div class="p-3 rounded-xl bg-zinc-950 border border-zinc-800/80 space-y-1">
            <div class="font-mono text-emerald-400 font-bold text-[11px]">&bull; 4. Analisis Beban Utilitas Port (Show Controllers Utilization)</div>
            <p class="text-zinc-400 text-[11px]">
              Berdasarkan live controller audit dari Mas Adi: Port <code class="text-emerald-400 font-mono">Te1/0/4</code> ke WLC02 mencatat utilisasi tertinggi (<strong class="text-white font-mono">Rx 40% / Tx 39%</strong>) karena mengangkut CAPWAP 8.909 klien aktif. Port <code class="text-emerald-400 font-mono">Te1/0/7</code> ke WAG mencatat Rx 34% untuk trafik downstream gateway. Rata-rata utilisasi switch hanya <strong class="text-emerald-400 font-mono">5%</strong>, sehingga switch beroperasi sangat aman dengan headroom kapasitas 95%.
            </p>
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
      <span class="text-emerald-400 font-semibold">9 Hops E2E Technical Explanation Ready</span>
    </div>

  </aside>

    <!-- RIGHT CONTENT AREA (TABBED PANES - FULL WIDTH FLUID) -->
    <main id="content-viewport" class="flex-1 w-full min-w-0 p-6 sm:p-8 lg:p-10 xl:p-12 overflow-y-auto">
      
      <!-- TAB 1: E2E TRACING & PROBLEM SOLVING (DEFAULT ACTIVE) -->
      <div id="tab-e2e-tracing" class="tab-pane">
        __TAB_E2E_HTML__
      </div>

      <!-- TAB 2: TOPOLOGI JARINGAN -->
      <div id="tab-topologi" class="tab-pane hidden">
        __TAB1_HTML__
      </div>

      <!-- TAB 3: TIKETING WIFI.ID -->
      <div id="tab-ticketing" class="tab-pane hidden">
        __TAB2_HTML__
      </div>

      <!-- TAB 4: SOP GANTI AP (WLC) -->
      <div id="tab-ganti-ap" class="tab-pane hidden">
        __TAB3_HTML__
      </div>

      <!-- TAB 5: WP-ERROR & CAPTIVE -->
      <div id="tab-wp-error" class="tab-pane hidden">
        __TAB4_HTML__
      </div>

      <!-- TAB 6: GPON & ONT CONFIG -->
      <div id="tab-gpon-ont" class="tab-pane hidden">
        __TAB5_HTML__
      </div>

      <!-- TAB 7: REKONSILIASI MOJANG -->
      <div id="tab-mojang" class="tab-pane hidden">
        __TAB6_HTML__
      </div>

      <!-- TAB 8: NETWORK TRACING CLI -->
      <div id="tab-tracing" class="tab-pane hidden">
        __TAB7_HTML__
      </div>

      <!-- TAB 9: QUICK NOTES & TIPS -->
      <div id="tab-quick-ops" class="tab-pane hidden">
        __TAB8_HTML__
      </div>

    </main>
  </div>

  <!-- LIGHTBOX MODAL -->
  <div id="lightbox" class="fixed inset-0 z-50 bg-black/95 backdrop-blur-md hidden flex flex-col items-center justify-center p-4">
    <div class="absolute top-4 right-4 flex items-center gap-3 z-10">
      <a id="lightbox-download" href="#" target="_blank" class="px-3 py-1.5 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-xs text-zinc-300 font-mono border border-zinc-800 transition-colors flex items-center gap-1.5">
        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        Buka File
      </a>
      <button onclick="closeLightbox()" class="p-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors cursor-pointer border border-zinc-800">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
      </button>
    </div>
    <div class="max-w-6xl max-h-[85vh] flex flex-col items-center justify-center p-2">
      <img id="lightbox-img" src="" alt="Zoom Image" class="max-w-full max-h-[78vh] object-contain rounded-lg border border-zinc-800 shadow-2xl" />
      <div id="lightbox-caption" class="text-xs font-mono text-zinc-400 mt-3 text-center max-w-3xl leading-relaxed"></div>
    </div>
  </div>

  <!-- SEARCH MODAL (CTRL+K) -->
  <div id="search-modal" class="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm hidden flex items-start justify-center pt-20 p-4">
    <div class="w-full max-w-xl rounded-2xl border border-zinc-800 bg-zinc-950 p-4 shadow-2xl">
      <div class="flex items-center gap-3 border-b border-zinc-800 pb-3 px-2">
        <svg class="w-4 h-4 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
        <input id="search-input" type="text" placeholder="Cari SOP, perintah CLI, kasus WP-Error, atau datek..." class="w-full bg-transparent text-sm text-white placeholder-zinc-500 focus:outline-none" oninput="handleSearch(this.value)" />
        <button onclick="closeSearchModal()" class="text-xs text-zinc-500 hover:text-zinc-300 font-mono">ESC</button>
      </div>
      <div id="search-results" class="mt-3 max-h-80 overflow-y-auto space-y-1">
        <div class="p-3 text-xs text-zinc-500 text-center font-mono">Ketik kata kunci untuk mencari seluruh modul...</div>
      </div>
    </div>
  </div>

  <!-- ============================================================ -->
  <!-- GLOSSARY FLOATING TRIGGER & SLIDE-OUT RIGHT DRAWER -->
  <!-- ============================================================ -->
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

  <!-- Glossary Backdrop -->
  <div id="glossary-backdrop" onclick="toggleGlossary()" class="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm hidden transition-opacity duration-500 ease-in-out"></div>

  <!-- Glossary Slide-out Drawer (Slow, Smooth Animation) -->
  <aside id="glossary-drawer" class="fixed top-0 right-0 z-50 h-screen w-full sm:w-[500px] bg-zinc-950 border-l border-zinc-800 shadow-2xl flex flex-col justify-between transform translate-x-full transition-transform duration-500 ease-in-out">
    
    <!-- Drawer Header -->
    <div class="p-5 border-b border-zinc-800 bg-zinc-900/60 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-white text-black flex items-center justify-center font-black font-mono text-xs">
          GL
        </div>
        <div>
          <h3 class="text-sm font-bold text-white tracking-tight">Glosarium Istilah &amp; Singkatan Jaringan</h3>
          <p class="text-[10px] font-mono text-zinc-400">ROC Regional 5 &middot; WiFi.id Network Reference</p>
        </div>
      </div>
      <button onclick="toggleGlossary()" class="p-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white transition-colors cursor-pointer border border-zinc-700">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
      </button>
    </div>

    <!-- Search in Glossary -->
    <div class="p-4 border-b border-zinc-800/80 bg-zinc-950">
      <div class="flex items-center gap-2.5 px-3 py-2 rounded-xl bg-zinc-900 border border-zinc-800 text-xs">
        <svg class="w-4 h-4 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        <input id="glossary-search" type="text" placeholder="Cari singkatan (misal: SVI, VSI, TCONT, CoA)..." class="w-full bg-transparent text-white placeholder-zinc-500 focus:outline-none font-mono text-xs" oninput="filterGlossary(this.value)" />
      </div>
    </div>

    <!-- Glossary Items (Scrollable) -->
    <div id="glossary-items-container" class="flex-1 overflow-y-auto p-5 space-y-6">
      
      <!-- Category 1: Akses GPON & Optik Fisik -->
      <div class="glossary-category space-y-3">
        <div class="text-[10px] font-mono text-emerald-400 uppercase tracking-wider font-semibold border-b border-zinc-800/80 pb-1 flex items-center justify-between">
          <span>01. AKSES GPON &amp; FISIK OPTIK</span>
          <span class="text-[9px] text-zinc-500 font-mono">HOP 01 - 03</span>
        </div>
        <div class="space-y-2.5">
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">AP (Access Point)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">802.11 / RF</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Perangkat pemancar sinyal radio nirkabel IEEE 802.11 (WiFi) yang menghubungkan perangkat klien pengguna ke jaringan kabel LAN.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">ONT (Optical Network Terminal)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">CPE Modem</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Modem serat optik di sisi pelanggan yang mengubah sinyal cahaya GPON dari OLT menjadi port elektrik ethernet LAN RJ45.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">OLT (Optical Line Terminal)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Central GPON</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Perangkat sentral penyedia layanan di STO yang memancarkan laser optik downstream 1490nm dan menerima upstream 1310nm.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">TCONT (Transmission Container)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Upstream DBA</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Saluran pengiriman data upstream pada GPON yang diatur oleh profil DBA (Dynamic Bandwidth Allocation) untuk menjamin QoS bandwidth.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">GEMPORT (GPON Encapsulation Port)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Virtual Tunnel</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Pipa virtual di dalam TCONT untuk membungkus frame ethernet data (misal: stream VLAN 195 WMS atau VLAN 100 VOIP).</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">OMCI (ONU Mgmt &amp; Control Interface)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Management</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Kanal komunikasi protokol standar OLT untuk mengonfigurasi hardware ONT dari jarak jauh, termasuk mode tagging VLAN port LAN.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">Dying Gasp</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-amber-950/80 text-amber-300 border border-amber-800">Alarm Daya</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Pesan darurat yang dikirim ONT ke OLT saat kehilangan sumber daya listrik PLN sesaat sebelum mati total. Membedakan gangguan mati lampu dengan kabel putus.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">LOS (Loss of Signal)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-rose-950/80 text-rose-300 border border-rose-800">Alarm Optik</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Hilangnya transmisi cahaya laser optik pada ONT akibat kabel fiber dropcore putus, konektor SC lepas, atau redaman drop di bawah batas sensitivitas receiver.</p>
          </div>
        </div>
      </div>

      <!-- Category 2: Switching & Metro MPLS -->
      <div class="glossary-category space-y-3">
        <div class="text-[10px] font-mono text-emerald-400 uppercase tracking-wider font-semibold border-b border-zinc-800/80 pb-1 flex items-center justify-between">
          <span>02. SWITCHING, VLAN &amp; METRO MPLS</span>
          <span class="text-[9px] text-zinc-500 font-mono">HOP 04 - 05</span>
        </div>
        <div class="space-y-2.5">
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">VLAN &amp; 802.1Q (dot1q)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Layer 2</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Virtual LAN untuk membagi switch fisik menjadi beberapa broadcast domain logis. 802.1Q adalah standar penyisipan tag VLAN 4-byte pada frame ethernet.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">VSI (Virtual Switch Instance)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">MPLS VPLS</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Entitas switch virtual di dalam router/switch Huawei MPLS yang menghubungkan banyak link L2 access ke dalam satu broadcast domain L2VPN via Pseudowire.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">LDP (Label Distribution Protocol)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">MPLS Signaling</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Protokol pensinyalan pada jaringan MPLS untuk menegosiasikan dan mendistribusikan label antar router dalam membangun terowongan Pseudowire L2VPN.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">mac-withdraw</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Convergence</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Mekanisme VSI untuk mengosongkan tabel MAC pada peer router secara instan saat port berubah status down agar jalur cadangan segera aktif tanpa loop/blackhole.</p>
          </div>
        </div>
      </div>

      <!-- Category 3: Routing L3 & Kontroler Wireless -->
      <div class="glossary-category space-y-3">
        <div class="text-[10px] font-mono text-emerald-400 uppercase tracking-wider font-semibold border-b border-zinc-800/80 pb-1 flex items-center justify-between">
          <span>03. ROUTING L3 &amp; WIRELESS CORE</span>
          <span class="text-[9px] text-zinc-500 font-mono">HOP 06 - 07</span>
        </div>
        <div class="space-y-2.5">
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">SVI (Switched Virtual Interface)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Layer 3 Switch</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Interface logika IP Layer 3 pada switch multilayer (seperti <code class="text-white font-mono">Vlan2851</code>) yang bertindak sebagai default gateway untuk subnet perangkat host di VLAN tersebut.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">Port-Channel / LACP (802.3ad)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Link Aggregation</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Penggabungan beberapa kabel fisik 10GE menjadi satu link logika (misal <code class="text-white font-mono">Po10</code> = 20 Gbps) guna meningkatkan kapasitas bandwidth dan redundansi.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">Rapid-PVST</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">STP Protocol</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Rapid Per-VLAN Spanning Tree. Protokol Cisco pencegah loop bridging dengan konvergensi kilat (&lt;1 detik) yang berjalan terpisah di setiap instance VLAN.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">WAC / WLC (Wireless LAN Controller)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">WLAN Core</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Perangkat sentral kontroler radio nirkabel Cisco untuk manajemen terpusat konfigurasi SSID, otentikasi RF, firmware AP, dan pemetaan dynamic interface.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">CAPWAP</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Tunnel Protocol</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Control and Provisioning of Wireless Access Points. Protokol tunneling antara AP dan WLC menggunakan port UDP 5246 (Control) dan UDP 5247 (Data).</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">LLDP (Link Layer Discovery)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">IEEE 802.1AB</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Protokol Layer 2 netral-vendor untuk menemukan perangkat tetangga yang terhubung secara fisik pada port switch/router (misal mendeteksi WAG pada port Te1/0/7).</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">SFP-10GBase-LR</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Optik Transceiver</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Modul optik 10 Gigabit Ethernet Long Range (panjang gelombang laser 1310nm Single-Mode Fiber) dengan jangkauan transmisi hingga 10 kilometer.</p>
          </div>
        </div>
      </div>

      <!-- Category 4: Gateway & Subscriber AAA -->
      <div class="glossary-category space-y-3">
        <div class="text-[10px] font-mono text-emerald-400 uppercase tracking-wider font-semibold border-b border-zinc-800/80 pb-1 flex items-center justify-between">
          <span>04. GATEWAY &amp; SUBSCRIBER AAA</span>
          <span class="text-[9px] text-zinc-500 font-mono">HOP 08 - 09</span>
        </div>
        <div class="space-y-2.5">
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">WAG (Wireless Access Gateway)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">ISG / BNG</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Gateway penegak sesi subscriber klien. Mengatur pembatasan bandwidth (shaping), kuota, dan interkoneksi ke server otentikasi RADIUS AAA.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">PE &amp; HSI (Core Internet Gateway)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Core Egress</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Provider Edge (PE) Router yang menyediakan layanan High-Speed Internet (HSI), CGNAT IP pooling, dan eBGP routing ke backbone internet global.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">CoA (Change of Authorization)</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">RFC 3576 / UDP 3799</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Pesan dari server RADIUS untuk mengubah profil atau memutuskan sesi pelanggan yang sedang aktif tanpa harus menunggu klien re-koneksi ulang.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">WPGEN &amp; Captive Portal</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Landing Page</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Sistem portal WiFi.id (<code class="text-white font-mono">welcome2.wifi.id</code>) untuk validasi kredensial login voucher, akun WMS, atau seamless SIM authentication.</p>
          </div>
          <div class="glossary-item p-3 rounded-xl bg-zinc-900/60 border border-zinc-800/80">
            <div class="flex items-center justify-between">
              <span class="font-mono text-xs font-bold text-white">BRAS / BNG &amp; CGNAT</span>
              <span class="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">Core Gateway</span>
            </div>
            <p class="text-[11px] text-zinc-400 mt-1 leading-relaxed">Broadband Remote Access Server yang menghubungkan jaringan pelanggan ke Internet global dengan routing BGP dan Carrier-Grade NAT (CGNAT).</p>
          </div>
        </div>
      </div>

    </div>

    <!-- Drawer Footer -->
    <div class="p-4 border-t border-zinc-800 bg-zinc-900/50 flex items-center justify-between text-[11px] font-mono text-zinc-400">
      <span>Tekan <kbd class="px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-zinc-300">ESC</kbd> untuk menutup</span>
      <span class="text-emerald-400 font-semibold">25+ Istilah Jaringan</span>
    </div>

  </aside>

  <!-- JAVASCRIPT CONTROLLERS -->
  <script>
    // Tab Switching Controller (Zero Infinite Scroll)
    function switchTab(tabId) {
      // 1. Hide all tab panes
      document.querySelectorAll('.tab-pane').forEach(el => {
        el.classList.add('hidden');
      });

      // 2. Show target tab pane
      const targetPane = document.getElementById(tabId);
      if (targetPane) {
        targetPane.classList.remove('hidden');
      }

      // 3. Reset scroll position to top
      const viewport = document.getElementById('content-viewport');
      if (viewport) {
        viewport.scrollTop = 0;
      }
      window.scrollTo(0, 0);

      // 4. Update sidebar navigation button active state
      document.querySelectorAll('.tab-nav-btn').forEach(btn => {
        if (btn.dataset.tab === tabId) {
          btn.classList.add('nav-active');
          btn.classList.remove('text-zinc-300', 'hover:bg-zinc-900/60');
        } else {
          btn.classList.remove('nav-active');
          btn.classList.add('text-zinc-300', 'hover:bg-zinc-900/60');
        }
      });
    }

    // Glossary Controller (Slow smooth slide-out animation)
        // Explainer "Explanation" Controller
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

    function toggleGlossary() {
      const expDrawer = document.getElementById('explainer-drawer');
        if (expDrawer && !expDrawer.classList.contains('translate-x-full')) {
          toggleExplainer();
        }
        const drawer = document.getElementById('glossary-drawer');
      const backdrop = document.getElementById('glossary-backdrop');
      if (!drawer || !backdrop) return;
      if (drawer.classList.contains('translate-x-full')) {
        drawer.classList.remove('translate-x-full');
        backdrop.classList.remove('hidden');
        setTimeout(() => document.getElementById('glossary-search')?.focus(), 250);
      } else {
        drawer.classList.add('translate-x-full');
        backdrop.classList.add('hidden');
      }
    }

    function filterGlossary(val) {
      const q = val.toLowerCase().trim();
      const items = document.querySelectorAll('.glossary-item');
      items.forEach(el => {
        const text = el.innerText.toLowerCase();
        if (!q || text.includes(q)) {
          el.classList.remove('hidden');
        } else {
          el.classList.add('hidden');
        }
      });
    }

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

    // Lightbox Controller
    function openLightbox(src, caption) {
      const modal = document.getElementById('lightbox');
      const img = document.getElementById('lightbox-img');
      const cap = document.getElementById('lightbox-caption');
      const dl = document.getElementById('lightbox-download');
      
      img.src = src;
      cap.innerHTML = caption || '';
      dl.href = src;
      modal.classList.remove('hidden');
    }

    function closeLightbox() {
      document.getElementById('lightbox').classList.add('hidden');
    }

    // 1-Click Code Copy Controller
    function copyCode(codeId, btn) {
      const el = document.getElementById(codeId);
      if (!el) return;
      const text = el.innerText;
      navigator.clipboard.writeText(text).then(() => {
        const origHtml = btn.innerHTML;
        btn.innerHTML = '<svg class="w-3.5 h-3.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg><span class="text-white">Tersalin!</span>';
        btn.classList.add('bg-zinc-700');
        setTimeout(() => {
          btn.innerHTML = origHtml;
          btn.classList.remove('bg-zinc-700');
        }, 2000);
      });
    }

    // Search Database & Modal
    const searchIndex = [
      { tab: 'tab-topologi', title: 'Topologi Jaringan WiFi.id', snippet: 'Diagram end-to-end WMS Lite vs Reguler, VLAN 4090, CAPWAP UDP 5246/5247' },
      { tab: 'tab-topologi', title: 'Portal Operasional', snippet: 'Smarthub, WPGEN, Insera, ACS I-Booster, APEHBOT Telegram' },
      { tab: 'tab-ticketing', title: 'Reactive AP vs Service', snippet: 'Klasifikasi AP Mati (LOSS) vs AP Logic, No Nossa untuk Insera' },
      { tab: 'tab-ticketing', title: 'Order Gangguan CCAN', snippet: 'Format eskalasi tiket gangguan ke tim CCAN Witel via Telegram' },
      { tab: 'tab-ganti-ap', title: 'SOP Ganti AP WLC Cisco', snippet: 'Penggantian unit AP lama dengan AP baru di WISM yang sama' },
      { tab: 'tab-ganti-ap', title: 'Tutorial Login WISM Mozilla', snippet: 'Bypass frameset Mozilla Firefox, IP NAT WISM 172.18.66.xx' },
      { tab: 'tab-ganti-ap', title: 'Ganti AP Beda WISM', snippet: 'Migrasi AP antar controller WLC WAC yang berbeda' },
      { tab: 'tab-wp-error', title: 'Studi Kasus 1, 2, 3 WP-Error', snippet: 'ACS Security Type Open System, Location-ID mismatch, URL parameter' },
      { tab: 'tab-wp-error', title: 'Port Locating Silang Merah (X)', snippet: 'Troubleshooting DHCP Port Locating Option 82 pada ONT GPON' },
      { tab: 'tab-gpon-ont', title: 'Config WMS TACACS OLT ZTE', snippet: 'Skrip CLI OLT ZTE VLAN 4090 WMS, VLAN 500 VOIP, TCONT, GEMPORT' },
      { tab: 'tab-gpon-ont', title: 'Buka Isolir (Bukis)', snippet: 'Prosedur pembukaan isolir pelanggan via nomor SID di WPGEN' },
      { tab: 'tab-gpon-ont', title: 'Cek & Ganti Password SSID', snippet: 'Ganti kata sandi wifi WMS melalui portal WPGEN' },
      { tab: 'tab-gpon-ont', title: 'Cek Klien Terkoneksi & Traffic', snippet: 'Monitoring client 2.4 GHz dan 5 GHz serta filter traffic tertinggi' },
      { tab: 'tab-mojang', title: 'Rekonsiliasi Harian Mojang', snippet: 'Formula Excel VLOOKUP Sugar H-1 vs Prabac, upload Web Mojang' },
      { tab: 'tab-tracing', title: 'Mencari Datek AP APEHBOT', snippet: 'Bot telegram /apsn mencari AP-MAC, Serial Number, dan IP WAC' },
      { tab: 'tab-tracing', title: 'Tracing MAC Address Cisco WAC', snippet: 'show mac address-table address, show ip arp, show interfaces te4/1' },
      { tab: 'tab-tracing', title: 'Trace Metro & VSI WAC_2888', snippet: 'display mac-address dynamic vsi WAC_2888, downlink port Metro' },
      { tab: 'tab-tracing', title: 'Create WLAN SSID & AP Groups', snippet: 'Konfigurasi profile WLAN SSID dan mapping ke AP Group di Cisco WLC' },
      { tab: 'tab-e2e-tracing', title: 'Tracing E2E 9 Hops WiFi.id', snippet: 'Alur transmisi lengkap AP, ONT, GPON, Metro 1 & 2, WAC, WAG, AAA WPGEN, PE/BRAS' },
      { tab: 'tab-e2e-tracing', title: 'Problem Solving 9 Hops WiFi.id', snippet: 'Root cause isolation matriks, diagnosa CLI, parameter normal vs error' },
      { tab: 'tab-e2e-tracing', title: 'Hop 01 AP & Hop 02 ONT Tracing', snippet: 'Verifikasi PoE 802.3at, redaman optik -18 to -24 dBm, GigE LAN' },
      { tab: 'tab-e2e-tracing', title: 'Hop 03 GPON & Hop 04-05 Metro Tracing', snippet: 'VLAN 4090, Option 82, VSI WAC_2888 dynamic MAC MPLS L2VPN' },
      { tab: 'tab-e2e-tracing', title: 'Hop 06 WAC & Hop 07 WAG & Hop 08 AAA', snippet: 'CAPWAP 5246, CoA 3799, welcome2.wifi.id captive portal redirect' },
      { tab: 'tab-e2e-tracing', title: 'Hop 09 PE/BRAS Internet Gateway', snippet: 'IP DHCP pool allocation, NAT overload, gateway BGP default route' },
      { tab: 'tab-quick-ops', title: 'Ganti Channel Frekuensi RF', snippet: 'Optimasi interferensi 20/40 MHz di 2.4 GHz dan 80 MHz di 5 GHz ACS' },
      { tab: 'tab-quick-ops', title: 'AP Flapping / Intermitten', snippet: 'Pengecekan redaman optik ONT dan supply power PoE Switch' },
      { tab: 'tab-quick-ops', title: 'AP Baru (Gress)', snippet: 'Penyambungan dan registrasi unit AP baru pertama kali' },
      { tab: 'tab-quick-ops', title: 'Otomasi RSA Key & Resend Email', snippet: 'Generate RSA key server dan kirim ulang email kredensial pelanggan' }
    ];

    function openSearchModal() {
      document.getElementById('search-modal').classList.remove('hidden');
      setTimeout(() => document.getElementById('search-input').focus(), 50);
    }

    function closeSearchModal() {
      document.getElementById('search-modal').classList.add('hidden');
    }

    function handleSearch(val) {
      const q = val.toLowerCase().trim();
      const res = document.getElementById('search-results');
      if (!q) {
        res.innerHTML = '<div class="p-3 text-xs text-zinc-500 text-center font-mono">Ketik kata kunci untuk mencari seluruh modul...</div>';
        return;
      }
      const matches = searchIndex.filter(item => 
        item.title.toLowerCase().includes(q) || item.snippet.toLowerCase().includes(q)
      );
      if (matches.length === 0) {
        res.innerHTML = '<div class="p-4 text-xs text-zinc-500 text-center font-mono">Tidak ditemukan materi dengan kata kunci tersebut.</div>';
        return;
      }
      res.innerHTML = matches.map(m => `
        <button onclick="switchTab('${m.tab}'); closeSearchModal();" class="w-full text-left p-3 rounded-xl hover:bg-zinc-900 border border-transparent hover:border-zinc-800 transition-all flex items-start justify-between group">
          <div>
            <div class="text-xs font-semibold text-white group-hover:underline underline-offset-2">${m.title}</div>
            <div class="text-[11px] text-zinc-400 mt-0.5">${m.snippet}</div>
          </div>
          <span class="text-[10px] font-mono px-2 py-0.5 rounded bg-zinc-800 text-zinc-400 shrink-0 ml-2">Buka Tab</span>
        </button>
      `).join('');
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', e => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        openSearchModal();
      }
      if (e.key === 'Escape') {
        closeLightbox();
        closeSearchModal();
        const expDrawer = document.getElementById('explainer-drawer');
        if (expDrawer && !expDrawer.classList.contains('translate-x-full')) {
          toggleExplainer();
        }
        const drawer = document.getElementById('glossary-drawer');
        if (drawer && !drawer.classList.contains('translate-x-full')) {
          toggleGlossary();
        }
      }
    });

    // Close lightbox on click backdrop
    document.getElementById('lightbox').addEventListener('click', e => {
      if (e.target.id === 'lightbox' || e.target.tagName === 'DIV') {
        closeLightbox();
      }
    });
  </script>
</body>
</html>
'@

$masterHtml = $fullTpl.Replace("__TAB1_HTML__", $tab1Html).Replace("__TAB2_HTML__", $tab2Html).Replace("__TAB3_HTML__", $tab3Html).Replace("__TAB4_HTML__", $tab4Html).Replace("__TAB5_HTML__", $tab5Html).Replace("__TAB6_HTML__", $tab6Html).Replace("__TAB7_HTML__", $tab7Html).Replace("__TAB_E2E_HTML__", $tabE2EHtml).Replace("__TAB8_HTML__", $tab8Html)

$outputPath = Join-Path $rootDir "index.html"
[System.IO.File]::WriteAllText($outputPath, $masterHtml, [System.Text.Encoding]::UTF8)
Write-Output "SUCCESS! New tabbed index.html generated cleanly at $outputPath"
