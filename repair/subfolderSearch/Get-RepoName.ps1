function Get-RepoName {

# Define a function to get the repo name from the repo path
    <#
    .SYNOPSIS
    Gets the repo name from the repo path.

    .DESCRIPTION
    This function takes the repo path as a parameter and returns the repo name.
    It uses Split-Path cmdlet to get the last part of the repo path as the repo name.
    If the repo name is ".git", it uses Split-Path cmdlet again to get the parent folder name as the repo name.

    .PARAMETER RepoPath
    The repo path as a string.

    .EXAMPLE
    PS C:\> Get-RepoName "C:\Users\user\.git\modules\project1"
    project1

    .EXAMPLE
    PS C:\> Get-RepoName "C:\Users\user\Documents\project2\.git"
    project2
    #>

    # Validate the parameter
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$RepoPath
    )

    
        # Get the last part of the repo path as the repo name using Split-Path cmdlet
        $repoName = Split-Path $RepoPath -Leaf

        # Check if the repo name is ".git"
        if($repoName -eq ".git")
        {
            # Get the parent folder name as the repo name using Split-Path cmdlet
            $repoName = Split-Path (Split-Path $RepoPath -Parent) -Leaf
        }

        # Return the repo name
        
        return $repoName
    
}
