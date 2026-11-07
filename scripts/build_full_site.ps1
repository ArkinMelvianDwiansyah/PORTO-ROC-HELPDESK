# Complete HTML Generator for WIFI-ID Documentation Web App
$blocks = Get-Content -Raw -Encoding UTF8 "all_blocks_complete.json" | ConvertFrom-Json
$imgMap = Get-Content -Raw -Encoding UTF8 "image_map.json" | ConvertFrom-Json

$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

function Get-RichHtml($prop) {
    if (-not $prop) { return "" }
    $out = ""
    foreach ($chunk in $prop) {
        $text = [System.Net.WebUtility]::HtmlEncode($chunk[0])
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
            $htmlList.Add("<div class='flex items-start gap-2.5 my-1.5'><input type='checkbox' $checked class='mt-1 rounded border-zinc-700 bg-zinc-900 text-white focus:ring-0 cursor-pointer'><span class='text-sm $textClass'>$rawText</span></div>")
        }
        "callout" {
            $icon = if ($b.format -and $b.format.page_icon) { $b.format.page_icon } else { "💡" }
            $htmlList.Add("<div class='my-4 p-4 rounded-lg bg-zinc-900/80 border border-zinc-800 text-sm text-zinc-300 flex items-start gap-3 shadow-inner'><div class='text-lg shrink-0 mt-0.5'>$icon</div><div class='flex-1 leading-relaxed'>$rawText</div></div>")
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
            $encodedCode = [System.Net.WebUtility]::HtmlEncode($cleanCode)
            $codeId = "code_" + ([System.Guid]::NewGuid().ToString("N"))
            $htmlList.Add(@"
<div class="my-4 rounded-lg border border-zinc-800 bg-zinc-950 overflow-hidden shadow-sm">
  <div class="flex items-center justify-between px-3.5 py-2 bg-zinc-900/90 border-b border-zinc-800/80 text-xs text-zinc-400">
    <div class="flex items-center gap-2">
      <div class="flex gap-1.5">
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
        <span class="w-2.5 h-2.5 rounded-full bg-zinc-800 border border-zinc-700"></span>
      </div>
      <span class="font-mono text-zinc-400 font-medium lowercase ml-1">$lang</span>
    </div>
    <button onclick="copyCode('$codeId', this)" class="flex items-center gap-1.5 px-2.5 py-1 rounded bg-zinc-800/50 hover:bg-zinc-800 text-zinc-400 hover:text-white transition-all text-[11px] font-mono cursor-pointer border border-zinc-700/60 hover:border-zinc-600">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
      <span>Salin</span>
    </button>
  </div>
  <pre class="p-4 text-xs font-mono text-zinc-200 overflow-x-auto leading-relaxed"><code id="$codeId">$encodedCode</code></pre>
</div>
"@)
        }
        "image" {
            $localImg = $imgMap.$id
            $caption = if ($b.properties.caption) { Get-RichHtml $b.properties.caption } else { "" }
            if ($localImg) {
                $capHtml = if ($caption) { "<div class='text-xs text-zinc-400 mt-2 px-1 flex items-center gap-1.5'><svg class='w-3.5 h-3.5 text-zinc-500 shrink-0' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg><span>$caption</span></div>" } else { "" }
                $htmlList.Add(@"
<div class="my-4 group">
  <div class="relative overflow-hidden rounded-lg border border-zinc-800 bg-zinc-950 p-2 transition-all hover:border-zinc-600 shadow-sm">
    <img src="$localImg" alt="Dokumentasi WIFI.ID" loading="lazy" class="w-full max-h-[520px] object-contain rounded cursor-zoom-in transition-transform duration-200 group-hover:scale-[1.003]" onclick="openLightbox('$localImg', '$([System.Net.WebUtility]::HtmlEncode($caption))')" />
    <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-900/90 text-zinc-300 text-xs px-2.5 py-1 rounded border border-zinc-700 pointer-events-none flex items-center gap-1.5 backdrop-blur-sm shadow-lg">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"></path></svg>
      Perbesar
    </div>
  </div>
  $capHtml
</div>
"@)
            }
        }
        "bookmark" {
            $link = if ($b.properties.link) { $b.properties.link[0][0] } else { "#" }
            $htmlList.Add(@"
<div class="my-3">
  <a href="$link" target="_blank" rel="noopener" class="flex items-center justify-between p-3.5 rounded-lg border border-zinc-800 bg-zinc-900/60 hover:bg-zinc-800/80 hover:border-zinc-700 transition-all text-sm group">
    <div class="flex items-center gap-2.5 truncate">
      <svg class="w-4 h-4 text-zinc-400 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
      <span class="text-zinc-200 font-medium truncate">$rawText</span>
    </div>
    <span class="text-xs text-zinc-500 font-mono ml-4 shrink-0">$link</span>
  </a>
</div>
"@)
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

# Helper to render an entire subpage by its ID into an HTML card section
function Render-Subpage-Section($pageId, $sectionAnchor, $sectionBadge, $sectionDesc = "") {
    $p = $blockMap[$pageId]
    if (-not $p) { return "" }
    
    $pTitle = if ($p.properties -and $p.properties.title) {
        ($p.properties.title | ForEach-Object { $_[0] }) -join ""
    } else { "Subpage" }
    
    $lines = [System.Collections.Generic.List[string]]::new()
    $vSet = [System.Collections.Generic.HashSet[string]]::new()
    
    if ($p.content) {
        foreach ($cid in $p.content) {
            Render-Block-Tree $cid $lines $vSet
        }
    }
    
    $innerContent = $lines -join "`n"
    $descHtml = if ($sectionDesc) { "<p class='text-zinc-400 text-sm mt-1 mb-5 leading-relaxed'>$sectionDesc</p>" } else { "" }
    
    return @"
    <section id="$sectionAnchor" class="scroll-mt-20 pt-8 pb-12 border-b border-zinc-800/80">
      <div class="flex items-center justify-between gap-4 mb-2">
        <div class="flex items-center gap-2.5">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-800 text-zinc-300 border border-zinc-700/80 font-medium">$sectionBadge</span>
          <span class="text-xs font-mono text-zinc-500">ID: $($p.id.Substring(0, 8))...</span>
        </div>
        <a href="#$sectionAnchor" class="text-zinc-600 hover:text-zinc-300 text-sm font-mono transition-colors">#link</a>
      </div>
      <h2 class="text-2xl font-bold text-white tracking-tight flex items-center gap-3">
        $pTitle
      </h2>
      $descHtml
      <div class="mt-6 space-y-2">
        $innerContent
      </div>
    </section>
"@
}

# Now let's render the special sections from root page and all subpages!
Write-Output "Rendering all sections..."

$allSectionsHtml = [System.Collections.Generic.List[string]]::new()

# 1. TIKETING WIFI-ID
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-80f2-9d4e-e97691869aba" "sec-ticketing" "TICKETING" "Alur monitoring, klasifikasi tiket gangguan (Reactive AP vs Reactive Service), dan prosedur order tiket ke CCAN Witel."))

# 2. GANTI AP
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-80f9-bdd1-f004dbd11ed2" "sec-ganti-ap" "SOP GANTI AP" "Panduan penggantian unit Access Point lama dengan unit baru pada WISM yang sama beserta sinkronisasi parameter APOSE dan WPGEN."))

# 3. TUTORIAL LOGIN WISM
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-81ee-93aa-cacbb6ef33a2" "sec-login-wism" "LOGIN WLC" "Langkah resolusi IP NAT via Telegram Bot APEHBOT dan panduan browser Mozilla Firefox untuk akses controller WISM Cisco."))

# 4. GANTI AP - BEDA WISM
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-80b6-a7ea-f2a88be9038d" "sec-ganti-ap-beda" "WISM MIGRATION" "Prosedur penyesuaian jika penggantian Access Point melibatkan controller WISM / WAC yang berbeda."))

# 5. WP-ERROR / URL ERROR
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-8028-ad88-e48661065286" "sec-wp-error" "CAPTIVE PORTAL" "Penanganan masalah redirect landing page login welcome2.wifi.id (Studi Kasus 1: ACS Security Type, Kasus 2: Mismatch Location-ID/SSID, Kasus 3: URL Parameter)."))

# 6. WP ERROR PORT LOCATING (X)
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-80ff-93ad-ed04e4254f4e" "sec-port-locating" "ONT CONFIG" "Troubleshooting status port locating silang merah (X) akibat DHCP Port Locating pada ONT pelanggan yang belum aktif."))

# 7. CONFIG WMS TACACS ONT GANTI ONT BARU
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-800f-9785-dd6f0114c2a2" "sec-tacacs-ont" "CLI TACACS" "Skrip konfigurasi OLT ZTE GPON untuk layanan WMS Lite (VLAN 4090 WMS, VLAN 500/100 VOIP, TCONT, GEMPORT, DHCP relay, dan WPGEN sync)."))

# 8. BUKA ISOLIR
$allSectionsHtml.Add((Render-Subpage-Section "386bc60a-349d-804c-bffe-ff22dfab5499" "sec-bukis" "BILLING / ISOLIR" "Prosedur aktivasi kembali layanan pelanggan yang terisolir via nomor SID / Internet di portal WPGEN."))

# 9. CEK & GANTI PASSWORD
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-805d-a0a5-ccaaa5369cc8" "sec-password" "CREDENTIALS" "Pengecekan dan perubahan kata sandi SSID layanan WMS melalui portal WPGEN."))

# 10. CEK PENGGUNAAN DAN PERANGKAT TERKONEKSI
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-809a-b3b1-edad2b75ee0e" "sec-client-usage" "MONITORING" "Langkah monitoring perangkat aktif terhubung pada frekuensi 2.4 GHz dan 5 GHz serta filter traffic tertinggi untuk laporan CCAN."))

# 11. CEK SN ONT
$allSectionsHtml.Add((Render-Subpage-Section "340bc60a-349d-80f3-abe1-fbea9a8c2de8" "sec-sn-ont" "SMARTHUB" "Pencarian Serial Number perangkat ONT induk berdasarkan Serial Number Access Point (AP-SN) di Smarthub."))

# 12. MOJANG
$allSectionsHtml.Add((Render-Subpage-Section "386bc60a-349d-80b9-9a98-dad9aa97c58e" "sec-mojang" "REKONSILIASI" "Panduan pengolahan data rekap harian AP gangguan menggunakan Microsoft Excel (VLOOKUP Sugar Report H-1, Inventory Prabac, dan upload Web Mojang)."))

# 13. QUICK OPS / OTHER SUBPAGES
$quickPages = @(
    @{ Id = "340bc60a-349d-8036-b123-dab53afd82c8"; Anchor = "sec-ganti-channel"; Badge = "RADIO FREQ" }
    @{ Id = "340bc60a-349d-80ba-8ab6-ecc230b933e8"; Anchor = "sec-intermitten"; Badge = "QUALITY" }
    @{ Id = "340bc60a-349d-80ac-93ba-f7bb8263f82a"; Anchor = "sec-ap-gress"; Badge = "HARDWARE" }
    @{ Id = "340bc60a-349d-8026-9aa7-f457eeed4ab0"; Anchor = "sec-create-rsa"; Badge = "SECURITY" }
    @{ Id = "340bc60a-349d-8067-99f0-c5e085b0594b"; Anchor = "sec-rsa-auto"; Badge = "AUTOMATION" }
    @{ Id = "340bc60a-349d-8011-bfc3-fa722365c73e"; Anchor = "sec-resend-email"; Badge = "NOTIFICATION" }
    @{ Id = "340bc60a-349d-8059-9de2-ee3a6bc16cae"; Anchor = "sec-wifiv6"; Badge = "NEXT-GEN" }
    @{ Id = "340bc60a-349d-8078-b957-db39a075300c"; Anchor = "sec-open-tiket"; Badge = "DISPATCH" }
)

foreach ($qp in $quickPages) {
    $secContent = Render-Subpage-Section $qp.Id $qp.Anchor $qp.Badge
    if ($secContent) {
        $allSectionsHtml.Add($secContent)
    }
}

# 14. Render root page specific blocks (Topologi, Tracing datek, WAC CLI commands)
# Let's extract the root page content from block 340bc60a-349d-8029-8c50-e2ff294097b4
$rootBlock = $blockMap["340bc60a-349d-8029-8c50-e2ff294097b4"]
$rootLines = [System.Collections.Generic.List[string]]::new()
$rootVSet = [System.Collections.Generic.HashSet[string]]::new()

if ($rootBlock.content) {
    foreach ($rcid in $rootBlock.content) {
        $rb = $blockMap[$rcid]
        # Only render if it's NOT a subpage (subpages are already rendered separately!)
        if ($rb -and $rb.type -ne "page") {
            Render-Block-Tree $rcid $rootLines $rootVSet
        }
    }
}

$rootExtraHtml = $rootLines -join "`n"

$combinedSectionsHtml = $allSectionsHtml -join "`n`n"

# Now build the full HTML file with Tailwind CSS and modern monochrome styling
$fullHtml = @"
<!DOCTYPE html>
<html lang="id" class="scroll-smooth bg-black text-zinc-100 antialiased selection:bg-zinc-800 selection:text-white">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WIFI-ID NOTES &middot; ROC TELKOM</title>
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
          },
          colors: {
            brand: {
              black: '#000000',
              dark: '#09090b',
              card: '#121214',
              surface: '#18181b',
              border: '#27272a',
              muted: '#71717a',
              light: '#fafafa'
            }
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
    
    .nav-link.active {
      background-color: #27272a;
      color: #ffffff;
      border-left: 2px solid #ffffff;
    }
    
    @media print {
      aside, #top-bar, #search-modal, #lightbox-modal { display: none !important; }
      main { margin-left: 0 !important; width: 100% !important; }
      body { background: white !important; color: black !important; }
    }
  </style>
</head>
<body class="min-h-screen bg-black font-sans text-zinc-300 antialiased flex flex-col">

  <!-- TOP BAR -->
  <header id="top-bar" class="sticky top-0 z-40 w-full border-b border-zinc-800/90 bg-black/80 backdrop-blur-md">
    <div class="flex h-14 items-center justify-between px-4 sm:px-6">
      <div class="flex items-center gap-3">
        <button id="mobile-toggle-btn" onclick="toggleSidebar()" class="lg:hidden p-2 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 border border-zinc-800">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
        </button>
        <div class="flex items-center gap-2.5">
          <div class="w-7 h-7 rounded bg-white text-black font-mono font-black flex items-center justify-center text-xs tracking-tighter">W5</div>
          <div>
            <div class="text-sm font-bold text-white tracking-tight flex items-center gap-2">
              WIFI-ID NOTES
              <span class="text-[10px] font-mono px-1.5 py-0.2 rounded bg-zinc-800 text-zinc-400 border border-zinc-700">v2026.11</span>
            </div>
            <div class="text-[10px] font-mono text-zinc-500 leading-none">ROC REGIONAL 5 &middot; INTERNAL SOP</div>
          </div>
        </div>
      </div>

      <div class="flex items-center gap-3">
        <!-- Search Trigger -->
        <button onclick="openSearchModal()" class="flex items-center gap-3 px-3 py-1.5 rounded-lg border border-zinc-800 bg-zinc-900/80 hover:bg-zinc-800 hover:border-zinc-700 text-xs text-zinc-400 transition-all cursor-pointer">
          <svg class="w-3.5 h-3.5 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
          <span class="hidden sm:inline">Cari materi atau konfigurasi...</span>
          <span class="sm:hidden">Cari...</span>
          <kbd class="px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700 text-[10px] font-mono text-zinc-400">Ctrl K</kbd>
        </button>

        <a href="https://smarthub.wifi.id/" target="_blank" rel="noopener" class="hidden md:flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-zinc-800 hover:border-zinc-700 bg-zinc-900 text-xs font-mono text-zinc-300 hover:text-white transition-colors">
          <span>Smarthub</span>
          <svg class="w-3 h-3 text-zinc-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
        </a>

        <div class="h-4 w-px bg-zinc-800 hidden md:block"></div>

        <button onclick="window.print()" class="p-1.5 rounded-lg border border-zinc-800 hover:border-zinc-700 bg-zinc-900 text-zinc-400 hover:text-white transition-colors" title="Cetak / Export PDF">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
        </button>
      </div>
    </div>
  </header>

  <!-- BODY LAYOUT: SIDEBAR ON LEFT, CONTENT ON RIGHT -->
  <div class="flex-1 flex max-w-[1720px] w-full mx-auto">
    
    <!-- LEFT SIDEBAR -->
    <aside id="sidebar" class="fixed inset-y-0 left-0 z-30 w-72 lg:w-80 bg-zinc-950 border-r border-zinc-800/80 transform -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out lg:static lg:h-[calc(100vh-3.5rem)] lg:sticky lg:top-14 overflow-y-auto flex flex-col p-4">
      
      <!-- Team Warning Badge -->
      <div class="mb-4 p-3 rounded-lg border border-zinc-800 bg-zinc-900/60 text-xs text-zinc-400 flex items-start gap-2.5">
        <svg class="w-4 h-4 text-zinc-300 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
        <div>
          <strong class="text-zinc-200 block mb-0.5">INTERNAL TEAM ONLY</strong>
          Jangan share keluar team ya guys! Dokumentasi operasional WiFi.id.
        </div>
      </div>

      <!-- Quick Filter Chips -->
      <div class="flex flex-wrap gap-1 mb-4 text-[11px] font-mono">
        <button onclick="filterNav('all')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-800 text-white border border-zinc-700 active-filter">Semua</button>
        <button onclick="filterNav('tiket')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-900 text-zinc-400 hover:text-white border border-zinc-800">Tiketing</button>
        <button onclick="filterNav('ap')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-900 text-zinc-400 hover:text-white border border-zinc-800">Ganti AP</button>
        <button onclick="filterNav('wp')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-900 text-zinc-400 hover:text-white border border-zinc-800">WP-Error</button>
        <button onclick="filterNav('ont')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-900 text-zinc-400 hover:text-white border border-zinc-800">ONT/GPON</button>
        <button onclick="filterNav('mojang')" class="nav-filter-btn px-2 py-0.5 rounded bg-zinc-900 text-zinc-400 hover:text-white border border-zinc-800">Mojang</button>
      </div>

      <!-- Navigation Tree -->
      <nav id="nav-list" class="space-y-6 text-sm flex-1">
        
        <!-- Category: Core Overview -->
        <div class="nav-group" data-tags="all core overview topologi tools">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>OVERVIEW & TOPOLOGI</span>
            <span class="text-[10px] text-zinc-600">3</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-overview" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Ringkasan & Aturan</span>
              <span class="text-[10px] font-mono text-zinc-600">01</span>
            </a>
            <a href="#sec-topologi" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Topologi WMS Lite vs Reg</span>
              <span class="text-[10px] font-mono text-zinc-600">02</span>
            </a>
            <a href="#sec-tools" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Portal & Tools Utama</span>
              <span class="text-[10px] font-mono text-zinc-600">03</span>
            </a>
          </div>
        </div>

        <!-- Category: Tiketing -->
        <div class="nav-group" data-tags="all tiket ticketing insere smarthub order">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>TIKETING WIFI-ID</span>
            <span class="text-[10px] text-zinc-600">2</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-ticketing" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Reactive AP vs Service</span>
              <span class="text-[10px] font-mono text-zinc-600">04</span>
            </a>
            <a href="#sec-order-tiket" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Order Gangguan CCAN</span>
              <span class="text-[10px] font-mono text-zinc-600">05</span>
            </a>
          </div>
        </div>

        <!-- Category: Ganti AP -->
        <div class="nav-group" data-tags="all ap wism cisco wlc apose apehbot">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>GANTI ACCESS POINT</span>
            <span class="text-[10px] text-zinc-600">3</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-ganti-ap" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Ganti AP (Sama IP WISM)</span>
              <span class="text-[10px] font-mono text-zinc-600">06</span>
            </a>
            <a href="#sec-login-wism" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Tutorial Login WISM Cisco</span>
              <span class="text-[10px] font-mono text-zinc-600">07</span>
            </a>
            <a href="#sec-ganti-ap-beda" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Ganti AP - Beda WISM</span>
              <span class="text-[10px] font-mono text-zinc-600">08</span>
            </a>
          </div>
        </div>

        <!-- Category: WP-Error -->
        <div class="nav-group" data-tags="all wp wp-error captive acs wpgen locating">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>WP-ERROR / URL ERROR</span>
            <span class="text-[10px] text-zinc-600">2</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-wp-error" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Kasus 1, 2 & 3 WP Error</span>
              <span class="text-[10px] font-mono text-zinc-600">09</span>
            </a>
            <a href="#sec-port-locating" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Port Locating Error (X)</span>
              <span class="text-[10px] font-mono text-zinc-600">10</span>
            </a>
          </div>
        </div>

        <!-- Category: ONT & GPON -->
        <div class="nav-group" data-tags="all ont gpon zte tacacs cli bukis password client">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>ONT & GPON CONFIG</span>
            <span class="text-[10px] text-zinc-600">5</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-tacacs-ont" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Config TACACS Ganti ONT</span>
              <span class="text-[10px] font-mono text-zinc-600">11</span>
            </a>
            <a href="#sec-bukis" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Buka Isolir (Bukis)</span>
              <span class="text-[10px] font-mono text-zinc-600">12</span>
            </a>
            <a href="#sec-password" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Cek & Ganti Password</span>
              <span class="text-[10px] font-mono text-zinc-600">13</span>
            </a>
            <a href="#sec-client-usage" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Cek Client & Bandwidth</span>
              <span class="text-[10px] font-mono text-zinc-600">14</span>
            </a>
            <a href="#sec-sn-ont" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Cek SN ONT dari AP-SN</span>
              <span class="text-[10px] font-mono text-zinc-600">15</span>
            </a>
          </div>
        </div>

        <!-- Category: Mojang -->
        <div class="nav-group" data-tags="all mojang excel vlookup sugar prabac report">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>REKONSILIASI DATA</span>
            <span class="text-[10px] text-zinc-600">1</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-mojang" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Rekonsiliasi Mojang Excel</span>
              <span class="text-[10px] font-mono text-zinc-600">16</span>
            </a>
          </div>
        </div>

        <!-- Category: Tracing -->
        <div class="nav-group" data-tags="all tracing mac metro huawei cisco cli">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>NETWORK TRACING</span>
            <span class="text-[10px] text-zinc-600">1</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-tracing" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Tracing MAC & Switch Metro</span>
              <span class="text-[10px] font-mono text-zinc-600">17</span>
            </a>
          </div>
        </div>

        <!-- Category: Quick Notes -->
        <div class="nav-group" data-tags="all quick channel rsa intermitten wifiv6">
          <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
            <span>OPERATIONAL QUICK NOTES</span>
            <span class="text-[10px] text-zinc-600">8</span>
          </div>
          <div class="space-y-1">
            <a href="#sec-ganti-channel" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Ganti Channel (ACS)</span>
              <span class="text-[10px] font-mono text-zinc-600">18</span>
            </a>
            <a href="#sec-intermitten" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Intermitten (OGP)</span>
              <span class="text-[10px] font-mono text-zinc-600">19</span>
            </a>
            <a href="#sec-ap-gress" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Ganti AP Baru (Gress)</span>
              <span class="text-[10px] font-mono text-zinc-600">20</span>
            </a>
            <a href="#sec-create-rsa" class="nav-link flex items-center justify-between px-2.5 py-1.5 rounded-md text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
              <span class="truncate">Create RSA & Automation</span>
              <span class="text-[10px] font-mono text-zinc-600">21</span>
            </a>
          </div>
        </div>

      </nav>

      <!-- Sidebar Footer -->
      <div class="pt-4 mt-6 border-t border-zinc-800/80 text-[11px] font-mono text-zinc-500 flex items-center justify-between">
        <span>ROC TELKOM REG 5</span>
        <span class="w-2 h-2 rounded-full bg-emerald-500" title="System Operational"></span>
      </div>
    </aside>

    <!-- MAIN CONTENT ON RIGHT -->
    <main class="flex-1 min-w-0 px-4 sm:px-8 lg:px-12 py-8 max-w-5xl">
      
      <!-- HERO / INTRO SECTION -->
      <section id="sec-overview" class="pb-10 border-b border-zinc-800">
        <div class="flex items-center gap-2 mb-3">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">PANDUAN OPERASIONAL</span>
          <span class="text-xs font-mono text-zinc-500">REV 2026</span>
        </div>
        
        <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight mb-4">
          WIFI-ID NOTES & STANDARD OPERATING PROCEDURES
        </h1>
        
        <p class="text-zinc-400 leading-relaxed text-base max-w-3xl mb-6">
          Dokumentasi teknis lengkap dan panduan pemecahan masalah (*troubleshooting*) layanan WiFi.id / WiFi Managed Service (WMS Lite & WMS Reguler) untuk tim operasional ROC Regional 5 dan CCAN Witel.
        </p>

        <!-- Warning Callout -->
        <div class="p-4 rounded-xl border border-zinc-700 bg-zinc-900/90 text-zinc-200 flex items-start gap-3.5 shadow-lg">
          <div class="text-xl shrink-0 mt-0.5">⚠️</div>
          <div>
            <h4 class="text-sm font-bold text-white tracking-wide uppercase">PERINGATAN KERAHASIAAN TIM</h4>
            <p class="text-xs text-zinc-300 mt-1 leading-relaxed">
              <strong>JANGAN DI SHARE LUAR TEAM YA GUYS YAAAAA !!!!!!!!!!!</strong> Seluruh data kredensial, IP NAT WISM, format perintah CLI, dan prosedur rekonsiliasi merupakan panduan internal.
            </p>
          </div>
        </div>
      </section>

      <!-- TOPOLOGI SECTION -->
      <section id="sec-topologi" class="py-10 border-b border-zinc-800">
        <div class="flex items-center justify-between mb-2">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300 uppercase">ARSITEKTUR</span>
          <span class="text-xs font-mono text-zinc-500">WMS LITE & REGULER</span>
        </div>
        <h2 class="text-2xl font-bold text-white tracking-tight mb-3">Topologi WiFi.id Secara Sederhana</h2>
        <p class="text-zinc-400 text-sm leading-relaxed mb-6">
          Layanan WiFi Managed Service (WMS) dibagi menjadi dua kategori arsitektur utama berdasarkan perangkat pemancar dan pengendali:
        </p>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <!-- WMS Lite -->
          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950/70 hover:border-zinc-700 transition-all">
            <div class="flex items-center justify-between mb-3">
              <span class="px-2 py-0.5 rounded text-xs font-mono bg-zinc-800 text-white font-semibold">1. WMS LITE</span>
              <span class="text-xs font-mono text-zinc-500">CPE Integrated</span>
            </div>
            <h3 class="text-base font-semibold text-white mb-2">Berbasis ONT / Modem Langsung</h3>
            <ul class="text-xs text-zinc-400 space-y-1.5 list-disc ml-4">
              <li>ONT (ZTE/Huawei) berfungsi sekaligus sebagai Access Point pemancar WiFi.</li>
              <li>Menggunakan <strong class="text-zinc-200">VLAN 4090</strong> untuk traffic data captive portal WMS.</li>
              <li>Konfigurasi langsung dipush via OLT TACACS atau ACS i-Booster.</li>
              <li>Identifikasi cukup menggunakan <strong class="text-zinc-200">SID / Nomor Internet</strong>.</li>
            </ul>
          </div>

          <!-- WMS Reguler -->
          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950/70 hover:border-zinc-700 transition-all">
            <div class="flex items-center justify-between mb-3">
              <span class="px-2 py-0.5 rounded text-xs font-mono bg-zinc-800 text-white font-semibold">2. WMS REGULER</span>
              <span class="text-xs font-mono text-zinc-500">Enterprise AP</span>
            </div>
            <h3 class="text-base font-semibold text-white mb-2">Berbasis AP Eksternal + WLC</h3>
            <ul class="text-xs text-zinc-400 space-y-1.5 list-disc ml-4">
              <li>Menggunakan Access Point enterprise (Cisco Aironet/Catalyst).</li>
              <li>AP terhubung ke Switch Metro dan dikontrol terpusat oleh <strong class="text-zinc-200">WAC / WISM</strong>.</li>
              <li>Traffic di-tunnel menggunakan CAPWAP ke Controller.</li>
              <li>Identifikasi memerlukan <strong class="text-zinc-200">SID + AP Serial Number (AP-SN) + MAC Address</strong>.</li>
            </ul>
          </div>
        </div>
      </section>

      <!-- PORTAL & TOOLS UTAMA -->
      <section id="sec-tools" class="py-10 border-b border-zinc-800">
        <div class="flex items-center justify-between mb-2">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300 uppercase">QUICK ACCESS</span>
          <span class="text-xs font-mono text-zinc-500">6 PORTAL UTAMA</span>
        </div>
        <h2 class="text-2xl font-bold text-white tracking-tight mb-3">Web Tools & Sistem Operasional</h2>
        <p class="text-zinc-400 text-sm leading-relaxed mb-6">
          Daftar tautan langsung dan fungsi utama sistem yang digunakan dalam operasional harian WiFi.id:
        </p>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
          
          <a href="https://smarthub.wifi.id/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm group-hover:text-zinc-200">SMARTHUB</span>
              <svg class="w-4 h-4 text-zinc-500 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
            </div>
            <p class="text-xs text-zinc-400 mb-2">Monitoring AP Mati, Tiket Reactive, Datek APOSE, dan Sugar Report.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">smarthub.wifi.id</span>
          </a>

          <a href="http://insera.telkom.co.id/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm group-hover:text-zinc-200">INSERA</span>
              <svg class="w-4 h-4 text-zinc-500 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
            </div>
            <p class="text-xs text-zinc-400 mb-2">Pencatatan nomor tiket gangguan nasional dan status penyelesaian.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">insera.telkom.co.id</span>
          </a>

          <a href="https://wms.wifi.id/wp-wms/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm group-hover:text-zinc-200">WPGEN</span>
              <svg class="w-4 h-4 text-zinc-500 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
            </div>
            <p class="text-xs text-zinc-400 mb-2">Kelola SSID, Location ID, status isolir (Bukis), dan password WMS.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">wms.wifi.id/wp-wms</span>
          </a>

          <div class="p-4 rounded-lg border border-zinc-800 bg-zinc-950">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm">WISM / WAC CISCO</span>
              <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">Mozilla</span>
            </div>
            <p class="text-xs text-zinc-400 mb-2">WLC GUI untuk konfigurasi AP Name, HA, AP Groups, dan monitoring klien.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">https://[IP_NAT]/screens/frameset.html</span>
          </div>

          <a href="https://acs-ibooster.telkom.co.id/index.php" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm group-hover:text-zinc-200">ACS I-BOOSTER</span>
              <svg class="w-4 h-4 text-zinc-500 group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
            </div>
            <p class="text-xs text-zinc-400 mb-2">Remote ONT TR-069, ubah Security Type ke Open System, cek FW.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">acs-ibooster.telkom.co.id</span>
          </a>

          <div class="p-4 rounded-lg border border-zinc-800 bg-zinc-950">
            <div class="flex items-center justify-between mb-2">
              <span class="font-bold text-white text-sm">WEB MOJANG</span>
              <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">10.2.113.234</span>
            </div>
            <p class="text-xs text-zinc-400 mb-2">Upload data rekap harian AP gangguan. User: <code class="text-white">63984</code>, Pass: <code class="text-white">Tif63984</code>.</p>
            <span class="text-[10px] font-mono text-zinc-500 truncate block">http://10.2.113.234:8081</span>
          </div>

        </div>
      </section>

      <!-- DYNAMIC COMPILED SECTIONS (ALL 23 SUBPAGES & IMAGES) -->
      $combinedSectionsHtml

      <!-- ROOT EXTRA CONTENT (CLI TRACING & METRO) -->
      <section id="sec-tracing" class="scroll-mt-20 pt-8 pb-12 border-b border-zinc-800/80">
        <div class="flex items-center justify-between gap-4 mb-2">
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono uppercase tracking-wider bg-zinc-800 text-zinc-300 border border-zinc-700/80 font-medium">CLI TRACING</span>
          <span class="text-xs font-mono text-zinc-500">SWITCH METRO & WAC</span>
        </div>
        <h2 class="text-2xl font-bold text-white tracking-tight mb-2">
          Tracing Datek AP Berdasarkan MAC Address & Port Metro
        </h2>
        <p class="text-zinc-400 text-sm leading-relaxed mb-6">
          Penelusuran port switch dan VLAN Access Point secara bertingkat dari WAC Cisco ke Switch Metro Huawei menggunakan SecureCRT / ZOC:
        </p>
        <div class="mt-4 space-y-2">
          $rootExtraHtml
        </div>
      </section>

      <!-- FOOTER -->
      <footer class="pt-12 pb-16 text-center text-xs font-mono text-zinc-500 border-t border-zinc-900 mt-12">
        <div class="flex items-center justify-center gap-2 mb-2">
          <div class="w-2 h-2 rounded-full bg-white"></div>
          <span class="text-zinc-400 font-semibold">WIFI-ID NOTES &middot; ROC REGIONAL 5</span>
        </div>
        <p>Di-render secara otomatis dari dokumentasi Notion internal. 130 tangkapan layar tersimpan secara lokal dan siap offline.</p>
      </footer>

    </main>
  </div>

  <!-- LIGHTBOX MODAL (FOR ENLARGING ANY SCREENSHOT) -->
  <div id="lightbox-modal" class="fixed inset-0 z-50 bg-black/95 backdrop-blur-md hidden flex flex-col items-center justify-center p-4 sm:p-6" onclick="closeLightbox(event)">
    <div class="absolute top-4 right-4 flex items-center gap-3 z-10" onclick="event.stopPropagation()">
      <button onclick="zoomImage(0.2)" class="p-2 rounded-lg bg-zinc-900 text-zinc-300 hover:text-white border border-zinc-800" title="Zoom In">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
      </button>
      <button onclick="zoomImage(-0.2)" class="p-2 rounded-lg bg-zinc-900 text-zinc-300 hover:text-white border border-zinc-800" title="Zoom Out">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path></svg>
      </button>
      <button onclick="resetZoom()" class="px-2.5 py-1.5 rounded-lg bg-zinc-900 text-zinc-300 hover:text-white border border-zinc-800 text-xs font-mono" title="Reset">
        100%
      </button>
      <button onclick="closeLightbox()" class="p-2 rounded-lg bg-zinc-900 text-zinc-300 hover:text-white border border-zinc-800" title="Tutup (Esc)">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
      </button>
    </div>

    <div class="w-full h-full flex flex-col items-center justify-center overflow-hidden" onclick="event.stopPropagation()">
      <div id="lightbox-container" class="relative max-w-full max-h-[85vh] transition-transform duration-150 cursor-grab active:cursor-grabbing">
        <img id="lightbox-img" src="" alt="Screenshot Fullsize" class="max-w-full max-h-[82vh] object-contain rounded-lg border border-zinc-800 shadow-2xl mx-auto select-none" />
      </div>
      <div id="lightbox-caption" class="text-xs font-mono text-zinc-400 mt-3 max-w-2xl text-center px-4"></div>
    </div>
  </div>

  <!-- SEARCH MODAL (CMD/CTRL + K) -->
  <div id="search-modal" class="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm hidden flex items-start justify-center pt-20 p-4" onclick="closeSearchModal(event)">
    <div class="w-full max-w-xl rounded-xl border border-zinc-800 bg-zinc-950 p-4 shadow-2xl" onclick="event.stopPropagation()">
      <div class="flex items-center gap-2.5 px-3 py-2 rounded-lg border border-zinc-800 bg-zinc-900 mb-3">
        <svg class="w-4 h-4 text-zinc-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
        <input id="search-input" type="text" placeholder="Ketik topik, perintah CLI, nomor port, atau nama menu..." class="w-full bg-transparent text-sm text-white focus:outline-none placeholder:text-zinc-500 font-sans" oninput="performSearch(this.value)" autofocus />
        <kbd class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 border border-zinc-700">ESC</kbd>
      </div>

      <div id="search-results" class="max-h-80 overflow-y-auto space-y-1 text-sm divide-y divide-zinc-900">
        <div class="p-3 text-xs text-zinc-500 text-center font-mono">Ketik kata kunci untuk mencari di seluruh materi...</div>
      </div>
    </div>
  </div>

  <!-- JAVASCRIPT LOGIC -->
  <script>
    // Copy Code functionality
    function copyCode(elementId, btn) {
      const el = document.getElementById(elementId);
      if (!el) return;
      const text = el.innerText || el.textContent;
      navigator.clipboard.writeText(text).then(() => {
        const original = btn.innerHTML;
        btn.innerHTML = `<svg class="w-3.5 h-3.5 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg><span class="text-emerald-400 font-semibold">Tersalin</span>`;
        btn.classList.add('border-emerald-600/50');
        setTimeout(() => {
          btn.innerHTML = original;
          btn.classList.remove('border-emerald-600/50');
        }, 2000);
      });
    }

    // Lightbox Modal
    let currentZoom = 1;
    function openLightbox(src, caption) {
      const modal = document.getElementById('lightbox-modal');
      const img = document.getElementById('lightbox-img');
      const cap = document.getElementById('lightbox-caption');
      img.src = src;
      cap.innerHTML = caption || '';
      modal.classList.remove('hidden');
      document.body.classList.add('overflow-hidden');
      resetZoom();
    }

    function closeLightbox(e) {
      if (e && e.target !== e.currentTarget && !e.target.closest('button')) return;
      const modal = document.getElementById('lightbox-modal');
      modal.classList.add('hidden');
      document.body.classList.remove('overflow-hidden');
      resetZoom();
    }

    function zoomImage(delta) {
      currentZoom = Math.max(0.5, Math.min(3, currentZoom + delta));
      const container = document.getElementById('lightbox-container');
      container.style.transform = `scale(` + currentZoom + `)`;
    }

    function resetZoom() {
      currentZoom = 1;
      const container = document.getElementById('lightbox-container');
      container.style.transform = 'scale(1)';
    }

    // Keyboard Shortcuts
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        closeLightbox();
        closeSearchModal();
      }
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        openSearchModal();
      }
    });

    // Mobile Sidebar Toggle
    function toggleSidebar() {
      const sidebar = document.getElementById('sidebar');
      sidebar.classList.toggle('-translate-x-full');
    }

    // Filter Navigation Tags
    function filterNav(tag) {
      document.querySelectorAll('.nav-filter-btn').forEach(btn => {
        btn.classList.remove('bg-zinc-800', 'text-white', 'active-filter');
        btn.classList.add('bg-zinc-900', 'text-zinc-400');
      });
      event.target.classList.remove('bg-zinc-900', 'text-zinc-400');
      event.target.classList.add('bg-zinc-800', 'text-white', 'active-filter');

      const groups = document.querySelectorAll('.nav-group');
      groups.forEach(group => {
        const tags = group.getAttribute('data-tags') || '';
        if (tag === 'all' || tags.includes(tag)) {
          group.style.display = 'block';
        } else {
          group.style.display = 'none';
        }
      });
    }

    // Active Scrollspy
    window.addEventListener('scroll', () => {
      const sections = document.querySelectorAll('section[id]');
      const scrollPos = window.scrollY + 100;

      sections.forEach(sec => {
        const top = sec.offsetTop;
        const height = sec.offsetHeight;
        const id = sec.getAttribute('id');
        if (scrollPos >= top && scrollPos < top + height) {
          document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === '#' + id) {
              link.classList.add('active');
            }
          });
        }
      });
    });

    // Search Modal
    function openSearchModal() {
      const modal = document.getElementById('search-modal');
      modal.classList.remove('hidden');
      setTimeout(() => document.getElementById('search-input').focus(), 50);
    }

    function closeSearchModal() {
      document.getElementById('search-modal').classList.add('hidden');
    }

    const searchableSections = [
      { id: 'sec-overview', title: 'Ringkasan & Disclaimer Team', tag: 'Overview' },
      { id: 'sec-topologi', title: 'Topologi WMS Lite vs WMS Reguler', tag: 'Arsitektur' },
      { id: 'sec-tools', title: 'Daftar Portal & Tools Utama (Smarthub, Insera, WPGEN, WISM, ACS)', tag: 'Tools' },
      { id: 'sec-ticketing', title: 'Tiketing WiFi.id (Reactive AP Mati vs Reactive Service Logic)', tag: 'Tiketing' },
      { id: 'sec-ganti-ap', title: 'SOP Ganti AP (Kondisi Sama IP WISM)', tag: 'Ganti AP' },
      { id: 'sec-login-wism', title: 'Tutorial Login WISM Cisco via Mozilla Firefox & APEHBOT', tag: 'WISM' },
      { id: 'sec-ganti-ap-beda', title: 'Ganti AP - Beda WISM Controller', tag: 'Ganti AP' },
      { id: 'sec-wp-error', title: 'WP-Error / URL Error (Kasus 1: ACS Open System, Kasus 2: Location ID, Kasus 3: SSID)', tag: 'WP-Error' },
      { id: 'sec-port-locating', title: 'WP Error Port Locating Silang (X) di ONT Pelanggan', tag: 'WP-Error' },
      { id: 'sec-tacacs-ont', title: 'Konfigurasi WMS TACACS ONT ZTE Ganti ONT Baru (VLAN 4090 WMS)', tag: 'GPON' },
      { id: 'sec-bukis', title: 'Buka Isolir Pelanggan (Bukis via WPGEN)', tag: 'Isolir' },
      { id: 'sec-password', title: 'Cek & Ganti Password Akun/SSID WMS di WPGEN', tag: 'Password' },
      { id: 'sec-client-usage', title: 'Cek Penggunaan Client & Bandwidth Terbesar di WLC Cisco', tag: 'Monitoring' },
      { id: 'sec-sn-ont', title: 'Cek Serial Number ONT dari AP-SN di Smarthub', tag: 'Smarthub' },
      { id: 'sec-mojang', title: 'Rekonsiliasi Laporan Harian Mojang via Excel (VLOOKUP Sugar & Prabac)', tag: 'Mojang' },
      { id: 'sec-tracing', title: 'Tracing MAC Address AP pada WAC Cisco & Switch Metro Huawei', tag: 'CLI Tracing' },
      { id: 'sec-ganti-channel', title: 'Ganti Channel Frekuensi via ACS', tag: 'Radio' },
      { id: 'sec-intermitten', title: 'Troubleshooting Gangguan Intermitten (OGP)', tag: 'Quality' }
    ];

    function performSearch(query) {
      const q = query.toLowerCase().trim();
      const resultsDiv = document.getElementById('search-results');
      if (!q) {
        resultsDiv.innerHTML = '<div class="p-3 text-xs text-zinc-500 text-center font-mono">Ketik kata kunci untuk mencari di seluruh materi...</div>';
        return;
      }

      const matched = searchableSections.filter(s => s.title.toLowerCase().includes(q) || s.tag.toLowerCase().includes(q));
      if (matched.length === 0) {
        resultsDiv.innerHTML = '<div class="p-3 text-xs text-zinc-500 text-center font-mono">Tidak ditemukan hasil untuk "' + query + '"</div>';
        return;
      }

      let html = '';
      matched.forEach(item => {
        html += `
          <a href="#` + item.id + `" onclick="closeSearchModal()" class="flex items-center justify-between p-2.5 rounded-lg hover:bg-zinc-900 transition-colors group">
            <div class="flex items-center gap-2.5">
              <span class="text-xs font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 group-hover:text-white group-hover:bg-zinc-700">` + item.tag + `</span>
              <span class="text-sm text-zinc-200 group-hover:text-white">` + item.title + `</span>
            </div>
            <svg class="w-4 h-4 text-zinc-600 group-hover:text-zinc-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </a>
        `;
      });
      resultsDiv.innerHTML = html;
    }
  </script>
</body>
</html>
"@

[System.IO.File]::WriteAllText("index.html", $fullHtml, [System.Text.Encoding]::UTF8)
Write-Output "SUCCESS! Generated index.html with $((Get-Item index.html).Length) bytes."
