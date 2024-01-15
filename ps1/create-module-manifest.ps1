function Create-ModuleManifest {
    [CmdletBinding()]
    param (
        # Path to a ps1 or psm1 file
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_ -PathType Leaf})]
        [string]
        $Path
    )

    # Get the file extension of the path
    $extension = [System.IO.Path]::GetExtension($Path)

    # Check if the extension is ps1
    if ($extension -eq ".ps1") {
        # Rename the file to have a psm1 extension
        $newPath = $Path -replace ".ps1$", ".psm1"
        Rename-Item -Path $Path -NewName $newPath

        # Update the path variable
        $Path = $newPath
    }
    # Check if the extension is psm1
    elseif ($extension -ne ".psm1") {
        # Throw an error
        throw "The path must point to a ps1 or psm1 file."
    }

    # Initialize an empty hash table for the manifest values
    $manifestValues = @{}

    # Get the file name of the path without the extension
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

    # Get the folder path of the path
    $folderPath = Split-Path -Path $Path -Parent

    # Check if there is a psd1 file with the same name as the psm1 file in the same folder
    $psd1Path = Join-Path -Path $folderPath -ChildPath "$fileName.psd1"
    if (Test-Path -Path $psd1Path) {
        # Read the existing psd1 file and store its values in the hash table
        $manifestValues = Import-PowerShellDataFile -Path $psd1Path
    }

    # Check if the psm1 file resides in a git repository
    $gitPath = Join-Path -Path $folderPath -ChildPath ".git"
    if (Test-Path -Path $gitPath) {
        # Use the git command to get the number of commits that affect the file in the current branch
        $commitCount = git rev-list --count HEAD -- $Path

        # Increment the commit count by 1
        $commitCount++

        # Use the commit count as the module version, unless the existing psd1 file already has a module version value
        if (-not $manifestValues.ContainsKey("ModuleVersion")) {
            $manifestValues["ModuleVersion"] = $commitCount
        }
    }

    # Call the New-ModuleManifest cmdlet with the updated path and the hash table of values, and return the resulting module manifest object
    New-ModuleManifest -Path $Path @manifestValues -PassThru
}

