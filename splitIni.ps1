function Split-Ini ([string]$iniFile) {
    $stream = [System.IO.File]::OpenRead($iniFile)
    $chunkNum = 1
    $barr = New-Object byte[] $bufSize
    $fileinfo = [System.IO.FileInfo]$inFile    
    $dir = $fileinfo.Directory

    begining find []

    end find [] next


    while ($bytesRead = $stream.Read($barr, 0, $bufsize)) {
                
        line[1]
        name = $line[1].substring("[",$_,"]")



        $name = 
        $fileinfo.Name
        
        $outFile = Join-Path $dir "$name.part$chunkNum"
        
        $ostream = [System.IO.File]::OpenWrite($outFile)
        
        $ostream.Write($barr, 0, $bytesRead)
        
        $ostream.Close()
        
        Write-Host "Wrote $outFile"
        
        $chunkNum += 1

    }
    $stream.Close()
}