<#
.SYNOPSIS
This script replaces the #include statements in cpp files with double quotes around the file name. For example, #include <foo/bar.h> becomes "bar.h".
#>

function Replace-IncludeStatements {
    # Get the folder path and the file extension as parameters
    param (
        [Parameter(Mandatory=$true)]
        [string]$folderPath,
        [Parameter(Mandatory=$true)]
        [string]$fileExtension
    )

    # Create a regular expression object that matches the #include statements and captures the file name
    [RegEx]$Search = '(?<=#include ).*\/([^>]+)>'

    # Create a replacement string that adds double quotes around the file name
    $Replace = '"$1"'

    # Loop through each file in the folder with the given extension recursively
    ForEach ($File in (Get-ChildItem -Path $folderPath -Filter "*.$fileExtension" -Recurse -File)) {
        # Get the content of the file and replace the #include statements with the replacement string
        (Get-Content $File) -Replace $Search,$Replace |
            # Write the modified content back to the file
            Set-Content $File
    }
}

# Example usage
Replace-IncludeStatements -folderPath '.\' -fileExtension 'cpp'
