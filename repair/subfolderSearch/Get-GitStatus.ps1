function Get-GitStatus {

# Define a function to get the git status of a repo path
    <#
    .SYNOPSIS
    Gets the git status of a repo path.

    .DESCRIPTION
    This function takes the repo path and the parent folder of the .git file as parameters and returns the git status as a string.
    It uses git status command to get the status of the repository and captures its output.
    It returns the first two words from the output as the status.

    .PARAMETER RepoPath
    The repo path as a string.

    .PARAMETER ParentFolder
    The parent folder of the .git file as a string.

    .EXAMPLE
    PS C:\> Get-GitStatus "C:\Users\user\.git\modules\project1" "B:\PF\project1"
    On branch

    .EXAMPLE
    PS C:\> Get-GitStatus "C:\Users\user\Documents\project2\.git" "C:\Users\user\Documents\project2"
    fatal: not
    #>

    # Validate the parameters
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ParentFolder
    )

            # Navigate to the ParentFolder using Push-Location cmdlet
            Push-Location $ParentFolder

            # Invoke the git status command and capture its output using Invoke-Expression cmdlet
            $status = Invoke-Expression "git status" 2>&1

            # Pop back to the original location using Pop-Location cmdlet
            Pop-Location

            # Capture the first two words from the status output using split and slice methods
            $status_words = (($status -join '') -split "\s+")[0..1] -join " "

            # Return the status words
            return $status_words
}
