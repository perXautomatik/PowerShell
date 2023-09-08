function Import-Git-Roots {
    
<#
.SYNOPSIS
Imports an array of custom objects with folder name, path and git root from a csv file.

.DESCRIPTION
This function imports an array of custom objects with folder name, path and git root from a csv file, using the Get-Content and ConvertFrom-Csv cmdlets.

.PARAMETER CsvPath
The path of the csv file where the results are stored.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[string]
	$CsvPath
    )

    # Read the csv file and convert it to an array of objects
    Get-Content -Path $CsvPath | ConvertFrom-Csv
}
