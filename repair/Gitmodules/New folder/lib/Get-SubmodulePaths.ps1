function Get-SubmodulePaths {


<#
.SYNOPSIS
Gets the paths of all submodules in a git repository.
.DESCRIPTION
Gets the paths of all submodules in a git repository by parsing the output of git ls-files --stage.

.OUTPUTS
System.String[]
#>
    # run git ls-files --stage and filter by mode 160000
    git ls-files --stage | Select-String -Pattern "^160000"

    # loop through each line of output
    foreach ($Line in $Input) {
	# split the line by whitespace and get the last element as the path
	$Line -split "\s+" | Select-Object -Last 1
    }
}
