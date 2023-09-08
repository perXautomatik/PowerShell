function Join-Git-Names {
    <#
.SYNOPSIS
Joins the roots and paths by their names and returns an array of joined names.

.DESCRIPTION
This function joins the roots and paths by their names and returns an array of joined names, using the Linq.Enumerable.Join method and a function to get the name property of an object.

.PARAMETER Roots
The array of roots to join.

.PARAMETER Paths
The array of paths to join.

.PARAMETER GetName
The function to get the name property of an object.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[Root[]]
	$Roots,

	[Parameter(Mandatory = $true)]
	[Path[]]
	$Paths,

	[Parameter(Mandatory = $true)]
	[System.Func[System.Object, string]]
	$GetName
    )

    # Join the roots and paths by their names and return an array of joined names
    [Linq.Enumerable]::Join($Roots, $Paths, $GetName, $GetName, $GetName)
}
