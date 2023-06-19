<#
.SYNOPSIS
This script splits a file into multiple files, one for each line of the original file. The new files are named based on the first word of the line, the file extension and the creation or modification date of the original file. The new files are stored in a parent folder specified by the user. The script also checks if the new files already exist or exceed a size limit, and adds a number prefix to avoid conflicts.
#>

function Split-FileLineByLine {
    # Get the input file path, the parent folder path and the size limit as parameters
    param (
        [Parameter(Mandatory=$true)]
        [string]$infile,
        [Parameter(Mandatory=$true)]
        [string]$parentPath,
        [Parameter(Mandatory=$true)]
        [int]$upperBound
    )

    # Check if the input file exists
    if (Test-Path -Path $infile) {
        # Create a stream reader object to read the input file
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $infile

        # Get the file extension and name without extension of the input file
        $ext = [System.IO.Path]::GetExtension($infile)
        $fileName =  [System.IO.Path]::GetFileNameWithoutExtension($infile)

        # Get the creation and modification dates of the input file
        $creatonDate = (Get-Item -Path $infile).CreationTime
        $editDate = (Get-Item -Path $infile).LastWriteTime

        # Use the earlier date as the datum for naming the new files
        $datum = If ($creatonDate -lt $editDate) {$creatonDate} Else {$editDate}

        # Initialize a counter for file name conflicts
        $count = 1

        # Initialize a row number for tracking the lines
        $rownr = 1

        # Loop through each line of the input file
        while (($line = $reader.ReadLine()) -ne $null) {
            # Extract the first word and the whole line from each line using a regular expression
            $line | Select-String -Pattern "^(.*)|(\w{1,10})" |
                ForEach-Object {
                    # Get the values of the captured groups from the match object
                    $content, $simplified = $_.Matches[0].Groups[1..2].Value
                    
                    # Create a custom object with properties for summary, content, date, extension and row number
                    $rowobject = [PSCustomObject] @{
                        Summary = $simplified
                        content = $content
                        date = $datum
                        ext = $ext
                        rowNr = $rownr++
                    }

                    # Create the new file path by joining the parent folder path and a name based on the summary, extension and date
                    $path = Join-Path -Path $parentPath -ChildPath ("{0}-{2}.{1}" -f ($rowobject.Summary,$rowobject.ext,$rowobject.date))

                    # Check if the new file already exists or exceeds the size limit
                    while ((Test-Path -Path $path) -or ((Get-Item -Path $path).Length -ge $upperBound)) {
                        # Add a number prefix to the file name and increment the counter
                        ++$count
                        $path = Join-Path -Path $parentPath -ChildPath ("{0}{1}-{3}.{2}" -f ($count,$rowobject.Summary,$rowobject.ext,$rowobject.date))
                    }

                    # Write the content to the new file
                    Set-Content -Path $path -Value $rowobject.content                    
                }
            }

    # Close the stream reader object
    $reader.Close()
    }
    else {
        # Throw an exception if the input file does not exist
        throw "fileNotFound"
    }
}
