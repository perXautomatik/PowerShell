function remove-worktree
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
