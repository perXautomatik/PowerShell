<#
.SYNOPSIS
This script renames each subfolder of the schoolProjects folder by adding a prefix that is the most common file extension in that subfolder.
#>

function Rename-Subfolders {
    # Get the subfolders of the schoolProjects folder
    $dir = Get-ChildItem -Path "E:\Programming(projects)\programming and lessons\schoolProjects" -Directory

    # Loop through each subfolder
    foreach ($oldName in $dir) {
        # Get the full name of the subfolder
        $oldName = $oldName.FullName
        # Get the most common file extension in the subfolder
        $prefix = (Get-ChildItem -Path $oldName -Recurse -File | Group-Object -Property Extension -NoElement | Sort-Object -Property Count -Descending | Select-Object -Property Name -First 1).Name
        
        Write-Host $prefix

        # Get the leaf name of the subfolder
        $newName = ($oldName | Split-Path -Leaf)
        # Add the prefix to the leaf name
        $newName = "$prefix $newName"
        
        # Rename the subfolder with the new name
        Rename-Item -Path $oldName -NewName $newName
    }
}
