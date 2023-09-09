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
                  # Read the config file content as a single string
                  $configContent = Get-Content -LiteralPath $configFile -Raw

                  # Remove any line that contains worktree and store the new content in a variable
                  $newConfigContent = $configContent -Replace "(?m)^.*worktree.*$\r?\n?"

                  # Check if there are any lines to remove
                  if ($configContent -ne $newConfigContent)
                  {
                      # Write the new config file content
                      $newConfigContent | Set-Content -LiteralPath $configFile -Force

                      # Print a message indicating successful removal
                      Write-Output "removed worktree from $configFile"
                  }
    }
}
