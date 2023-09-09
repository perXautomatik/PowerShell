function check-gitstatus
 {
 
# Define a function that checks the status of a git repository and repairs it if needed
    param (
        [string]$RepositoryPath,
		[alias]$f
    )

    # Change the current directory to the repository path
      Set-Location $f.FullName
      Write-Output "checking $f"
      if ((Get-ChildItem -force | ?{ $_.name -eq ".git" } ))
      {
    # Run git status and capture the output
    $output = git status

    # Check if the output is fatal, meaning the repository is corrupted
    if ($output -like "fatal*") {
        Write-Output "fatal status for $RepositoryPath"

        # Get the .git file or folder in the repository path
        $f | Get-ChildItem -force |
		 ?{ $_.name -eq ".git" } | % {
        $toRepair = $_
    
        # Check if the .git item is a file
        if ($toRepair -is [System.IO.FileInfo]) {
               $modules | Get-ChildItem -Directory | ?{ $_.name -eq $toRepair.Directory.Name } | select -First 1 | % {
                # Move the folder to the target folder
                rm $toRepair -force ; Move-Item -Path $_.fullname -Destination $toRepair -force }
            }
            else
            {
                Write-Error "not a .git file: $toRepair"
            }

        # Check if the .git item is a folder
        if ($toRepair -is [System.IO.DirectoryInfo]) {
       			Fix-GitConfig -folder $toRepair    
        }
        else {
            Write-Error "not a .git folder: $toRepair"
        }

        }
    }
    else {
        Write-Output @($output)[0]
      }

       }
       else
       {
       Write-Output "$f not yet initialized"
       }

    }
