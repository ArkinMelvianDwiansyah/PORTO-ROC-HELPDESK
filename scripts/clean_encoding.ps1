$content = [System.IO.File]::ReadAllText("index.html", [System.Text.Encoding]::UTF8)
$clean = $content.Replace("Â·", "&middot;").Replace("Â»", "&raquo;").Replace("â€œ", "&ldquo;").Replace("â€ ", "&rdquo;").Replace("â€™", "&rsquo;").Replace("â‡’", "&rarr;").Replace("â€¦", "...").Replace("ðŸ˜‰", "&#128521;").Replace("ðŸ¤£", "&#129315;").Replace("ðŸ™ ", "&#128591;")
[System.IO.File]::WriteAllText("index.html", $clean, [System.Text.Encoding]::UTF8)
Write-Output "Cleaned encoding artifacts in index.html."
