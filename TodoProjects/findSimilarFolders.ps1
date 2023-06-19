<#
.SYNOPSIS
Flatten a folder tree by moving all files to the top level and deleting empty subfolders.

.DESCRIPTION
This script takes one parameter: the path to the root folder of the folder tree to flatten. It then gets all the subfolders of the root folder and moves all the files inside them to the root folder, overwriting any existing files with the same name. It then deletes all the empty subfolders.

.PARAMETER RootPath
The path to the root folder of the folder tree to flatten.

.EXAMPLE
# Change the current directory to E:
cd E:

# Call the function with the parameter from the command line
Flatten-FolderTree -RootPath $RootPath

PS C:\> .\flatten-folder-tree.ps1 -RootPath 'E:\SteamLibrary\steamapps\common\My Games\Blizzards\backup\ATMA_CONFIG\atma\10 08 30 ATMA_CONFIG\ATMA_CONFIG'

This example flattens the folder tree under 'E:\SteamLibrary\steamapps\common\My Games\Blizzards\backup\ATMA_CONFIG\atma\10 08 30 ATMA_CONFIG\ATMA_CONFIG' by moving all files to that folder and deleting all subfolders.
#>

# Define a function to flatten a folder tree by moving all files to the top level and deleting empty subfolders
function Flatten-FolderTree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )

    # Get all the subfolders of the root folder
    Get-ChildItem -Path $RootPath -Directory | ForEach-Object {

        # $_ now contains the subfolder object

        # Get the full path of the subfolder
        $targetFolder = $_.FullName

        # Get all the paths of the files and subfolders inside the subfolder
        Resolve-Path "$targetFolder\*" | ForEach-Object {

            # $_ here contains the full path of a file or a subfolder

            # Move all the files to the root folder, overwriting any existing files with the same name
            Move-Item -Path "$_\*.*" -Destination $RootPath -Force

            # Delete all the empty subfolders
            Remove-Item -Path $_
        }
    }
}

