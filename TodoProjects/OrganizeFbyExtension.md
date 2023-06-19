# This function takes a folder path as a parameter and creates subfolders for each file extension found in the folder. Then, it moves the files to their respective subfolders based on their extensions.
function Organize-FilesByExtension {
    # Define a synopsis for the function
    <#
    .SYNOPSIS
    Organizes the files inside a folder by their extensions.

    .DESCRIPTION
    This function creates subfolders for each file extension found in the folder and moves the files to their respective subfolders.

    .PARAMETER FolderPath
    The path of the folder to be organized.

    .EXAMPLE
    Organize-FilesByExtension -FolderPath "C:\Users\Documents"
    This example organizes the files in the Documents folder by their extensions.
    #>

    # Declare the parameter for the function
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )

    # Check if the folder path is valid
    if (Test-Path $FolderPath) {
        # Get all the files in the folder
        $Files = Get-ChildItem $FolderPath -File

        # Loop through each file
        foreach ($File in $Files) {
            # Get the file extension
            $Extension = $File.Extension

            # Check if the extension is not empty
            if ($Extension) {
                # Remove the dot from the extension
                $Extension = $Extension.TrimStart(".")

                # Create a subfolder name based on the extension
                $SubFolderName = "$FolderPath\$Extension"

                # Check if the subfolder does not exist
                if (-not (Test-Path $SubFolderName)) {
                    # Create the subfolder
                    New-Item -Path $SubFolderName -ItemType Directory
                }

                # Move the file to the subfolder
                Move-Item -Path $File.FullName -Destination $SubFolderName
            }
        }
    }
    else {
        # Write an error message if the folder path is invalid
        Write-Error "The folder path '$FolderPath' does not exist."
    }
}
