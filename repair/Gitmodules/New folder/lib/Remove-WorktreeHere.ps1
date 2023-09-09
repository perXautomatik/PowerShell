function Remove-WorktreeHere {
    param(
        [string]$ConfigPath, # The path of the config file
        [alias]$folder,$toRepair
    )

    # Get the path to the git config file
    $configFile = Join-Path -Path $toRepair -ChildPath "\config"
    
    # Check if it exists
    if (-not (Test-Path $configFile)) {
        Write-Error "Invalid folder path: $toRepair"  
    }
    else
    {
        Remove-Worktree -ConfigPath $toRepair
    }

}
