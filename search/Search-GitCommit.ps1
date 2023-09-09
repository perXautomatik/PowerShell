function Search-GitCommit {

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
