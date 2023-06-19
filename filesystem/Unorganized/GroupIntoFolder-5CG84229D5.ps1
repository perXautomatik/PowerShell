<#
.SYNOPSIS
Create a folder for each file extension and move the files to the corresponding folder.

.DESCRIPTION
This script takes one parameter: the path to the folder that contains the files to organize. It then uses the Get-ChildItem cmdlet to get the list of files in the folder and groups them by their extension using the Group-Object cmdlet. It then creates a new folder for each extension and moves the files with that extension to that folder using the New-Item and Move-Item cmdlets.

.PARAMETER Path
The path to the folder that contains the files to organize.

.EXAMPLE
PS C:\> .\organize-files-by-extension.ps1 -Path 'C:\Users\user\Documents'

This example creates a folder for each file extension in the 'C:\Users\user\Documents' folder and moves the files to the corresponding folder.
#>

# Define a function to create a folder for each file extension and move the files to the corresponding folder
function Organize-FilesByExtension {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Get the list of files in the folder and group them by their extension
    $files = Get-ChildItem -Path $Path -File | Group-Object -Property Extension -AsHashTable

    # Loop through each extension group
    foreach ($extension in $files.Keys) {

        # Create a new folder with the extension name (without the dot)
        $folder = New-Item -Type Directory -Name $extension.TrimStart('.')

        # Move the files with that extension to the new folder
        Move-Item -Path $files[$extension] -Destination $folder
    }
}

# Call the function with the parameter from the command line
Organize-FilesByExtension -Path $Path

#EOF
