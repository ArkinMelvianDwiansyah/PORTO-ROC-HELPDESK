$content = [System.IO.File]::ReadAllText("$PSScriptRoot\index.html", [System.Text.Encoding]::UTF8)
$imgMatches = [System.Text.RegularExpressions.Regex]::Matches($content, "<img\s+src=""assets/images/")
Write-Output "Image count in HTML: $($imgMatches.Count)"
$codeMatches = [System.Text.RegularExpressions.Regex]::Matches($content, "<code id=""code_")
Write-Output "Copyable code blocks in HTML: $($codeMatches.Count)"
$tabPanes = [System.Text.RegularExpressions.Regex]::Matches($content, "class=""tab-pane")
Write-Output "Tab panes count: $($tabPanes.Count)"
