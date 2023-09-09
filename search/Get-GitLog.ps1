function Get-GitLog {


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
    param(
        [Parameter(Mandatory=$true)]
        [string]$Date,

        [Parameter(Mandatory=$true)]
        [string]$SearchString
    )

    # Get the log of all Git branches before the date and filter by the search string
    git log --all --before $Date -G $SearchString
}
