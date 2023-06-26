
function get-Origin
{
		# Get the remote url of the git repository
		$ref = (git remote get-url origin)

		# Write some information to the console
		Write-Verbos '************************** ref *****************************'
		Write-Verbos $ref.ToString()
		Write-Verbos '************************** ref *****************************'
		return $ref
}

function get-Relative {
	param (
		$path
		,$targetFolder
	)
	Set-Location $path
	$gitRoot = Get-GitRoot

	# Get the relative path of the target folder from the root of the git repository
	return (Resolve-Path -Path $targetFolder.FullName -Relative).TrimStart('.\').Replace('\', '/')

	# Write some information to the console
	Write-Verbos '******************************* bout to read as submodule ****************************************'
	Write-Verbos $relative.ToString()
	Write-Verbos $ref.ToString()
	Write-Verbos '****************************** relative path ****************************************************'

}

	# Define a function to get the root of the git repository
	function Get-GitRoot {
	    (git rev-parse --show-toplevel)
	}

	function git-root {
		$gitrootdir = (git rev-parse --show-toplevel)
		if ($gitrootdir) {
			Set-Location $gitrootdir
		}
		}

	# Define a function to move a folder to a new destination
	function Move-Folder {
	    param (
		[Parameter(Mandatory=$true)][string]$Source,
		[ValidateScript({Test-Path $_})]
		# Check if the destination already exists
		[Parameter(Mandatory=$true, HelpMessage="Enter A empty path to move to")]
		[ValidateScript({!(Test-Path $_)})]
		[string]$Destination
	    )

	    try {
			Move-Item -Path $Source -Destination $Destination -ErrorAction Stop
			Write-Verbos "Moved $Source to $Destination"
	    }
	    catch {
			Write-Warning "Failed to move $Source to $Destination"
			Write-Warning $_.Exception.Message
	    }
	}

	# Define a function to add and absorb a submodule
	function Add-AbsorbSubmodule {
	    param (
		[Parameter(Mandatory=$true)]
		[string]$Ref,

		[Parameter(Mandatory=$true)]
		[string]$Relative
	    )

	    try {
		Git submodule add $Ref $Relative
		git commit -m "as submodule $Relative"
		Git submodule absorbgitdirs $Relative
		Write-Verbos "Added and absorbed submodule $Relative"
	    }
	    catch {
			Write-Warning "Failed to add and absorb submodule $Relative"
			Write-Warning $_.Exception.Message
	    }
	}


	function index-Remove ($name,$path)
	{
		try {
			# Change to the parent path and forget about the files in the target folder
			Set-Location $path
			# Check if the files in the target folder are already ignored by git
			if ((git ls-files --error-unmatch --others --exclude-standard --directory --no-empty-directory -- "$name") -eq "") {
			Write-Warning "The files in $name are already ignored by git"
			}
			else {
			git rm -r --cached $name
			git commit -m "forgot about $name"
			}
		}
		catch {
			Write-Warning "Failed to forget about files in $name"
			Write-Warning $_.Exception.Message
		}
	}

	function about-Repo()
	{

			$vb = ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent -eq $true)

				# Write some information to the console
			Write-Verbos '************************************************************' -Verbose: $vb
			Write-Verbos $targetFolder.ToString() -Verbose: $vb
			Write-Verbos $name.ToString() -Verbose: $vb
			Write-Verbos $path.ToString() -Verbose: $vb
			Write-Verbos $configFile.ToString() -Verbose: $vb
			Write-Verbos '************************************************************'-Verbose: $vb

	}


<#
.SYNOPSIS
Gets the paths of all submodules in a git repository.

.DESCRIPTION
Gets the paths of all submodules in a git repository by parsing the output of git ls-files --stage.

