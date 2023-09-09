function Get-GitDir {

<#
.SYNOPSIS
Gets the absolute path of the .git directory for a submodule.

.DESCRIPTION
Gets the absolute path of the .git directory for a submodule by reading the .git file and running git rev-parse --absolute-git-dir.

.PARAMETER Path
The path of the submodule.

.OUTPUTS
System.String
#>
    param (
	[Parameter(Mandatory)]
	[string]$Path
    )

    # read the .git file and get the value after "gitdir: "
    $GitFile = Get-Content -Path "$Path/.git"
    $GitDir = $GitFile -replace "^gitdir: "

    # run git rev-parse --absolute-git-dir to get the absolute path of the .git directory
    git -C $Path rev-parse --absolute-git-dir | Select-Object -First 1
}
