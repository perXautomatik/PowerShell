function Remove-Worktree {
 
 # Define a function to remove the worktree from a config file
    param(
        [string]$ConfigPath # The path of the config file
    )
    if(Test-Package "Get-IniContent")
    {
        # Get the content of the config file as an ini object
        $iniContent = Get-IniContent -FilePath $ConfigPath
        # Remove the worktree property from the core section
        $iniContent.core.Remove("worktree")
        # Write the ini object back to the config file
        $iniContent | Out-IniFile -FilePath $ConfigPath -Force  
    }
    else
    {
        # Read the config file content as an array of lines
        $configLines = Get-Content -Path $ConfigPath

        # Filter out the lines that contain worktree
        $newConfigLines = $configLines | Where-Object { $_ -notmatch "worktree" }

        if (($configLines | Where-Object { $_ -match "worktree" }))
        {
            # Write the new config file content
            Set-Content -Path $ConfigPath -Value $newConfigLines -Force
        }
    }
}
