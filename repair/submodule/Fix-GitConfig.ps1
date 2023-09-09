function Fix-GitConfig {

# A function to fix the worktree setting in a .git config file
    param (
        [System.IO.DirectoryInfo]$folder
    )

    # Get the path to the git config file
                $configFile = Join-Path -Path $toRepair -ChildPath "\config"
        
    # Check if the config file exists
    if (-not (Test-Path $configFile)) {
                  Write-Error "Invalid folder path: $toRepair"  
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
