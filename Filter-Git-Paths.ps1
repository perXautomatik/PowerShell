function Filter-Git-Paths {
    
<#
.SYNOPSIS
Filters out the objects that have a valid git root and creates an array of paths.

.DESCRIPTION
This function filters out the objects that have a valid git root and creates an array of paths, using a custom class for paths and a Where-Object filter.

.PARAMETER Objects
The array of custom objects to filter.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[PSCustomObject[]]
	$Objects
    )

    # Define a class for paths
    class Path {
	[string] $Name;
	[string] $path;

	Path($name, $path) {
	    $this.path = $path
	    $this.Name = $name
	}
    }

    # Filter out the objects that have a valid git root and create an array of paths
    [Path[]]$Paths = @($Objects | Where-Object { $_.gitRoot -ne "fatal: this operation must be run in a work tree" } | ForEach-Object { [Path]::new($_.FolderName, $_.path) })
}
