function Export-Git-Roots {
    
<#
.SYNOPSIS
Exports an array of custom objects with folder name, path and git root to a csv file.

.DESCRIPTION
This function exports an array of custom objects with folder name, path and git root to a csv file, using the ConvertTo-Csv and Out-File cmdlets.

.PARAMETER Results
The array of custom objects to export.

.PARAMETER CsvPath
The path of the csv file where the results will be exported.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[PSCustomObject[]]
	$Results,

	[Parameter(Mandatory = $true)]
	[string]
	$CsvPath
    )

    # Export the results to a csv file
    $Results | ConvertTo-Csv | Out-File -Path $CsvPath
}
