function Repair-Git {
# A function to repair a fatal git status
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
    # Print a message indicating fatal status
    Write-Output "fatal status for $Path"

    # Get the .git file or folder in that path
    $toRepair = Get-ChildItem -Path "$Path\*" -Force | Where-Object { $_.Name -eq ".git" }

    # Check if it is a file or a folder
    if( $toRepair -is [System.IO.FileInfo] )
    {
              # Define parameters for Move-Item cmdlet
        $module = Get-ChildItem -Path $Modules -Directory | Where-Object { $_.Name -eq $toRepair.Directory.Name } | Select-Object -First 1
              $moveParams = @{
                  Path = Join-Path -Path $modules -ChildPath $toRepair.Directory.Name
			      Destination = $toRepair
                  Force = $true
                  PassThru = $true
              }

              # Move the module folder to replace the .git file and return the moved item
        Remove-Item -Path $toRepair -Force   
		
              $movedItem = Move-Item @moveParams
              # Print a message indicating successful move
              Write-Output "moved $($movedItem.Name) to $($movedItem.DirectoryName)"
          }
    elseif( $toRepair -is [System.IO.DirectoryInfo] )
          {
              # Get the path to the git config file
        $configFile = Join-Path -Path $toRepair -ChildPath "\config"
    
              # Check if it exists
              if (-not (Test-Path -LiteralPath $configFile)) {
          Write-Error "Invalid folder path: $toRepair"  
              }
              else
              {
         
	remove-worktree
        }
    }
    else
    {
        # Print an error message if it is not a file or a folder
        Write-Error "not a .git file or folder: $toRepair"
    }
}
