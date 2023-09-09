function Get-GitCommitIDs {

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
    param(
        [Parameter(Mandatory=$true)]
        [string]$Date
    )

    # Get the commit IDs of all Git branches before the date
    git log --all --before $Date --pretty=format:"%H"
}
