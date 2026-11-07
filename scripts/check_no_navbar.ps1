$content = [System.IO.File]::ReadAllText("$PSScriptRoot\index.html", [System.Text.Encoding]::UTF8)
Write-Output "Has header tag: $($content.Contains('<header'))"
Write-Output "Has tab-pill-btn: $($content.Contains('tab-pill-btn'))"
Write-Output "Has sidebar: $($content.Contains('<!-- LEFT SIDEBAR NAVIGATION'))"
Write-Output "Has search trigger in sidebar: $($content.Contains('Cari materi atau CLI...'))"
Write-Output "Topology image included: $($content.Contains('340bc60a-349d-80f7-8bf2-cbee5f186482.png'))"
$imgMatches = [System.Text.RegularExpressions.Regex]::Matches($content, "<img\s+src=""assets/images/")
Write-Output "Images count: $($imgMatches.Count)"
$tabPanes = [System.Text.RegularExpressions.Regex]::Matches($content, "class=""tab-pane")
Write-Output "Tab panes count: $($tabPanes.Count)"
