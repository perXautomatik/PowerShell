function Get-GitFileContent {
# Define a function to get the content of a .git file
    <#
    .SYNOPSIS
    Gets the content of a .git file.

    .DESCRIPTION
    This function takes the path of a .git file as a parameter and returns its content as a string.
    It uses Get-Content cmdlet to read the file content.

    .PARAMETER GitFile
    The path of a .git file as a string.

    .EXAMPLE
    PS C:\> Get-GitFileContent "B:\PF\project1\.git"
    gitdir: ../.git/modules/project1
    #>

    # Validate the parameter
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$GitFile
    )

    # Check if the GitFile exists and is not a directory
    if (Test-Path $GitFile -PathType Leaf) {
        # Get the content of the GitFile using Get-Content cmdlet
        $content = Get-Content $GitFile

        # Return the content
        return $content
    }
    else {
        # Throw an error if the GitFile does not exist or is a directory
        throw "Invalid file. The GitFile '$GitFile' does not exist or is a directory."
    }
}
