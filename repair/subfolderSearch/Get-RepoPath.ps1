function Get-RepoPath {

# Define a function to extract the path to the git repository from the content of a .git file
    <#
    .SYNOPSIS
    Extracts the path to the git repository from the content of a .git file.

    .DESCRIPTION
    This function takes the content of a .git file as a parameter and returns the path to the git repository.
    It assumes that the content starts with "gitdir:" followed by the relative or absolute path to the repository.
    If the path is relative, it converts it to an absolute path using System.IO.Path.GetFullPath method.

    .PARAMETER Content
    The content of a .git file as a string.

    .EXAMPLE
    PS C:\> Get-RepoPath "gitdir: ../.git/modules/project1"
    C:\Users\user\.git\modules\project1

    .EXAMPLE
    PS C:\> Get-RepoPath "gitdir: C:\Users\user\Documents\project2\.git"
    C:\Users\user\Documents\project2\.git
    #>

    # Validate the parameter
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Content
    )

    # Define a regular expression to match the gitdir prefix
    $regex = "^gitdir:"

    # Check if the content matches the regex
    if ($Content -match $regex) {
        # Extract the path to the git repository
            $rp = ($Content -replace "$regex\s*")

            # Check if the rp is not empty
            if ($rp) {
                # Check if the rp is a valid path
                try {
                    # Try to get the full path of the rp using System.IO.Path.GetFullPath method
                    $repo_path = [System.IO.Path]::GetFullPath($rp)
                }
                catch {
                    # Catch any exception and throw an error
                    throw "Invalid path. The path '$rp' is not a valid path."
                }
            }
            else {
                # Throw an error if the rp is empty
                throw "Empty path. The content must contain a non-empty path after 'gitdir:'."
            }


        # Return the repo_path
        
        return $repo_path
    }
    else {
        # The content does not match the regex, throw an error
        throw "Invalid content. The content must start with 'gitdir:' followed by the path to the git repository."
    }


}
