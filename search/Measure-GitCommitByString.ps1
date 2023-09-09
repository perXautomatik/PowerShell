function Measure-GitCommitByString {
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
