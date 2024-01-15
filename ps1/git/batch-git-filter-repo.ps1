<#
The first function, “batch-git-filter-repo-filter”, will create a temporary file “to_remove.txt” with the paths that you want to filter from your git repository history. The function will accept pipeline input for the paths, and optionally for the branch or tag name and the force flag. The function will then invoke the git filter-repo command with the “–paths-from-file” and “–invert-paths” flags, and the optional parameters. The function will also delete the temporary file after the command is executed.

The second function, “batch-git-filter-rename”, will create a temporary file “to_rename.txt” with the source and destination paths that you want to rename in your git repository history. The function will accept pipeline input for the paths, and optionally for the branch or tag name and the force flag. The function will then invoke the git filter-repo command with the “–paths-from-file” flag, and the optional parameters. The function will also delete the temporary file after the command is executed.

Here are the two functions:
#>

function batch-git-filter-repo-filter {
    [CmdletBinding()]
    param (
        # Paths to filter from the repository history
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Paths,

        # Branch or tag name to filter
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Ref,

        # Force flag to overwrite the existing history
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $Force
    )

    begin {
        # Get the temp folder path
        $tempFolder = $env:Temp

        # Define the name of the temporary file
        $tempFileName = "to_remove.txt"

        # Join the temp folder path with the temporary file name
        $tempFilePath = Join-Path -Path $tempFolder -ChildPath $tempFileName

        # Create a temporary file
        $tempFile = [System.IO.FileInfo]::new($tempFilePath)
        $tempFile.Create().Close()
    }

    process {
        # Append the paths to the temporary file
        foreach ($path in $Paths) {
            Add-Content -Path $tempFilePath -Value $path
        }
    }

    end {
        # Build the command arguments with the temporary file and the optional parameters
        $arguments = @()
        $arguments += "--paths-from-file", $tempFilePath
        $arguments += "--invert-paths"
        if ($Force) { $arguments += "--force" }
        if ($Ref) { $arguments += "--ref", $Ref }

        # Invoke the command with the arguments
        git filter-repo $arguments

        # Delete the temporary file
        Remove-Item -Path $tempFilePath
    }
}

function batch-git-filter-rename {
    [CmdletBinding()]
    param (
        # Source and destination paths to rename in the repository history
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Paths,

        # Branch or tag name to rename
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Ref,

        # Force flag to overwrite the existing history
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $Force
    )

    begin {
        # Get the temp folder path
        $tempFolder = $env:Temp

        # Define the name of the temporary file
        $tempFileName = "to_rename.txt"

        # Join the temp folder path with the temporary file name
        $tempFilePath = Join-Path -Path $tempFolder -ChildPath $tempFileName

        # Create a temporary file
        $tempFile = [System.IO.FileInfo]::new($tempFilePath)
        $tempFile.Create().Close()
    }

    process {
        # Append the paths to the temporary file
        foreach ($path in $Paths) {
            Add-Content -Path $tempFilePath -Value $path
        }
    }

    end {
        # Build the command arguments with the temporary file and the optional parameters
        $arguments = @()
        $arguments += "--paths-from-file", $tempFilePath
        if ($Force) { $arguments += "--force" }
        if ($Ref) { $arguments += "--ref", $Ref }

        # Invoke the command with the arguments
        git filter-repo $arguments

        # Delete the temporary file
        Remove-Item -Path $tempFilePath
    }
}

