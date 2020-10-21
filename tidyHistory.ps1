#read all history, 
 #   append current history
  #  write to current history

$history = New-Object System.Collections.ArrayList($null)

$historyFolder = "C:\Users\crbk01\OneDrive - Region Gotland\WindowsPowerShell\PSReadline"
$historyFolder | get-ChildItem | %{$history.addRange([System.IO.File]::ReadAllLines($_.fullname))}


$history.addRange([System.Collections.ArrayList](get-history).commandline)


$history.Reverse()
$line = $null
[PSConsoleUtilities.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$null)
if ($line) {
    $history = $history -match [regex]::Escape($line)
}

$TempFile = New-TemporaryFile

Foreach ($arr in $history | Get-Unique) {
      $arr -join ',' | Add-Content $TempFile
}



import-csv -Path $TempFile | convertto-csv | convertfrom-csv | add-history

 

 #TYPE Microsoft.PowerShell.Commands.HistoryInfo
"Id","CommandLine","ExecutionStatus","StartExecutionTime","EndExecutionTime"


$command = $history | Get-Unique | Out-GridView -Title "History $line" -PassThru
if ($command) {
    [PSConsoleUtilities.PSConsoleReadLine]::RevertLine()
    [PSConsoleUtilities.PSConsoleReadLine]::Insert(($command -join '; '))
}