.OUTPUTS
System.String[]
#>
function Get-SubmodulePaths {
    # run git ls-files --stage and filter by mode 160000
    git ls-files --stage | Select-String -Pattern "^160000"

    # loop through each line of output
    foreach ($Line in $Input) {
	# split the line by whitespace and get the last element as the path
	$Line -split "\s+" | Select-Object -Last 1
    }
}

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
function Get-GitDir {
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

<#
.SYNOPSIS
Unsets the core.worktree configuration for a submodule.

.DESCRIPTION
Unsets the core.worktree configuration for a submodule by running git config --local --path --unset core.worktree.

.PARAMETER Path
The path of the submodule.
#>
function Unset-CoreWorktree {
    param (
	[Parameter(Mandatory)]
	[string]$Path
    )

    # run git config --local --path --unset core.worktree for the submodule
    git --work-tree=$Path --git-dir="$Path/.git" config --local --path --unset core.worktree
}

<#
.SYNOPSIS
Hides the .git directory on Windows.

.DESCRIPTION
Hides the .git directory on Windows by running attrib.exe +H /D.

.PARAMETER Path
The path of the submodule.
#>
function Hide-GitDir {
    param (
	[Parameter(Mandatory)]
	[string]$Path
    )

    # check if attrib.exe is available on Windows
    if (Get-Command attrib.exe) {
	# run attrib.exe +H /D to hide the .git directory
	MSYS2_ARG_CONV_EXCL="*" attrib.exe "+H" "/D" "$Path/.git"
    }
}


<# .SYNOPSIS
Lists all the ignored files that are cached in the index.

.DESCRIPTION
This function uses git ls-files with the -c, --ignored and --exclude-standard options to list all the files that are ignored by
Use git ls-files with the -c, --ignored and --exclude-standard options
.gitignore or other exclude files, and also have their content cached in the index. #>
function Get-IgnoredFiles {


git ls-files -s --ignored --exclude-standard -c }


<# .SYNOPSIS
Removes files from the index and the working tree.

.DESCRIPTION
This function takes an array of file names as input and uses git rm to remove them from the index and the working tree.
Define a function that removes files from the index and the working tree
.PARAMETER
 Files An array of file names to be removed. #>
function Remove-Files { param( # Accept an array of file names as input
[string[]]$Files )

#Use git rm with the file names as arguments
git rm $Files --ignore-unmatch }

<# .SYNOPSIS
Rewrites the history of the current branch by removing all the ignored files.

.DESCRIPTION
This function uses git filter-branch with the -f, --index-filter and --prune-empty options to rewrite the history of the current branch by removing all the ignored files from each revision, and also removing any empty commits that result from this operation. It does this by modifying only the index, not the working tree, of each revision.
#Define a function that rewrites the history of the current branch by removing all the ignored files
#Use git filter-branch with the -f, --index-filter and --prune-empty options#>

function Rewrite-History {    # Call the Get-IgnoredFiles function and pipe the output to Remove-Files function

    git filter-branch -f --index-filter {
	Get-IgnoredFiles | Remove-Files
	} --prune-empty }

#Call the Rewrite-History function
<# .SYNOPSIS
Lists all the ignored files that are cached in the index.

.DESCRIPTION
This function uses git ls-files with the -c, --ignored and --exclude-standard options to list all the files that are ignored by
Use git ls-files with the -c, --ignored and --exclude-standard options
.gitignore or other exclude files, and also have their content cached in the index. #>
function Get-IgnoredFiles {


git ls-files -s --ignored --exclude-standard -c }


<# .SYNOPSIS
Removes files from the index and the working tree.

.DESCRIPTION
This function takes an array of file names as input and uses git rm to remove them from the index and the working tree.
Define a function that removes files from the index and the working tree
.PARAMETER
 Files An array of file names to be removed. #>
function Remove-Files { param( # Accept an array of file names as input
[string[]]$Files )

#Use git rm with the file names as arguments
git rm $Files --ignore-unmatch }

<# .SYNOPSIS
Rewrites the history of the current branch by removing all the ignored files.

.DESCRIPTION
This function uses git filter-branch with the -f, --index-filter and --prune-empty options to rewrite the history of the current branch by removing all the ignored files from each revision, and also removing any empty commits that result from this operation. It does this by modifying only the index, not the working tree, of each revision.
#Define a function that rewrites the history of the current branch by removing all the ignored files
#Use git filter-branch with the -f, --index-filter and --prune-empty options#>

function Rewrite-History {    # Call the Get-IgnoredFiles function and pipe the output to Remove-Files function

    git filter-branch -f --index-filter {
	Get-IgnoredFiles | Remove-Files
	} --prune-empty }

#Call the Rewrite-History function Rewrite-History
