#cls #Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser #. '\\100.84.7.151\NetBackup\Project Shelf\ToGit\PowerShellProjectFolder\scripts\TodoProjects\Tokenization.ps1'
<#
.SYNOPSIS
    Searches all Git branches for a given string.

.DESCRIPTION
    The Search-GitAllBranches function uses the git rev-list and git grep commands to find all occurrences of a given string in all Git branches.

.PARAMETER Path
    The path to the Git repository. The default value is 'D:\Users\crbk01\AppData\Roaming\JetBrains\Datagrip\consolex\db\'.

.PARAMETER Match
    The string to search for in all Git branches.

.PARAMETER FileName
    The name of the file to search for in all Git branches. The default value is 'harAnsökan (3).sql'.

.PARAMETER Date
    The date before which to search for Git branches. The default value is "2020-03-02".

.EXAMPLE
    PS C:\> Search-GitAllBranches -Match "abc"
    Searches all Git branches for the string "abc".

.EXAMPLE
    PS C:\> Search-GitAllBranches -FileName "test.sql"
    Searches all Git branches for the file name "test.sql".
#>
function Search-GitAllBranches {
    param(
	 
        [Parameter(Mandatory=$false,
        ParameterSetName='RepoPath')]
        [string]$Path = 'D:\Users\crbk01\AppData\Roaming\JetBrains\Datagrip\consolex\db\',
		
        [Parameter(Mandatory=$true,
        ParameterSetName='SearchString')]
        [string]$match,

		[Parameter(Mandatory=$false)]
        [string]$fileName = 'harAnsökan (3).sql',   

		[Parameter(Mandatory=$false)]
        [string]$Date = "2020-03-02"
	

    )
 
    # Validate the path parameter
    if (-not (Test-Path $Path)) {
        Write-Error "The path $Path does not exist."
        return
    }

    # Change the current directory to the path
    Push-Location $Path

    # Load the Tokenization.ps1 script
  . '\\100.84.7.151\NetBackup\Project Shelf\ToGit\PowerShellProjectFolder\scripts\TodoProjects\Tokenization.ps1'

<#
.SYNOPSIS
    Gets the first 10 commits from all Git branches.

.DESCRIPTION
    The Get-GitCommits function uses the git rev-list command to get all commits from all Git branches, and then selects the first 10 commits using the Select-Object cmdlet.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    PS C:\> Get-GitCommits
    Gets the first 10 commits from all Git branches.
#>
function Get-GitCommits {
    # Get all commits from all Git branches
    $Commits = (git rev-list --all)

    # Select the first 10 commits
    $Commits | Select-Object -First 10
}

<#
.SYNOPSIS
    Searches for a given string in a given commit.

.DESCRIPTION
    The Search-GitCommit function uses the git grep command to search for a given string in a given commit. It returns the matching line as a string.

.PARAMETER Commit
    The commit ID to search for.

.PARAMETER Match
    The string to search for in the commit.

.EXAMPLE
    PS C:\> Search-GitCommit -Commit "a1b2c3d4" -Match "abc"
    Searches for the string "abc" in the commit "a1b2c3d4" and returns the matching line.
#>
function Search-GitCommit {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Commit,

        [Parameter(Mandatory=$true)]
        [string]$Match
    )

    # Search for the match string in the commit
    $Result = git grep --ignore-case --word-regexp --fixed-strings -o $Match -- $Commit

    # Split the result by colon and join the last two parts by colon
    $Parts = $Result.Split(':')
    [system.String]::Join(":", $Parts[2..$Parts.length])
}

# Get the first 10 commits from all Git branches
$Commits = Get-GitCommits

# Search for the match string in each commit and store the results in an array
$mytable = @()
foreach ($Commit in $Commits) {
    $mytable += Search-GitCommit -Commit $Commit -Match $match
}   

$regexSearchstring = [Regex]::Escape($searchString)


<#
.SYNOPSIS
    Gets the log of all Git branches before a given date and filters by a given string.

.DESCRIPTION
    The Get-GitLog function uses the git log command to get the log of all Git branches before a given date and filters by a given string using the -G option.

.PARAMETER Date
    The date before which to get the log of Git branches.

.PARAMETER SearchString
    The string to filter the log by.

.EXAMPLE
    PS C:\> Get-GitLog -Date "2020-03-02" -SearchString "abc"
    Gets the log of all Git branches before "2020-03-02" and filters by the string "abc".
#>
function Get-GitLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Date,

        [Parameter(Mandatory=$true)]
        [string]$SearchString
    )

    # Get the log of all Git branches before the date and filter by the search string
    git log --all --before $Date -G $SearchString
}

