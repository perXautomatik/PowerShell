$from = 'B:\Users\chris\Documents\My Games\Roaming\'
$to = 'C:\Users\chris\AppData\Roaming\'

Get-ChildItem $from -Directory | %{ $toX = $to + $_.name ; junction.exe $toX $_.FullName }

