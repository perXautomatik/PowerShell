function Find-Git-Roots {
    <#
.SYNOPSIS
Finds the git roots of the subdirectories under a given path and joins them with the subdirectory names.

.DESCRIPTION
This function finds the git roots of the subdirectories under a given path and joins them with the subdirectory names, using the git rev-parse command and the Linq.Enumerable.Join method. The function exports the results to a csv file and returns an array of joined names.

.PARAMETER BasePath
The path where the subdirectories are located.

.PARAMETER CsvPath
The path of the csv file where the results will be exported.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[string]
	$BasePath,

	[Parameter(Mandatory = $true)]
	[string]
	$CsvPath
    )

    # Redirect the standard error output to standard output for git commands
    [Environment]::SetEnvironmentVariable('GIT_REDIRECT_STDERR', '2>&1', 'Process')

    # Get all the subdirectories under the base path recursively
    $subdirs = Get-ChildItem -Path $BasePath -Recurse -Directory

    # Loop through each subdirectory and find its git root
    $results = foreach ($subdir in $subdirs) {
	# Change the current location to the subdirectory
	Set-Location -Path $subdir.FullName

	# Create a custom object with the subdirectory name, path and git root
	[PSCustomObject]@{
	    FolderName = $subdir.Name
	    path       = $subdir.FullName
	    gitRoot    = (git rev-parse --show-toplevel)
	}
    }

    # Export the results to a csv file
    Export-Git-Roots -Results $results -CsvPath $CsvPath

    # Read the csv file and convert it to an array of objects
    $z = Import-Git-Roots -CsvPath $CsvPath

    # Filter out the objects that have a valid git root and create an array of paths
    [Path[]]$Paths = Filter-Git-Paths -Objects $z

    # Filter out the objects that have a git root equal to their path and create an array of roots
    [Root[]]$Roots = Filter-Git-Roots -Objects $z

    # Define a function to get the name property of an object
    [System.Func[System.Object, string]]$getName = {
	param ($x)
	$x.Name
    }

    # Join the roots and paths by their names and return an array of joined names
    Join-Git-Names -Roots $Roots -Paths $Paths -GetName $getName
}
