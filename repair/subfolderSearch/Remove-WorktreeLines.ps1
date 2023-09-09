function Remove-WorktreeLines {
 # Define a function that removes the worktree lines from the git config file
    param (
        [System.IO.DirectoryInfo]$GitFolder
    )

    # Get the path to the git config file
    $configFile = Join-Path -Path $GitFolder -ChildPath "\config"

    # Check if the config file exists
    if (-not (Test-Path $configFile)) {
        Write-Error "Invalid folder path: $GitFolder"
    }
    else {
        # Read the config file content as an array of lines
        $configLines = Get-Content -Path $configFile

        # Filter out the lines that contain worktree, which is a setting that can cause problems with scoop
        $newConfigLines = $configLines | Where-Object { $_ -notmatch "worktree" }

        # Check if there are any lines that contain worktree
        if ($configLines | Where-Object { $_ -match "worktree" }) {
            # Write the new config file content, removing the worktree lines
            Set-Content -Path $configFile -Value $newConfigLines -Force
        }
    }

            }
