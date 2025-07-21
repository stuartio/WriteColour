Get-ChildItem $PSScriptRoot/Functions -Recurse -Filter *.ps1 | ForEach-Object { . $_.FullName }
$Colours = Get-Content "$PSScriptRoot/data/colours.json" | ConvertFrom-Json