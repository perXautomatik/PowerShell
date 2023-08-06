 #load dependensies

 Get-ChildItem -path B:\GitPs1Module\* -Filter '*.ps1' | % {
 $p = $_
 $fullName = $p.FullName 
 try {
    invoke-expression ". $fullName" -ErrorAction Stop
}
catch {
    Write-Output "could not load $p"
}
}
  # This is the main script that calls the functions
  
<#
.SYNOPSIS
Pushes a subdirectory of a git repository to another repository.

.DESCRIPTION
This function pushes a subdirectory of a git repository to another repository, using the git subtree command. The subdirectory will be filtered out from the original repository and added as a prefix to the destination repository.

.PARAMETER SourceDir
The path of the source directory where the original git repository is located.

.PARAMETER SourceSubdir
The path of the subdirectory within the source directory that will be pushed.

.PARAMETER DestinationDir
The path of the destination directory where the other git repository is located.

.PARAMETER DestinationPrefix
The prefix that will be added to the subdirectory in the destination repository.

function FilterBySubdirectory($baseRepo = 'C:\Users\chris\AppData', $targetRepo = 'D:\ToGit\AppData',$toFilterRepo = 'D:\ToGit\Vortex', $toFilterBy = 'Roaming/Vortex/', $branchName = 'LargeINcluding' )
#>
function Push-Git-Subtree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $SourceDir,

        [Parameter(Mandatory = $true)]
        [string]
        $SourceSubdir,

        [Parameter(Mandatory = $true)]
        [string]
        $DestinationDir,

        [Parameter(Mandatory = $true)]
        [string]
        $DestinationPrefix
    )
    Push-Location

    # Check if the path is valid
    if (Test-Path $baseRepo) {
      # Move to the path
    # Change the current location to the source directory
      Set-Location $baseRepo
        
      git-status $baseRepo
      git-status $targetRepo

    # Push all branches to the destination directory
  Push-AllBranches -Remote 'D:\ToGit\AppData'
        git push --all $targetRepo

    # Change the current location to the destination directory
        cd $targetRepo
    Set-Location -Path $DestinationDir

    # Filter out the subdirectory from the original repository and add it as a prefix
  Filter-Branch -Subdirectory 'Roaming/Vortex/' -Branch '--all'
        git filter-branch -f --subdirectory-filter $toFilterBy -- --all 

        #If you want to pull in any new commits to the subtree from the remote:
  Pull-Subtree -Prefix 'Roaming/Vortex/' -Remote 'C:\Users\chris\AppData\.git' -Branch LargeINcluding 
        git subtree pull --prefix $toFilterBy $baseRepo $branchName
    
      # Do something else here
    }
    else {
      # Write an error message to the standard error stream
      Write-Error "The path $path does not exist."
      # Exit with a non-zero exit code
      exit 1
    }

    Pop-Location
}