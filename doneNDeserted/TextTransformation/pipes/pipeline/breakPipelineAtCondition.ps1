function Breakable-Pipeline([ScriptBlock]$ScriptBlock,[System.DateTime]$startDate) {
    
    

do {
        . $ScriptBlock
        Get-Date
} while ($startDate.AddSeconds(5) -gt (Get-Date))
    
}
[System.DateTime]$x = Get-Date
$x
Breakable-Pipeline { 1..10|%{$_;Start-Sleep -Seconds 1} } -startDate $x




1..10 | %{$_;Start-Sleep -Seconds 1;if($_ -eq 6){break}}


[System.DateTime]$startDate = Get-Date
$q = $startDate.AddSeconds(5)
1..10 |%{$_;Start-Sleep -Seconds 1} | %{$_;if($q -le (Get-Date)){break}}


