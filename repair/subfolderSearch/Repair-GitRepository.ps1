function Repair-GitRepository {
# Define a function that checks the status of a git repository and repairs it if needed
    param (
        [string]$RepositoryPath,
        [string]$ModulesPath
    )

    # Change the current directory to the repository path
    Set-Location $RepositoryPath
      Write-Output "checking $RepositoryPath"
	  
      if ((Get-ChildItem -force | ?{ $_.name -eq ".git" } ))
      {
      # Run git status and capture the output
      $output = git status
      
    # Check if the output is fatal, meaning the repository is corrupted
      if(($output -like "fatal*")) { 
        Write-Output "fatal status for $RepositoryPath"

        # Get the .git file or folder in the repository path
		$u = Get-ChildItem -Path $RepositoryPath -Force | ?{ $_.Name -eq ".git" }
        $toRepair = $u

        # Check if the .git item is a file
           if( $toRepair -is [System.IO.FileInfo] )
           {
            Move-ModuleFolder -GitFile $toRepair -ModulesPath $ModulesPath
            }
            else
            {
                Write-Error "not a .git file: $toRepair"
            }

        # Check if the .git item is a folder
            if( $toRepair -is [System.IO.DirectoryInfo] )
            {
            Remove-WorktreeLines -GitFolder $toRepair
                }

            }
            else
            {
                Write-Error "not a .git folder: $toRepair"
            }

        }
      }
