<#
.SYNOPSIS
Convert the encoding of MB files in a given directory to UTF-8.

.DESCRIPTION
This script takes one parameter: the path to the directory that contains MB files. It then changes the current directory to that path and gets the list of MB files. It then loops through each file and converts its encoding to UTF-8 by reading and writing its content.

.PARAMETER DirectoryPath
The path to the directory that contains MB files.

.EXAMPLE
PS C:\> Convert-MBEncoding -DirectoryPath 'C:\Users\crbk01\OneDrive - Region Gotland\Till Github\Mapinfo\MapInfoTabToCsv'

This example converts the encoding of MB files in the 'C:\Users\crbk01\OneDrive - Region Gotland\Till Github\Mapinfo\MapInfoTabToCsv' directory to UTF-8.
#>

function Convert-MBEncoding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )

    # Change the current directory to the given path
    cd $DirectoryPath

    # Get the list of MB files in the current directory
    $files = Get-ChildItem -Filter *.mb

    # Loop through each file
    foreach ($file in $files) {

        # Convert the encoding of the file to UTF-8 by reading and writing its content
        Set-Content -Path $file -Encoding UTF8 -Value (Get-Content -Path $file)
    }
}
