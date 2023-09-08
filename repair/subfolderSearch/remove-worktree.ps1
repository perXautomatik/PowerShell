function remove-worktree
{
   # Read the config file content as an array of lines
            $configLines = Get-Content -Path $configFile

            # Filter out the lines that contain worktree
            $newConfigLines = $configLines | Where-Object { $_ -notmatch "worktree" }

                  # Check if there are any lines to remove
            if (($configLines | Where-Object { $_ -match "worktree" }))
                  {
                      # Write the new config file content
                Set-Content -Path $configFile -Value $newConfigLines -Force
            }

}
