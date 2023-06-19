<#
.SYNOPSIS
This script moves the content of a source folder to a destination folder chosen by the user, and creates a junction link from the source to the destination. It also handles file name conflicts by adding a number suffix to the file name.
#>

function Move-FolderContent {
    # Get the source folder path as a parameter
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputPath
    )

    # Import the Get-Folder function from another script
    . ./GetFolder

    # Get the parent and child names of the source folder
    $src = $inputPath
    $parent = $src | Split-Path
    $child = ($src | Split-Path -Leaf)

    # Ask the user to choose the destination folder and append the child name to it
    $dest = Get-Folder | Join-Path -ChildPath $child

    # Initialize a counter for file name conflicts
    $num = 1

    # Loop through each item in the source folder recursively
    Get-ChildItem -Path $src -Recurse | ForEach-Object {
        
        $item = $_
        # Create the next file name by joining the destination path and the item name
        $nextName = Join-Path -Path $dest -ChildPath $item.Name

        # Check if the next file name already exists in the destination
        while (Test-Path -Path $nextName) {
            # Add a number suffix to the file name and increment the counter
            $nextName = Join-Path -Path $dest -ChildPath ($item.BaseName + "_$num" + $item.Extension)    
            $num += 1   
        }

        # Get the full name of the item
        $fullName = $item.FullName

        # Create the destination folder if it does not exist
        if (-not (Test-Path -Path $dest)) {
            New-Item -ItemType Directory -Path $dest
        }

        # Move the item to the next file name in the destination
        Move-Item -Path $fullName -Destination $nextName
    }

    # Remove the source folder 
    Remove-Item -Path $inputPath 

    # Change the current location to the parent folder
    Set-Location -Path $parent

    # Create a junction link from the source to the destination with the same child name
    New-Item -ItemType Junction -Path $parent -Name $child -Target $dest
}
