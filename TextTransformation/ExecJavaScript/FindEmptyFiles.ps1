# Finds all empty/blank files and directories

function IsAllZeros($file) {
    $bufferSize = [Math]::Pow(2, 16)
    $stream = [System.IO.File]::OpenRead($file)
    while ($stream.Position -lt $stream.Length) {
        $buffer = new-object Byte[] $bufferSize
        $bytesRead = $stream.Read($buffer, 0, $bufferSize)
        for ($c = 0; $c -lt $bytesRead; $c++) {
            if ($buffer[$c] -ne 0) {
                $stream.Close()
                return $false
            }
        }
    }
    $stream.Close()
    return $true
}

dir -Recurse | % {
     if ($_.PSIsContainer) {
         if ($_.GetFileSystemInfos().Count -eq 0) {
             Write-Output "Empty dir:`t`t$($_.FullName)"
         }
     }
     else {
         if ($_.Length -eq 0 -or (IsAllZeros $_.FullName)) {
             Write-Output "Empty file:`t$($_.Length)`t$($_.FullName)"
         }
     }
 }
 