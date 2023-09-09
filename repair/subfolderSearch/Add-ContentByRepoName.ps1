function Add-ContentByRepoName {

# Define a function to add or update the hashtable with the content by repo name
    <#
    .SYNOPSIS
    Adds or updates the hashtable with the content by repo name.

    .DESCRIPTION
    This function takes a result object, a hashtable, and a regex as parameters and adds or updates the hashtable with the content by repo name.
    It uses Get-GitFileContent function to get the content of the git file of the result.
    It uses Test-Path cmdlet to check if the result is successful or not.
    
    .PARAMETER Result
    A result object that contains the properties GitFile, Success, RepoName, and RepoPath.

    .PARAMETER Hashtable
    A hashtable that stores the content by repo name.

    .PARAMETER Regex
    A regular expression that matches the success pattern.

    .EXAMPLE
    PS C:\> Add-ContentByRepoName $result $success_content "fatal"
    
    #>

    # Validate the parameters
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [PSCustomObject]$Result,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [hashtable]$Hashtable,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Regex
    )

    
        # Get the repo name of the result
        $repoName = $Result.RepoName

        # Check if the result is successful or not using Test-Path cmdlet and Regex parameter
        if ((Test-Path $Result.RepoPath -PathType Container) -and $Result.Success -notmatch $Regex) {
            # Get the content of the git file of the result using Get-GitFileContent function
            $content = Get-GitFileContent $Result.GitFile

            # Add or update the hashtable with the content by repo name
            $Hashtable[$repoName] = $content
        }
    
}
