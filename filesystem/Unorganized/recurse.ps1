<#
.SYNOPSIS
This script recursively lists the paths of all the files and folders in a given folder, excluding the ones that have the ReparsePoint attribute.
#>

function List-Paths {
    # Get the folder path as a parameter
    param (
        [Parameter(Mandatory=$true)]
        [string]$path
    )

    # Create a filesystemobject com object to access the folder
    $fc = New-Object -ComObject scripting.filesystemobject
    $folder = $fc.getfolder($path)

    # Loop through each file in the folder and output its path
    foreach ($i in $folder.files) { 
        $i | Select-Object -Property Path 
    }

    # Loop through each subfolder in the folder and output its path
    foreach ($i in $folder.subfolders) {
        $i | Select-Object -Property Path

        # Check if the subfolder has the ReparsePoint attribute, which means it is a symbolic link or a mount point
        if ((Get-Item -Path $i.path).Attributes.ToString().Contains("ReparsePoint") -eq $false) {
            # Recursively call the function on the subfolder if it does not have the ReparsePoint attribute
            List-Paths -Path $i.path
        }
    }
}

# Example usage
List-Paths -Path 'C:\Users\crbk01\Desktop'
