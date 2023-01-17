$history = [System.Collections.ArrayList]([System.IO.File]::ReadAllLines((Get-PSReadlineOption).HistorySavePath))
$history.Reverse()

$line = $null
[PSConsoleUtilities.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$null)
if ($line) {
    $history = $history -match [regex]::Escape($line)
}

$command = $history | Get-Unique | Out-GridView -Title "History $line" -PassThru
if ($command) {
    [PSConsoleUtilities.PSConsoleReadLine]::RevertLine()
    [PSConsoleUtilities.PSConsoleReadLine]::Insert(($command -join '; '))
}