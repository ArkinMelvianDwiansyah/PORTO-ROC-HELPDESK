# Generator for WIFI-ID Documentation Web App
$imgMap = Get-Content -Raw "image_map.json" | ConvertFrom-Json

Write-Output "Building WIFI-ID ROC Documentation Web Portal..."

# Helper function to get image tag
function Get-ImgHtml($blockId, $alt = "Screenshot", $caption = "") {
    $src = $imgMap.$blockId
    if (-not $src) {
        return ""
    }
    $capHtml = if ($caption) { "<div class='text-xs text-zinc-400 mt-2 px-1 flex items-center gap-1.5'><svg class='w-3.5 h-3.5 text-zinc-500' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg><span>$caption</span></div>" } else { "" }
    
    return @"
    <div class="my-4 group">
      <div class="relative overflow-hidden rounded-lg border border-zinc-800 bg-zinc-950 p-1.5 transition-all hover:border-zinc-600">
        <img src="$src" alt="$alt" loading="lazy" class="w-full max-h-[520px] object-contain rounded cursor-zoom-in transition-transform duration-200 group-hover:scale-[1.005]" onclick="openLightbox('$src', '$alt')" />
        <div class="absolute top-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-900/90 text-zinc-300 text-xs px-2.5 py-1 rounded-md border border-zinc-700 pointer-events-none flex items-center gap-1 backdrop-blur-sm">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v6m3-3H7"></path></svg>
          Klik untuk perbesar
        </div>
      </div>
      $capHtml
    </div>
"@
}

# Let's map key image blocks to exact sections
# We'll generate a rich, clean index.html
