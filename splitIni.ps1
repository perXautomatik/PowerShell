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


$from = "C:\temp\large_log.txt"
$rootName = "C:\temp\large_log_chunk"
$ext = "txt"
$upperBound = 100MB


$fromFile = [io.file]::OpenRead($from)
$buff = new-object byte[] $upperBound
$count = $idx = 0
try {
    do {
        "Reading $upperBound"
        $count = $fromFile.Read($buff, 0, $buff.Length)
        if ($count -gt 0) {
            $to = "{0}.{1}.{2}" -f ($rootName, $idx, $ext)
            $toFile = [io.file]::OpenWrite($to)
            try {
                "Writing $count to $to"
                $tofile.Write($buff, 0, $count)
            } finally {
                $tofile.Close()
            }
        }
        $idx ++
    } while ($count -gt 0)
}
finally {
    $fromFile.Close()
}

# variable used to store the path of the source CSV file
$sourceCSV = <path of source CSV> ;

# variable used to advance the number of the row from which the export starts
$startrow = 0 ;

# counter used in names of resulting CSV files
$counter = 1 ;

# setting the while loop to continue as long as the value of the $startrow variable is smaller than the number of rows in your source CSV file
while ($startrow -lt <total number of rows in source CSV>)
{

# import of however many rows you want the resulting CSV to contain starting from the $startrow position and export of the imported content to a new file
Import-CSV $sourceCSV | select-object -skip $startrow -first <number of rows in resulting CSV> | Export-CSV "<resulting CSV filepath>$($counter).csv" -NoClobber;

# advancing the number of the row from which the export starts
$startrow += <number of rows in resulting CSV> ;

# incrementing the $counter variable
$counter++ ;

}