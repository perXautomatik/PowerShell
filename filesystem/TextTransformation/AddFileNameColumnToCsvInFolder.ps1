<#
.SYNOPSIS
Add the file name as a new column to each CSV file in the current directory.

.DESCRIPTION
This script scans the current directory for CSV files and imports them using a semicolon as a delimiter. It then adds a new column called "FileName" to each row of the CSV file, containing the name of the file. It then exports the modified CSV file back to the same location, using the same delimiter and encoding.

.PARAMETER TraceLevel
The level of tracing to enable for debugging purposes. The default value is 2.

.EXAMPLE
PS C:\> Add-FileNameColumn -TraceLevel 1

This example scans the current directory for CSV files and adds the file name as a new column to each file, using trace level 1 for debugging.
#>

function Add-FileNameColumn {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int]$TraceLevel = 2
    )

    # Enable tracing for debugging
    Set-PSDebug -Trace $TraceLevel

    # Get the list of CSV files in the current directory
    $files = Get-ChildItem -Filter *.csv

    # Loop through each file
    foreach ($file in $files) {

        # Import the CSV file using semicolon as a delimiter
        $input = Import-Csv -Delimiter ';' $file

        # Loop through each row of the CSV file
        ForEach ($line in $input) {
            # Add a new column called "FileName" with the value of the file name
            Add-Member -InputObject $line -NotePropertyName "FileName" -NotePropertyValue $file.Name
        }

        # Output the modified CSV file to the pipeline
        $input

        # Export the modified CSV file back to the same location, using semicolon as a delimiter and Unicode encoding
        $input | Export-Csv -Delimiter ';' $file.FullName -NoTypeInformation -Encoding Unicode 
    }
}
