#source: https://devblogs.microsoft.com/scripting/weekend-scripter-playing-around-with-the-windows-powershell-tokenizer/#:~:text=The%20Tokenizer%20is%20used%20to%20break%20a%20Windows,write%20Windows%20PowerShell%20scripts%20that%20explore%20new%20techniques.

$errors = $null
$logpath = “D:\documents\commandlog.txt”

'' > “D:\documents\commandlog.txt”

$scriptText = get-content -Path $historyPath

  [system.management.automation.psparser]::Tokenize($scriptText, [ref]$errors) |
  Foreach-object -Begin {
    “Processing $script” | Out-File -FilePath $logPath -Append } `
  -process { if($_.type -eq “string”)
    { “`t $($_.content)”  } }
| sort {$_.length} | Out-File -FilePath $logpath -Append


notepad $logpath