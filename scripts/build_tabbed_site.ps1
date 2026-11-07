# Complete Tabbed Site Generator
$blocks = Get-Content -Raw -Encoding UTF8 "all_blocks_complete.json" | ConvertFrom-Json
$imgMap = Get-Content -Raw -Encoding UTF8 "image_map.json" | ConvertFrom-Json

$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

Write-Output "Processing $($blockMap.Count) blocks..."

function Clean-Text($str) {
    if (-not $str) { return "" }
    return $str.Replace("Â·", "&middot;").Replace("Â»", "&raquo;").Replace("â€œ", "&ldquo;").Replace("â€ ", "&rdquo;").Replace("â€™", "&rsquo;").Replace("â‡’", "&rarr;").Replace("â€¦", "...").Replace("dY~%", "").Replace("ðŸ˜‰", "").Replace("ðŸ¤£", "").Replace("ðŸ™ ", "")
}

function Get-RichHtml($prop) {
    if (-not $prop) { return "" }
    $out = ""
    foreach ($chunk in $prop) {
        $text = [System.Net.WebUtility]::HtmlEncode($chunk[0])
        $text = Clean-Text $text
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
            $cleanCode = Clean-Text $cleanCode
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

function Render-Subpage-Content($pageId) {
    $p = $blockMap[$pageId]
    if (-not $p) { return "" }
    
    $lines = [System.Collections.Generic.List[string]]::new()
    $vSet = [System.Collections.Generic.HashSet[string]]::new()
    
    if ($p.content) {
        foreach ($cid in $p.content) {
            Render-Block-Tree $cid $lines $vSet
        }
    }
    return $lines -join "`n"
}

Write-Output "Extracting Root Extra blocks (Tracing & Metro)..."
$rootBlock = $blockMap["340bc60a-349d-8029-8c50-e2ff294097b4"]
$tracingLines = [System.Collections.Generic.List[string]]::new()
$tracingVSet = [System.Collections.Generic.HashSet[string]]::new()

$foundTracing = $false
foreach ($rcid in $rootBlock.content) {
    $rb = $blockMap[$rcid]
    if (-not $rb) { continue }
    $rtxt = if ($rb.properties.title) { ($rb.properties.title | ForEach-Object { $_[0] }) -join "" } else { "" }
    if ($rtxt -like "*TRACING DATEK WITH MAC ADDRESS*") {
        $foundTracing = $true
    }
    if ($foundTracing -and $rb.type -ne "page") {
        Render-Block-Tree $rcid $tracingLines $tracingVSet
    }
}
$tracingHtml = $tracingLines -join "`n"

Write-Output "Rendering individual subpages..."

$htmlTicketing = Render-Subpage-Content "340bc60a-349d-80f2-9d4e-e97691869aba"

$htmlGantiAp = Render-Subpage-Content "340bc60a-349d-80f9-bdd1-f004dbd11ed2"
$htmlLoginWism = Render-Subpage-Content "340bc60a-349d-81ee-93aa-cacbb6ef33a2"
$htmlGantiApBeda = Render-Subpage-Content "340bc60a-349d-80b6-a7ea-f2a88be9038d"

$htmlWpError = Render-Subpage-Content "340bc60a-349d-8028-ad88-e48661065286"
$htmlPortLocating = Render-Subpage-Content "340bc60a-349d-80ff-93ad-ed04e4254f4e"

$htmlTacacsOnt = Render-Subpage-Content "340bc60a-349d-800f-9785-dd6f0114c2a2"
$htmlBukis = Render-Subpage-Content "386bc60a-349d-804c-bffe-ff22dfab5499"
$htmlPassword = Render-Subpage-Content "340bc60a-349d-805d-a0a5-ccaaa5369cc8"
$htmlClientUsage = Render-Subpage-Content "340bc60a-349d-809a-b3b1-edad2b75ee0e"
$htmlSnOnt = Render-Subpage-Content "340bc60a-349d-80f3-abe1-fbea9a8c2de8"

$htmlMojang = Render-Subpage-Content "386bc60a-349d-80b9-9a98-dad9aa97c58e"

$htmlGantiChannel = Render-Subpage-Content "340bc60a-349d-8036-b123-dab53afd82c8"
$htmlIntermitten = Render-Subpage-Content "340bc60a-349d-80ba-8ab6-ecc230b933e8"
$htmlApGress = Render-Subpage-Content "340bc60a-349d-80ac-93ba-f7bb8263f82a"
$htmlCreateRsa = Render-Subpage-Content "340bc60a-349d-8026-9aa7-f457eeed4ab0"
$htmlRsaAuto = Render-Subpage-Content "340bc60a-349d-8067-99f0-c5e085b0594b"
$htmlResendEmail = Render-Subpage-Content "340bc60a-349d-8011-bfc3-fa722365c73e"
$htmlWifiv6 = Render-Subpage-Content "340bc60a-349d-8059-9de2-ee3a6bc16cae"
$htmlOpenTiket = Render-Subpage-Content "340bc60a-349d-8078-b957-db39a075300c"

Write-Output "Assembling Tabbed HTML Structure..."

# Read topology image path
$topoImgPath = $imgMap."340bc60a-349d-80f7-8bf2-cbee5f186482"
if (-not $topoImgPath) { $topoImgPath = "assets/images/340bc60a-349d-80f7-8bf2-cbee5f186482.png" }

$fullHtml = @"
<!DOCTYPE html>
<html lang="id" class="bg-black text-zinc-100 antialiased selection:bg-zinc-800 selection:text-white">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WIFI-ID NOTES &middot; ROC TELKOM REGIONAL 5</title>
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
    ::-webkit-scrollbar { width: 5px; height: 5px; }
    ::-webkit-scrollbar-track { background: #000000; }
    ::-webkit-scrollbar-thumb { background: #27272a; border-radius: 9999px; }
    ::-webkit-scrollbar-thumb:hover { background: #3f3f46; }

    /* Tab transitions */
    .tab-content { display: none; opacity: 0; transition: opacity 0.15s ease-in-out; }
    .tab-content.active { display: block; opacity: 1; }

    .sidebar-btn.active {
      background-color: #27272a !important;
      color: #ffffff !important;
      font-weight: 600;
      border-left: 3px solid #ffffff;
    }
    
    @media print {
      aside, #top-bar, #search-modal, #lightbox-modal { display: none !important; }
      main { margin-left: 0 !important; width: 100% !important; }
      body { background: white !important; color: black !important; }
      .tab-content { display: block !important; opacity: 1 !important; page-break-after: always; }
    }
  </style>
</head>
<body class="min-h-screen bg-black font-sans text-zinc-300 antialiased flex flex-col">

  <!-- TOP HEADER -->
  <header id="top-bar" class="sticky top-0 z-40 w-full border-b border-zinc-800/90 bg-black/90 backdrop-blur-md">
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
          <span class="hidden sm:inline">Cari materi atau perintah...</span>
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

  <!-- BODY: LEFT NAVIGATION TABS, RIGHT CONTENT VIEW -->
  <div class="flex-1 flex max-w-[1720px] w-full mx-auto">
    
    <!-- LEFT SIDEBAR -->
    <aside id="sidebar" class="fixed inset-y-0 left-0 z-30 w-72 lg:w-80 bg-zinc-950 border-r border-zinc-800/80 transform -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out lg:static lg:h-[calc(100vh-3.5rem)] lg:sticky lg:top-14 overflow-y-auto flex flex-col p-4">
      
      <!-- Team Warning Badge (CLEAN SVG NO CORRUPT EMOJI) -->
      <div class="mb-4 p-3 rounded-lg border border-zinc-800 bg-zinc-900/60 text-xs text-zinc-400 flex items-start gap-2.5">
        <svg class="w-4 h-4 text-zinc-300 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
        <div>
          <strong class="text-zinc-200 block mb-0.5">INTERNAL TEAM ONLY</strong>
          Jangan share keluar team ya guys! Dokumentasi operasional WiFi.id.
        </div>
      </div>

      <!-- Navigation Section Label -->
      <div class="text-[11px] font-mono uppercase tracking-wider text-zinc-500 font-semibold px-2 mb-2 flex items-center justify-between">
        <span>MODUL OPERASIONAL</span>
        <span class="text-[10px] text-zinc-600">8 TABS</span>
      </div>

      <!-- TAB BUTTONS LIST -->
      <nav class="space-y-1 text-sm flex-1">
        
        <!-- Tab 1: Topologi (TOP PRIORITY) -->
        <button onclick="switchTab('tab-topologi')" id="btn-tab-topologi" class="sidebar-btn active w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">🌐</span>
            <span class="truncate font-medium">1. Topologi & Arsitektur</span>
          </div>
          <span class="text-[10px] font-mono px-1.5 py-0.2 rounded bg-zinc-800 text-zinc-300 font-bold border border-zinc-700">UTAMA</span>
        </button>

        <!-- Tab 2: Tiketing -->
        <button onclick="switchTab('tab-ticketing')" id="btn-tab-ticketing" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">🎫</span>
            <span class="truncate">2. Tiketing WiFi.id</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">Insera</span>
        </button>

        <!-- Tab 3: Ganti AP -->
        <button onclick="switchTab('tab-ganti-ap')" id="btn-tab-ganti-ap" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">🔄</span>
            <span class="truncate">3. SOP Ganti AP</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">WISM</span>
        </button>

        <!-- Tab 4: WP-Error -->
        <button onclick="switchTab('tab-wp-error')" id="btn-tab-wp-error" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">⚠️</span>
            <span class="truncate">4. WP-Error / URL Error</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">Portal</span>
        </button>

        <!-- Tab 5: GPON & ONT -->
        <button onclick="switchTab('tab-gpon-ont')" id="btn-tab-gpon-ont" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">⚙️</span>
            <span class="truncate">5. Config GPON & ONT</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">CLI</span>
        </button>

        <!-- Tab 6: Mojang -->
        <button onclick="switchTab('tab-mojang')" id="btn-tab-mojang" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">📊</span>
            <span class="truncate">6. Rekonsiliasi Mojang</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">Excel</span>
        </button>

        <!-- Tab 7: Network Tracing -->
        <button onclick="switchTab('tab-tracing')" id="btn-tab-tracing" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">🔍</span>
            <span class="truncate">7. Network Tracing (CLI)</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">Metro</span>
        </button>

        <!-- Tab 8: Quick SOP & Tools -->
        <button onclick="switchTab('tab-quick-ops')" id="btn-tab-quick-ops" class="sidebar-btn w-full flex items-center justify-between px-3 py-2.5 rounded-md text-left text-zinc-400 hover:text-white hover:bg-zinc-900 transition-colors">
          <div class="flex items-center gap-2.5">
            <span class="text-base">🛠️</span>
            <span class="truncate">8. Quick SOP & Integrasi</span>
          </div>
          <span class="text-[10px] font-mono text-zinc-500">Radio</span>
        </button>

      </nav>

      <!-- Sidebar Footer -->
      <div class="pt-4 mt-6 border-t border-zinc-800/80 text-[11px] font-mono text-zinc-500 flex items-center justify-between">
        <span>ROC TELKOM REG 5</span>
        <span class="w-2 h-2 rounded-full bg-emerald-500" title="System Operational"></span>
      </div>
    </aside>

    <!-- RIGHT CONTENT VIEW (SINGLE ACTIVE TAB AT A TIME) -->
    <main class="flex-1 min-w-0 px-4 sm:px-8 lg:px-12 py-8 max-w-5xl overflow-y-auto">

      <!-- ============================================================== -->
      <!-- TAB 1: TOPOLOGI & ARSITEKTUR JARINGAN (FIRST & MOST DETAILED)   -->
      <!-- ============================================================== -->
      <div id="tab-topologi" class="tab-content active space-y-8">
        
        <!-- Breadcrumb & Tag -->
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">1. ARSITEKTUR & TOPOLOGI</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">PANDUAN DASAR</span>
        </div>

        <!-- Hero Section -->
        <div>
          <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight mb-3">
            Topologi Jaringan WiFi.id & Arsitektur Layanan
          </h1>
          <p class="text-zinc-400 leading-relaxed text-sm max-w-3xl">
            Arsitektur end-to-end layanan WiFi Managed Service (WMS Lite & WMS Reguler), alur traffic captive portal, fungsi controller WLC/WISM, serta pembagian segmen jaringan dari Access Point hingga Gateway Nasional.
          </p>
        </div>

        <!-- Disclaimer Box -->
        <div class="p-4 rounded-xl border border-zinc-800 bg-zinc-900/60 text-zinc-300 flex items-start gap-3.5 shadow-sm">
          <div class="p-2 rounded bg-zinc-800 border border-zinc-700 text-white shrink-0">
            <svg class="w-5 h-5 text-zinc-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
          </div>
          <div>
            <h4 class="text-sm font-bold text-white uppercase tracking-wide">PERINGATAN KERAHASIAAN TIM</h4>
            <p class="text-xs text-zinc-400 mt-1 leading-relaxed">
              <strong class="text-white">JANGAN DI SHARE LUAR TEAM YA GUYS YAAAAA !!!!!!!!!!!</strong> Seluruh data kredensial, IP NAT WISM, format perintah CLI, dan prosedur rekonsiliasi merupakan panduan operasional internal.
            </p>
          </div>
        </div>

        <!-- TOPOLOGY IMAGE (HIGH RES) -->
        <div class="rounded-xl border border-zinc-800 bg-zinc-950 p-3 sm:p-5 shadow-lg">
          <div class="flex items-center justify-between pb-3 mb-3 border-b border-zinc-800/80">
            <div>
              <h3 class="text-base font-bold text-white flex items-center gap-2">
                <span class="w-2.5 h-2.5 rounded-full bg-white"></span>
                Diagram Topologi WiFi.id Secara Sederhana
              </h3>
              <p class="text-xs text-zinc-500 font-mono mt-0.5">Sumber: Lampiran Dokumentasi Resmi Catatan WiFi.id</p>
            </div>
            <span class="text-xs font-mono text-zinc-400 px-2 py-1 rounded bg-zinc-900 border border-zinc-800">Klik gambar untuk zoom</span>
          </div>

          <div class="relative group overflow-hidden rounded-lg border border-zinc-800/90 bg-zinc-900/40 p-2 cursor-zoom-in" onclick="openLightbox('$topoImgPath', 'Diagram Lengkap Topologi Layanan WiFi.id (WMS Lite & WMS Reguler)')">
            <img src="$topoImgPath" alt="Diagram Lengkap Topologi WiFi.id" class="w-full max-h-[560px] object-contain rounded mx-auto transition-transform duration-200 group-hover:scale-[1.01]" />
            <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-900/95 text-zinc-200 text-xs px-3 py-1.5 rounded-lg border border-zinc-700 backdrop-blur-md flex items-center gap-1.5">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"></path></svg>
              <span>Perbesar Diagram</span>
            </div>
          </div>
        </div>

        <!-- DEEP-DIVE ARCHITECTURAL COMPARISON: WMS LITE VS WMS REGULER -->
        <div class="space-y-4">
          <h3 class="text-lg font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Perbandingan Arsitektur: WMS Lite vs WMS Reguler
          </h3>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            
            <!-- WMS Lite Card -->
            <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950/80 hover:border-zinc-700 transition-all flex flex-col justify-between">
              <div>
                <div class="flex items-center justify-between mb-3 pb-2 border-b border-zinc-800">
                  <span class="px-2.5 py-0.5 rounded text-xs font-mono bg-zinc-800 text-white font-bold">1. WMS LITE</span>
                  <span class="text-xs font-mono text-zinc-500">CPE Integrated Mode</span>
                </div>
                <h4 class="text-base font-semibold text-white mb-2">Berbasis ONT / Modem Langsung</h4>
                <p class="text-xs text-zinc-400 leading-relaxed mb-4">
                  Perangkat ONT (ZTE F609/F670 atau Huawei) difungsikan langsung sebagai Access Point pemancar SSID WiFi pelanggan.
                </p>
                <div class="space-y-2 text-xs text-zinc-300">
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>VLAN WMS:</strong> Menggunakan <strong>VLAN 4090</strong> hybrid pada port wifi_0/1.</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Security Type:</strong> WAJIB <strong>Open System</strong> (tanpa enkripsi WEP/WPA internal).</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Option 82:</strong> Menggunakan fitur <em>DHCP Port Locating</em> untuk identifikasi pelanggan.</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Pencarian Data:</strong> Cukup memerlukan <strong>SID (Nomor Internet)</strong> pelanggan di WPGEN.</span>
                  </div>
                </div>
              </div>
              <div class="mt-4 pt-3 border-t border-zinc-900 flex items-center justify-between text-[11px] font-mono text-zinc-500">
                <span>Target: UMKM / Cafe Kecil</span>
                <span>Config: ACS & OLT</span>
              </div>
            </div>

            <!-- WMS Reguler Card -->
            <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950/80 hover:border-zinc-700 transition-all flex flex-col justify-between">
              <div>
                <div class="flex items-center justify-between mb-3 pb-2 border-b border-zinc-800">
                  <span class="px-2.5 py-0.5 rounded text-xs font-mono bg-zinc-800 text-white font-bold">2. WMS REGULER</span>
                  <span class="text-xs font-mono text-zinc-500">Controller Managed AP</span>
                </div>
                <h4 class="text-base font-semibold text-white mb-2">Berbasis AP Enterprise + WLC Cisco</h4>
                <p class="text-xs text-zinc-400 leading-relaxed mb-4">
                  Menggunakan unit Access Point khusus (Cisco Aironet/Catalyst) yang dikelola terpusat oleh controller WLC / WAC / WISM.
                </p>
                <div class="space-y-2 text-xs text-zinc-300">
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Koneksi Jaringan:</strong> AP terhubung via Switch Metro Ethernet ke core network.</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Tunneling:</strong> Seluruh traffic di-encapsulate via <strong>CAPWAP Tunnel</strong> ke WISM Cisco.</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>AP Groups:</strong> SSID dibind melalui menu <em>Advanced AP Groups</em> sesuai paket silver/gold/platinum.</span>
                  </div>
                  <div class="flex items-start gap-2">
                    <span class="text-zinc-500 font-mono font-bold">&bull;</span>
                    <span><strong>Pencarian Data:</strong> Memerlukan <strong>AP Serial Number (AP-SN) + MAC Address + SID</strong>.</span>
                  </div>
                </div>
              </div>
              <div class="mt-4 pt-3 border-t border-zinc-900 flex items-center justify-between text-[11px] font-mono text-zinc-500">
                <span>Target: Instansi / Korporat / Kampus</span>
                <span>Config: WLC GUI</span>
              </div>
            </div>

          </div>
        </div>

        <!-- TECHNICAL PARAMETERS TABLE -->
        <div class="space-y-3">
          <h3 class="text-base font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Parameter Jaringan & Protokol Standar
          </h3>
          <div class="overflow-x-auto rounded-lg border border-zinc-800 bg-zinc-950">
            <table class="w-full text-left text-xs">
              <thead class="bg-zinc-900/90 text-zinc-400 uppercase font-mono border-b border-zinc-800">
                <tr>
                  <th class="p-3">Parameter</th>
                  <th class="p-3">WMS Lite (ONT)</th>
                  <th class="p-3">WMS Reguler (AP Cisco)</th>
                  <th class="p-3">Fungsi / Deskripsi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-zinc-900 text-zinc-300">
                <tr>
                  <td class="p-3 font-mono font-semibold text-white">VLAN WMS</td>
                  <td class="p-3 font-mono">4090</td>
                  <td class="p-3 font-mono">Dynamic CAPWAP (VSI WAC)</td>
                  <td class="p-3 text-zinc-400">VLAN payload data captive portal WiFi.id</td>
                </tr>
                <tr>
                  <td class="p-3 font-mono font-semibold text-white">VLAN VOIP</td>
                  <td class="p-3 font-mono">500 / 100 / 588</td>
                  <td class="p-3 font-mono">- (Data Dedicated)</td>
                  <td class="p-3 text-zinc-400">VLAN layanan telephony SIP jika ada</td>
                </tr>
                <tr>
                  <td class="p-3 font-mono font-semibold text-white">Landing Page URL</td>
                  <td class="p-3 font-mono">welcome2.wifi.id/wms/</td>
                  <td class="p-3 font-mono">welcome2.wifi.id/wms/</td>
                  <td class="p-3 text-zinc-400">Redirect captive portal login akun pelanggan</td>
                </tr>
                <tr>
                  <td class="p-3 font-mono font-semibold text-white">Security Auth</td>
                  <td class="p-3 font-mono">Open System</td>
                  <td class="p-3 font-mono">Open System / WPA2-Enterprise</td>
                  <td class="p-3 text-zinc-400">Wajib open agar redirect captive portal berfungsi</td>
                </tr>
                <tr>
                  <td class="p-3 font-mono font-semibold text-white">Controller Akses</td>
                  <td class="p-3 font-mono">ACS i-Booster / OLT CLI</td>
                  <td class="p-3 font-mono">WISM / WAC Cisco via IP NAT</td>
                  <td class="p-3 text-zinc-400">Platform remote konfigurasi dan pelurusan</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 6 CORE INTEGRATED PORTALS -->
        <div class="space-y-3 pt-4">
          <h3 class="text-base font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Pusat Portal & Web Tools Terintegrasi
          </h3>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
            
            <a href="https://smarthub.wifi.id/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm group-hover:text-zinc-200">1. SMARTHUB</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">Monitoring</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Monitoring AP Mati, Tiket Reactive AP & Service, Datek APOSE, dan Sugar Report.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">https://smarthub.wifi.id/</span>
            </a>

            <a href="http://insera.telkom.co.id/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm group-hover:text-zinc-200">2. INSERA TELKOM</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">Ticketing</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Pencatatan tiket gangguan nasional Telkom dan koordinasi dispatch ke teknisi lapangan.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">http://insera.telkom.co.id/</span>
            </a>

            <a href="https://wms.wifi.id/wp-wms/" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm group-hover:text-zinc-200">3. WPGEN</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">Provisioning</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Pengaturan SSID, Location ID, status isolir (Bukis), serta reset password akun WMS.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">https://wms.wifi.id/wp-wms/</span>
            </a>

            <div class="p-4 rounded-lg border border-zinc-800 bg-zinc-950">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm">4. WISM / WAC CISCO</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">WLC GUI</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Akses GUI Controller via Mozilla Firefox untuk atur AP Name, High Availability, dan AP Groups.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">https://[IP_NAT]/screens/frameset.html</span>
            </div>

            <a href="https://acs-ibooster.telkom.co.id/index.php" target="_blank" rel="noopener" class="p-4 rounded-lg border border-zinc-800 bg-zinc-950 hover:border-zinc-600 transition-all group">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm group-hover:text-zinc-200">5. ACS I-BOOSTER</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">TR-069</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Remote ONT pelanggan, pastikan Security Type ke Open System, dan verifikasi versi FW.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">acs-ibooster.telkom.co.id</span>
            </a>

            <div class="p-4 rounded-lg border border-zinc-800 bg-zinc-950">
              <div class="flex items-center justify-between mb-2">
                <span class="font-bold text-white text-sm">6. WEB MOJANG</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-zinc-900 text-zinc-400 border border-zinc-800">Rekonsiliasi</span>
              </div>
              <p class="text-xs text-zinc-400 mb-2">Upload rekap harian AP gangguan. User: <code class="text-white">63984</code>, Pass: <code class="text-white">Tif63984</code>.</p>
              <span class="text-[10px] font-mono text-zinc-500 truncate block">http://10.2.113.234:8081</span>
            </div>

          </div>
        </div>

        <!-- Next Tab Nav Button -->
        <div class="pt-6 border-t border-zinc-800 flex justify-end">
          <button onclick="switchTab('tab-ticketing')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 2. Tiketing WiFi.id</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>

      </div>


      <!-- ============================================================== -->
      <!-- TAB 2: TIKETING WIFI-ID & DISPATCH CCAN                        -->
      <!-- ============================================================== -->
      <div id="tab-ticketing" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">2. TIKETING & DISPATCH</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">INCIDENTS</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Tiketing WiFi.id & Dispatch CCAN</h1>
          <p class="text-zinc-400 text-sm">Klasifikasi tiket gangguan operasional pada portal Smarthub dan alur penerusan tiket ke tim CCAN Witel terkait.</p>
        </div>

        <div class="space-y-4">
          $htmlTicketing
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-topologi')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 1. Topologi</span>
          </button>
          <button onclick="switchTab('tab-ganti-ap')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 3. SOP Ganti AP</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 3: SOP GANTI AP & LOGIN WISM                               -->
      <!-- ============================================================== -->
      <div id="tab-ganti-ap" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">3. SOP GANTI AP</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">WLC CISCO</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">SOP Penggantian Unit Access Point (Ganti AP)</h1>
          <p class="text-zinc-400 text-sm">Panduan komprehensif pelurusan data AP lama ke AP baru pada WLC Cisco (WISM), resolusi IP NAT via APEHBOT, dan penyesuaian AP Groups.</p>
        </div>

        <div class="space-y-6">
          $htmlGantiAp
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-ticketing')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 2. Tiketing</span>
          </button>
          <button onclick="switchTab('tab-wp-error')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 4. WP-Error</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 4: WP-ERROR / URL ERROR & PORT LOCATING                    -->
      <!-- ============================================================== -->
      <div id="tab-wp-error" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">4. WP-ERROR / URL ERROR</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">CAPTIVE PORTAL</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Troubleshooting WP-Error / URL Error</h1>
          <p class="text-zinc-400 text-sm">Analisis 3 kasus utama kegagalan pemanggilan landing page login welcome2.wifi.id (ACS Security Type Open System, Mismatch Location-ID/SSID, dan Port Locating X).</p>
        </div>

        <div class="space-y-6">
          $htmlWpError
        </div>

        <div class="pt-6 border-t border-zinc-800">
          <h2 class="text-2xl font-bold text-white mb-2">WP Error Port Locating (X) di ONT</h2>
          <p class="text-zinc-400 text-sm mb-4">Solusi status port locating silang merah pada ONT pelanggan.</p>
          <div class="space-y-4">
            $htmlPortLocating
          </div>
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-ganti-ap')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 3. SOP Ganti AP</span>
          </button>
          <button onclick="switchTab('tab-gpon-ont')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 5. Config GPON & ONT</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 5: CONFIG GPON, TACACS & OPERASIONAL ONT                   -->
      <!-- ============================================================== -->
      <div id="tab-gpon-ont" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">5. CONFIG GPON & ONT</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">OLT TACACS</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Konfigurasi GPON OLT ZTE & Operasional ONT</h1>
          <p class="text-zinc-400 text-sm">Skrip CLI TACACS penggantian unit ONT baru untuk WMS Lite, prosedur buka isolir (Bukis), ubah password, dan monitoring pemakaian klien.</p>
        </div>

        <!-- TACACS Section -->
        <div class="p-6 rounded-xl border border-zinc-800 bg-zinc-950 space-y-4">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Konfigurasi WMS TACACS ONT ZTE Ganti ONT Baru
          </h2>
          <div class="space-y-4">
            $htmlTacacsOnt
          </div>
        </div>

        <!-- Bukis Section -->
        <div class="p-6 rounded-xl border border-zinc-800 bg-zinc-950 space-y-4">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Buka Isolir Pelanggan (Bukis via WPGEN)
          </h2>
          <div class="space-y-4">
            $htmlBukis
          </div>
        </div>

        <!-- Password Section -->
        <div class="p-6 rounded-xl border border-zinc-800 bg-zinc-950 space-y-4">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Cek & Ganti Password WMS
          </h2>
          <div class="space-y-4">
            $htmlPassword
          </div>
        </div>

        <!-- Client Usage Section -->
        <div class="p-6 rounded-xl border border-zinc-800 bg-zinc-950 space-y-4">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Cek Penggunaan Client & Perangkat Terkoneksi
          </h2>
          <div class="space-y-4">
            $htmlClientUsage
          </div>
        </div>

        <!-- SN ONT Section -->
        <div class="p-6 rounded-xl border border-zinc-800 bg-zinc-950 space-y-4">
          <h2 class="text-xl font-bold text-white flex items-center gap-2">
            <span class="text-zinc-400">#</span>
            Cek Serial Number (SN) ONT dari AP-SN di Smarthub
          </h2>
          <div class="space-y-4">
            $htmlSnOnt
          </div>
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-wp-error')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 4. WP-Error</span>
          </button>
          <button onclick="switchTab('tab-mojang')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 6. Rekonsiliasi Mojang</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 6: REKONSILIASI HARIAN MOJANG (EXCEL)                      -->
      <!-- ============================================================== -->
      <div id="tab-mojang" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">6. REKONSILIASI MOJANG</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">EXCEL VLOOKUP</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Panduan Rekonsiliasi Laporan Harian Mojang</h1>
          <p class="text-zinc-400 text-sm">Proses pengolahan data rekapitulasi harian AP gangguan menggunakan Microsoft Excel (VLOOKUP Sugar Report H-1, Inventory Prabac, dan upload Web Mojang).</p>
        </div>

        <div class="space-y-6">
          $htmlMojang
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-gpon-ont')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 5. GPON & ONT</span>
          </button>
          <button onclick="switchTab('tab-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 7. Network Tracing</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 7: NETWORK TRACING VIA CLI                                 -->
      <!-- ============================================================== -->
      <div id="tab-tracing" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">7. NETWORK TRACING CLI</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">WAC & METRO</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Penelusuran Jaringan & Tracing MAC Address</h1>
          <p class="text-zinc-400 text-sm">Penelusuran port switch dan VLAN Access Point secara bertingkat dari WAC Cisco ke Switch Metro Huawei menggunakan SecureCRT / ZOC.</p>
        </div>

        <div class="space-y-6">
          $tracingHtml
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-mojang')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 6. Mojang</span>
          </button>
          <button onclick="switchTab('tab-quick-ops')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Lanjut: 8. Quick SOP</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        </div>
      </div>


      <!-- ============================================================== -->
      <!-- TAB 8: QUICK SOP & INTEGRASI                                   -->
      <!-- ============================================================== -->
      <div id="tab-quick-ops" class="tab-content space-y-8">
        <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
          <div class="flex items-center gap-2 text-xs font-mono text-zinc-400">
            <span class="text-white font-semibold">WIFI-ID NOTES</span>
            <span>/</span>
            <span class="text-zinc-200">8. QUICK SOP & INTEGRASI</span>
          </div>
          <span class="px-2.5 py-0.5 rounded text-[11px] font-mono bg-zinc-900 border border-zinc-800 text-zinc-300">OPERATIONAL</span>
        </div>

        <div>
          <h1 class="text-3xl font-extrabold text-white tracking-tight mb-2">Operational Quick Notes & Integrasi</h1>
          <p class="text-zinc-400 text-sm">Kumpulan catatan ringkas penanganan frekuensi radio, kualitas sinyal, AP gress, pembuatan RSA, dan tiket integrasi.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950 space-y-2">
            <h3 class="text-base font-bold text-white flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-zinc-400"></span>
              Ganti Channel Frekuensi (ACS)
            </h3>
            <p class="text-xs text-zinc-400">Prosedur penggantian kanal radio frekuensi WiFi pada portal ACS i-Booster:</p>
            $htmlGantiChannel
          </div>

          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950 space-y-2">
            <h3 class="text-base font-bold text-white flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-zinc-400"></span>
              Intermitten (OGP)
            </h3>
            <p class="text-xs text-zinc-400">Penanganan kualitas layanan terputus-putus (*intermitten*) via OGP:</p>
            $htmlIntermitten
          </div>

          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950 space-y-2">
            <h3 class="text-base font-bold text-white flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-zinc-400"></span>
              Ganti AP Baru (Gress)
            </h3>
            <p class="text-xs text-zinc-400">Prosedur registrasi unit AP baru gress yang belum memiliki riwayat data:</p>
            $htmlApGress
          </div>

          <div class="p-5 rounded-xl border border-zinc-800 bg-zinc-950 space-y-2">
            <h3 class="text-base font-bold text-white flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-zinc-400"></span>
              Create RSA & Automation
            </h3>
            <p class="text-xs text-zinc-400">Modul otomatisasi pembuatan kredensial RSA untuk teknisi:</p>
            $htmlCreateRsa
            $htmlRsaAuto
          </div>
        </div>

        <!-- Next/Prev Buttons -->
        <div class="pt-6 border-t border-zinc-800 flex justify-between">
          <button onclick="switchTab('tab-tracing')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-900 hover:bg-zinc-800 text-zinc-300 hover:text-white text-xs font-semibold border border-zinc-800 transition-all">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            <span>Kembali: 7. Network Tracing</span>
          </button>
          <button onclick="switchTab('tab-topologi')" class="flex items-center gap-2 px-4 py-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-all">
            <span>Kembali ke Awal: 1. Topologi</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"></path></svg>
          </button>
        </div>
      </div>

      <!-- FOOTER -->
      <footer class="pt-12 pb-16 text-center text-xs font-mono text-zinc-500 border-t border-zinc-900 mt-12">
        <div class="flex items-center justify-center gap-2 mb-2">
          <div class="w-2 h-2 rounded-full bg-white"></div>
          <span class="text-zinc-400 font-semibold">WIFI-ID NOTES &middot; ROC REGIONAL 5</span>
        </div>
        <p>Portal Dokumentasi Operasional Internal &middot; Seluruh 130 tangkapan layar tersimpan lokal &middot; 8 Modul Tab Terpisah</p>
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

  <!-- JAVASCRIPT TAB SWITCHING & LOGIC -->
  <script>
    // Tab switching function
    function switchTab(tabId) {
      // 1. Hide all tab contents
      document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
      });

      // 2. Remove active state from all sidebar buttons
      document.querySelectorAll('.sidebar-btn').forEach(btn => {
        btn.classList.remove('active');
      });

      // 3. Show selected tab
      const targetTab = document.getElementById(tabId);
      if (targetTab) {
        targetTab.classList.add('active');
      }

      // 4. Highlight matching sidebar button
      const activeBtn = document.getElementById('btn-' + tabId);
      if (activeBtn) {
        activeBtn.classList.add('active');
      }

      // 5. Scroll main container to top smoothly
      const mainEl = document.querySelector('main');
      if (mainEl) {
        mainEl.scrollTo({ top: 0, behavior: 'smooth' });
      } else {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }

      // Close mobile sidebar if open
      const sidebar = document.getElementById('sidebar');
      if (!sidebar.classList.contains('-translate-x-full')) {
        sidebar.classList.add('-translate-x-full');
      }

      // Store in URL hash without triggering full scroll
      if (history.pushState) {
        history.pushState(null, null, '#' + tabId);
      }
    }

    // Check URL Hash on Load
    window.addEventListener('DOMContentLoaded', () => {
      const hash = window.location.hash.replace('#', '');
      if (hash && document.getElementById(hash)) {
        switchTab(hash);
      }
    });

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

    // Search Modal
    function openSearchModal() {
      const modal = document.getElementById('search-modal');
      modal.classList.remove('hidden');
      setTimeout(() => document.getElementById('search-input').focus(), 50);
    }

    function closeSearchModal() {
      document.getElementById('search-modal').classList.add('hidden');
    }

    const searchableItems = [
      { tabId: 'tab-topologi', title: 'Topologi WiFi.id Secara Sederhana & Arsitektur Jaringan', tag: 'Topologi' },
      { tabId: 'tab-topologi', title: 'Perbandingan WMS Lite (ONT) vs WMS Reguler (AP Cisco + WLC)', tag: 'Arsitektur' },
      { tabId: 'tab-topologi', title: 'Daftar Portal Utama: Smarthub, Insera, WPGEN, WISM, ACS', tag: 'Tools' },
      { tabId: 'tab-ticketing', title: 'Tiket Reactive AP (AP DOWN / LOSS / Mati)', tag: 'Tiketing' },
      { tabId: 'tab-ticketing', title: 'Tiket Reactive Service (AP Logic Bermasalah)', tag: 'Tiketing' },
      { tabId: 'tab-ticketing', title: 'SOP Order Gangguan ke Tim CCAN Witel via Telegram', tag: 'Dispatch' },
      { tabId: 'tab-ganti-ap', title: 'SOP Ganti AP (Kondisi Sama IP WISM)', tag: 'Ganti AP' },
      { tabId: 'tab-ganti-ap', title: 'Tutorial Login WISM Cisco via Mozilla Firefox & APEHBOT', tag: 'WLC' },
      { tabId: 'tab-ganti-ap', title: 'Pelurusan Data APOSE & WPGEN di Menu Advance WLC', tag: 'Ganti AP' },
      { tabId: 'tab-wp-error', title: 'Kasus 1 WP-Error: ACS Security Type Wajib Open System', tag: 'WP-Error' },
      { tabId: 'tab-wp-error', title: 'Kasus 2 WP-Error: Mismatch Location-ID & SSID di WPGEN', tag: 'WP-Error' },
      { tabId: 'tab-wp-error', title: 'Kasus 3 WP-Error: Format SSID Bertanda Khusus (Kubu_Dharma)', tag: 'WP-Error' },
      { tabId: 'tab-wp-error', title: 'WP Error Port Locating Silang Merah (X) di ONT Pelanggan', tag: 'WP-Error' },
      { tabId: 'tab-gpon-ont', title: 'Config WMS TACACS ONT ZTE Ganti ONT Baru (VLAN 4090 WMS)', tag: 'GPON' },
      { tabId: 'tab-gpon-ont', title: 'Prosedur Buka Isolir Pelanggan (Bukis via WPGEN)', tag: 'Isolir' },
      { tabId: 'tab-gpon-ont', title: 'Cek & Ganti Password Akun/SSID WMS di WPGEN', tag: 'Password' },
      { tabId: 'tab-gpon-ont', title: 'Cek Penggunaan Client & Bandwidth Terbesar di WLC Cisco', tag: 'Monitoring' },
      { tabId: 'tab-gpon-ont', title: 'Cek Serial Number (SN) ONT dari AP-SN di Smarthub', tag: 'Smarthub' },
      { tabId: 'tab-mojang', title: 'Rekonsiliasi Laporan Harian Mojang via Excel (VLOOKUP Sugar & Prabac)', tag: 'Mojang' },
      { tabId: 'tab-tracing', title: 'Tracing MAC Address AP pada WAC Cisco & Switch Metro Huawei', tag: 'CLI Tracing' },
      { tabId: 'tab-quick-ops', title: 'Ganti Channel Frekuensi via ACS i-Booster', tag: 'Radio' },
      { tabId: 'tab-quick-ops', title: 'Troubleshooting Gangguan Intermitten (OGP)', tag: 'Quality' }
    ];

    function performSearch(query) {
      const q = query.toLowerCase().trim();
      const resultsDiv = document.getElementById('search-results');
      if (!q) {
        resultsDiv.innerHTML = '<div class="p-3 text-xs text-zinc-500 text-center font-mono">Ketik kata kunci untuk mencari di seluruh materi...</div>';
        return;
      }

      const matched = searchableItems.filter(s => s.title.toLowerCase().includes(q) || s.tag.toLowerCase().includes(q));
      if (matched.length === 0) {
        resultsDiv.innerHTML = '<div class="p-3 text-xs text-zinc-500 text-center font-mono">Tidak ditemukan hasil untuk "' + query + '"</div>';
        return;
      }

      let html = '';
      matched.forEach(item => {
        html += `
          <button onclick="switchTab('` + item.tabId + `'); closeSearchModal();" class="w-full text-left flex items-center justify-between p-2.5 rounded-lg hover:bg-zinc-900 transition-colors group cursor-pointer">
            <div class="flex items-center gap-2.5">
              <span class="text-xs font-mono px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 group-hover:text-white group-hover:bg-zinc-700">` + item.tag + `</span>
              <span class="text-sm text-zinc-200 group-hover:text-white">` + item.title + `</span>
            </div>
            <svg class="w-4 h-4 text-zinc-600 group-hover:text-zinc-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
          </button>
        `;
      });
      resultsDiv.innerHTML = html;
    }
  </script>
</body>
</html>
"@

[System.IO.File]::WriteAllText("index.html", $fullHtml, [System.Text.Encoding]::UTF8)
Write-Output "SUCCESS! Successfully generated new tabbed index.html with $((Get-Item index.html).Length) bytes."