# Get the log of all Git branches before the date and filter by the search string
Get-GitLog -Date $date -SearchString $searchString

git grep $searchString 

git log --all --oneline --source -- $fileName

 git branch --contains <commit> - to figure out which branch contains the specific sha1


# If you get Argument list too long, you can use 
git rev-list --all | xargs git grep 'abc':

$out = @{}

    $Commits = (git rev-list --all)
$mytable | Measure-Object

git log -G $regexSearchstring

<#
.SYNOPSIS
    Gets the commit IDs of all Git branches before a given date.

.DESCRIPTION
    The Get-GitCommitIDs function uses the git log command to get the commit IDs of all Git branches before a given date using the --pretty=format option.

.PARAMETER Date
    The date before which to get the commit IDs of Git branches.

.EXAMPLE
    PS C:\> Get-GitCommitIDs -Date "2020-03-02"
    Gets the commit IDs of all Git branches before "2020-03-02".
#>
function Get-GitCommitIDs {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Date
    )

    # Get the commit IDs of all Git branches before the date
    git log --all --before $Date --pretty=format:"%H"
}

# Get the commit IDs of all Git branches before the date
$mytable = Get-GitCommitIDs -Date $date

$mytable | Measure-Object
<#
.SYNOPSIS
    Measures the number of commits that contain the search string.

.DESCRIPTION
    The Measure-GitCommitByString function uses the git grep command to count the occurrences of the search string in each commit, and then filters the commits that have at least one occurrence. It then uses the Measure-Object cmdlet to measure the number of commits that match the criteria.

.PARAMETER Commits
    The array of commit IDs to search for.

.PARAMETER SearchString
    The string to search for in each commit.

.EXAMPLE
    PS C:\> Measure-GitCommitByString -Commits $mytable -SearchString "abc"
    Measures the number of commits that contain the string "abc".
#>
function Measure-GitCommitByString {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Commits,

        [Parameter(Mandatory=$true)]
        [string]$SearchString
    )

    # Count the occurrences of the search string in each commit
    $Counts = $Commits | ForEach-Object {
        git grep --ignore-case --word-regexp --fixed-strings --count -o $SearchString -- $_
    }

    # Filter the commits that have at least one occurrence
    $Matches = $Commits | Where-Object {
        $true -eq ($Counts -gt 0)
    }

    # Measure the number of matching commits
    $Matches | Measure-Object
}

# Measure the number of commits that contain the search string
Measure-GitCommitByString -Commits $mytable -SearchString $searchString

$mytable | ? { $true -eq (git log -G $regexSearchstring -- $_)  } | Measure-Object

$mytable | % { git log -p --grep-reflog=$regexSearchstring  $_ } | Measure-Object

# Pipe the events to the ForEach-Object cmdlet.
$mytable | ForEach-Object -Begin {
    # In the Begin block, use Clear-Host to clear the screen.
    Clear-Host
    # Set the $i counter variable to zero.
    $i = 0
    # Set the $out variable to a empty string.
} -Process {
    # In the Process script block search the message property of each incoming object for "bios".    
    $res =  (git grep --ignore-case --word-regexp --fixed-strings -o $seachString -- $_)
    if($res)
    {
        # Append the matching message to the out variable.        
        
        $res 
    }
    # Increment the $i counter variable which is used to create the progress bar.
    $i = $i+1
    # Determine the completion percentage
    $Completed = ($i/$myTable.count*100)
    # Use Write-Progress to output a progress bar.
    # The Activity and Status parameters create the first and second lines of the progress bar
    $Results = $Commits | ForEach-Object {
        git grep --ignore-case --word-regexp --fixed-strings -o $Match -- $_
    }

    # Filter the results by the file name and the date
    $Results = $Results | Where-Object {
        $_ -match $FileName -and (git log --pretty=format:"%ad" --date=short -- $_) -le $Date
    }

    # Write the results to the output
   # heading, respectively.
    Write-Progress -Activity "Searching Events" -Status "Progress:" -PercentComplete $Completed
} -End {
    # Display the matching messages using the out variable.
    Pop-Location
    $out
}

#$out 



Out-Host -Paging ;   does not work in ise
        



  $HashTable=@{}
  foreach($r in $mytable)
  {
     $HashTable[$r]++
  }
  $errors = $null

  $HashTable.GetEnumerator() | Sort-Object -property @{Expression = "value"; Descending = $true},name  | select value, name, @{Expression = TokenizeCode $_ ; Name = "token"

}


