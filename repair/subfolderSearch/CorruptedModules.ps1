﻿<#
This code is a PowerShell script that checks the status of git repositories in a given folder and repairs 
them if they are corrupted. It does the following steps:

It defines a begin block that runs once before processing any input. In this block, it sets some variables
 for the modules and folder paths, validates them, and redirects the standard error output of git commands
  to the standard output stream.
It defines a process block that runs for each input object. In this block, it loops through each subfolder
 in the folder path and runs git status on it. If the output is fatal, it means the repository is corrupted 
 and needs to be repaired. To do that, it moves the corresponding module folder from the modules path to the
  subfolder, replacing the existing .git file or folder. Then, it reads the config file of the repository and
   removes any line that contains worktree, which is a setting that can cause problems with scoop. It prints 
   the output of each step to the console.
It defines an end block that runs once after processing all input. In this block, it restores the original
 location of the script.#>                                                        
 
# Define a function that moves the module folder to the repository path, replacing the .git file
function Move-ModuleFolder {
    param (
        [System.IO.FileInfo]$GitFile,
        [string]$ModulesPath
    )

    # Get the corresponding module folder from the modules path
	$ModulesPath | Get-ChildItem -Directory | ? { $_.Name -eq $GitFile.Directory.Name } | 
	Select -First 1 | % {

    # Move the module folder to the repository path, replacing the .git file
    Remove-Item -Path $GitFile -Force
    Move-Item -Path $moduleFolder.FullName -Destination $GitFile -Force
	}
}
 # Define a function that removes the worktree lines from the git config file
function Remove-WorktreeLines {
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
            else
            {
                Write-Error "not a .git folder: $toRepair"
            }

}
# Define a function that checks the status of a git repository and repairs it if needed
function Repair-ScoopGitRepository {
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
      else
      {
        Write-Output @($output)[0]
      }
}

# Define a function that validates the paths, sets the error redirection, and repairs the git repositories in the given folder
function Repair-ScoopGit {
    param (
        # Validate that the modules path exists
        [ValidateScript({Test-Path $_})]
        [string]$ModulesPath,

        # Validate that the folder path exists
        [ValidateScript({Test-Path $_})]
        [string]$FolderPath
    )

    # Redirect the standard error output of git commands to the standard output stream
    $env:GIT_REDIRECT_STDERR = '2>&1'

	# Call the main function with the modules and folder paths as arguments
	Initialize-ScoopGitRepair -ModulesPath $modules -FolderPath $folder

    # Get the list of subfolders in the folder path
    $subfolders = Get-ChildItem -Path $FolderPath -Directory

    # Loop through each subfolder and repair its git repository
    foreach ($subfolder in $subfolders) {
        Write-Output "checking $subfolder"

        # Check if the subfolder has a .git file or folder
        if (Get-ChildItem -Path $subfolder.FullName -Force | Where-Object { $_.Name -eq ".git" }) {
            Repair-ScoopGitRepository -RepositoryPath $subfolder.FullName -ModulesPath $ModulesPath
        }
        else {
            Write-Output "$subfolder not yet initialized"
        }
    }   
}
function fix-CorruptedGitModules {  
    param (
		$folder = "C:\ProgramData\scoop\persist", 
		$modules = "C:\ProgramData\scoop\persist\.git\modules"
)
    begin {
        Push-Location

	    # Validate the arguments
	    if (-not (Test-Path $modules)) { 
	      Write-Error "Invalid modules path: $modules"
	      exit 1
	    }

	    if (-not (Test-Path $folder)) {
	      Write-Error "Invalid folder path: $folder"
	      exit 1
	    }

		Repair-ScoopGit -ModulesPath $modules -FolderPath $folder 
    }
    end
         {
 Pop-Location
    }

}