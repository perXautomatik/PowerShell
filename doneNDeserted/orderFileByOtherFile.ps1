

#sort list by order of other list

function Sort-byOrderOf () {


}

$pathToBeOrdered = 
'C:\Users\chris\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
$refencePath = 
'C:\Users\chris\AppData\Local\Temp\TortoiseGit\ConsoleHost_history-613cc802.000.txt'

$byteArray = Get-Content -Path $refencePath -Raw

#Get-Member -InputObject $bytearray


Get-Content $pathToBeOrdered | Sort-Object -Property @{expr={$byteArray.IndexOf($_)}; desc=$false} | Set-Content $pathToBeOrdered


