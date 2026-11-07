# Complete HTML Builder for WIFI-ID Documentation
$blocks = Get-Content -Raw "all_blocks_complete.json" | ConvertFrom-Json
$imgMap = Get-Content -Raw "image_map.json" | ConvertFrom-Json

$blockMap = @{}
foreach ($prop in $blocks.psobject.properties) {
    $blockMap[$prop.Name] = $prop.Value
}

Write-Output "Loaded $($blockMap.Count) blocks and $((Get-Member -InputObject $imgMap -MemberType NoteProperty).Count) images."

# Helper function for RichText to HTML
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

# Helper to render a block into HTML
function Render-Block-To-Html($id, [System.Collections.Generic.List[string]]$htmlList, $visited, $sectionId) {
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
            $htmlList.Add("<h2 class='text-xl font-bold text-white mt-8 mb-3 pb-2 border-b border-zinc-800/80 flex items-center gap-2'>$rawText</h2>")
        }
        "sub_header" {
            $htmlList.Add("<h3 class='text-lg font-semibold text-zinc-100 mt-6 mb-2.5 flex items-center gap-2'>$rawText</h3>")
        }
        "sub_sub_header" {
            $htmlList.Add("<h4 class='text-sm font-semibold uppercase tracking-wider text-zinc-400 mt-5 mb-2'>$rawText</h4>")
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
            $htmlList.Add("<div class='my-4 p-4 rounded-lg bg-zinc-900/80 border border-zinc-800 text-sm text-zinc-300 flex items-start gap-3'><div class='text-lg shrink-0 mt-0.5'>$icon</div><div class='flex-1 leading-relaxed'>$rawText</div></div>")
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
    <button onclick="copyCode('$codeId')" class="flex items-center gap-1.5 px-2 py-1 rounded hover:bg-zinc-800 text-zinc-400 hover:text-white transition-all text-[11px] font-mono cursor-pointer border border-transparent hover:border-zinc-700">
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
            Render-Block-To-Html $childId $htmlList $visited $sectionId
        }
    }
}

Write-Output "Helper functions defined."
