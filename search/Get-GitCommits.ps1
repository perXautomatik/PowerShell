function Get-GitCommits {

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
    # Get all commits from all Git branches
    $Commits = (git rev-list --all)

    # Select the first 10 commits
    $Commits | Select-Object -First 10
}
