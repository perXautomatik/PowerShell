<#
.SYNOPSIS
This script reads a text file with columns of data, skips the first 12 rows, adds double quotes around the first column, prepends a network path to the first column, and saves the result as a csv file.
#>

function Process-DataFile {
    # Set the input and output file paths
    $inputFile = 'X:\ToDatabase\Files\L D B S E T Tfiles.txt'
    $outputFile = 'X:\ToDatabase\Files\BcompareFileList.efu'

    # Read the input file with tab delimiter and skip the first 12 rows
    $inputx = Import-Csv -Path $inputFile -Delimiter "`t" -Header "Filename","Size","Date Modified","Date Created","Attributes" | Select-Object -Skip 12

    # Add double quotes around the first column
    $outputx = $inputx | ForEach-Object {
        $_.Filename = '"{0}"' -f $_.Filename
        $_
    }

    # Prepend a network path to the first column and export the result as a csv file with comma delimiter
    $outputx | Select-Object @{Label="Filename"; Expression={'\\192.168.0.30\' + $_.Filename}},Size,"Date Modified","Date Created",Attributes | Export-Csv -Path $outputFile -Delimiter ',' -NoTypeInformation
}
