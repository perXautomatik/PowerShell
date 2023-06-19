<#
.SYNOPSIS
Insert the content of SQL files into another file based on the line endings.

.DESCRIPTION
This script takes two parameters: the path to the input file and the path to the output file. It then gets the current location and the folder name. It then gets the list of SQL files in the current location and extracts their names without extensions. It then reads the content of the input file and looks for lines ending with a colon (:). For each line, it gets the line number and the text before the colon. It then checks if there is a SQL file with the same name as the text. If so, it reads the content of the SQL file and inserts it into the output file under the line. If not, it writes an error message to the output file. It then repeats this process for all lines ending with a colon. If there are no SQL files or no lines ending with a colon, it writes an error message to the output file.

.PARAMETER InputFile
The path to the input file that contains the lines ending with a colon.

.PARAMETER OutputFile
The path to the output file that will contain the inserted SQL files.

.EXAMPLE
PS C:\> .\insert-sql-files.ps1 -InputFile "C:\Users\user\Documents\input.txt" -OutputFile "C:\Users\user\Documents\output.txt"

This example inserts the content of SQL files in the current location into another file based on the line endings in "C:\Users\user\Documents\input.txt" and writes the result to "C:\Users\user\Documents\output.txt".
#>

# Define a function to insert the content of SQL files into another file based on the line endings
function Insert-SqlFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        [Parameter(Mandatory=$true)]
        [string]$OutputFile
    )

    # Get the current location and the folder name
    $currentLocation = Get-Location
    $folderName = Split-Path $currentLocation -Leaf

    # Get the list of SQL files in the current location and extract their names without extensions
    $fileNames = $currentLocation | Get-ChildItem -Path .\ -Filter *.sql -File -Name | ForEach-Object {
        [System.IO.Path]::GetFileNameWithoutExtension($_)
    }

    # Check if there are any SQL files in the current location
    if ($fileNames) {

        # Read the content of the input file and look for lines ending with a colon (:)
        $filters = ":"
        $lineNames = Get-Content $InputFile | Select-String -Pattern $filters

        # Check if there are any lines ending with a colon in the input file
        if ($lineNames) {

            # Loop through each line ending with a colon
            foreach ($lineName in $lineNames) {

                # Get the line number and the text before the colon
                $lineNumber = $lineName.LineNumber
                $textBeforeColon = $lineName.Line.Split(':')[0]

                # Check if there is a SQL file with the same name as the text before the colon
                if ($fileNames -contains $textBeforeColon) {

                    # Read the content of the SQL file and insert it into the output file under the line
                    $sqlFileContent = Get-Content "$currentLocation\$textBeforeColon.sql"
                    Add-Content -Path $OutputFile -Value "$($lineName.Line)`n$sqlFileContent"
                }
                else {

                    # Write an error message to the output file
                    Add-Content -Path $OutputFile -Value "$($lineName.Line)`nERROR: No SQL file found with name '$textBeforeColon'"
                }
            }
        }
        else {

            # Write an error message to the output file
            Add-Content -Path $OutputFile -Value "ERROR: No lines ending with ':' found in '$InputFile'"
        }
    }
    else {

        # Write an error message to the output file
        Add-Content -Path $OutputFile -Value "ERROR: No SQL files found in '$currentLocation'"
    }
}

# Call the function with the parameters from the command line
Insert-SqlFiles -InputFile $InputFile -OutputFile $OutputFile

#EOF
