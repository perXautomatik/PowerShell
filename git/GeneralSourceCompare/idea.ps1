<#
.SYNOPSIS
This script takes an array of file paths as input and creates a commit for each file, replacing it if it already exists. The commit message contains the file path, modification, size and date.
#>

function Commit-Files {
    # Get the array of file paths as a parameter
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$files
    )

    # Check if the array is empty
    if ($files.Length -eq 0) {
        Write-Warning "No files were provided."
        return
    }

    # Loop through each file path
    foreach ($file in $files) {
        # Check if the file exists
        if (-not (Test-Path -Path $file)) {
            Write-Warning "The file $file does not exist."
            continue
        }

        # Get the file properties
        $filePath = Resolve-Path -Path $file
        $fileInfo = Get-Item -Path $filePath
        $fileMod = $fileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        $fileSize = $fileInfo.Length

        # Create the commit message
        $commitMessage = "$filePath,$fileMod,$fileSize"

        # Add the file to the staging area, replacing it if it already exists
        git add -f $filePath

        # Commit the file with the commit message
        git commit -m $commitMessage

        # Write a success message
        Write-Host "The file $filePath has been committed."
    }
}
