function Update-Git-Submodules {

# \GitUpdateSubmodulesAutomatically.ps1
<#
.SYNOPSIS
Updates the submodules of a git repository.

.DESCRIPTION
This function updates the submodules of a git repository, using the PsIni module and the git commands. The function removes any broken submodules, adds any new submodules, syncs the submodule URLs with the .gitmodules file, and pushes the changes to the remote repository.

.PARAMETER RepositoryPath
The path of the git repository where the submodules are located.

.PARAMETER SubmoduleNames
An array of submodule names that will be updated. If not specified, all submodules will be updated.
#>
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true)]
      [string]
      $RepositoryPath,

      [Parameter(Mandatory = $false)]
      [string[]]
      $SubmoduleNames
  )

    # Set the error action preference to stop on any error
    $ErrorActionPreference = "Stop"

    # Change the current location to the repository path
    Set-Location -Path $RepositoryPath  

    #update .gitmodules
    config-to-gitmodules

    $submodules = Get-SubmoduleDeep $RepositoryPath

    # If submodule names are specified, filter out only those submodules from the array
    if ($SubmoduleNames) {
        $submodules = $submodules | Where-Object { $_.submodule.Name -in $SubmoduleNames }
    }

    # Loop through each submodule in the array and update it
    foreach ($submodule in $submodules) {
                
        
        # Get all submodules from the .gitmodules file as an array of objects    

        $submodulePath = $submodule.path

        # Check if submodule directory exists
        
        if (Test-Path -Path $submodulePath) {
            
            # Change current location to submodule directory
            
            Push-Location -Path $submodulePath
            
            # Get submodule URL from git config
            $submoduleUrl = Get-GitRemoteUrl
            
            # Check if submodule URL is empty or local path
            if ([string]::IsNullOrEmpty($submoduleUrl) -or (Test-Path -Path $submoduleUrl)) {
            
                # Set submodule URL to remote origin URL
                $submoduleUrl = (byPath-RepoUrl -Path $submodulePath)
                if(!($submoduleUrl))
                {
                    $submoduleUrl = $submodule.url
                }
                
                Set-GitRemoteUrl -Url  $submoduleUrl                    
            }

            # Return to previous location
            
            Pop-Location
            
            # Update submodule recursively
            
            Invoke-Git "submodule update --init --recursive $submodulePath"
            
        }        
        else {            
            # Add submodule from remote URL
            
            Invoke-Git "submodule add $(byPath-RepoUrl -Path $submodulePath) $submodulePath"            
        }
    
    }

  # Sync the submodule URLs with the .gitmodules file
  Invoke-Git "submodule sync"

  # Push the changes to the remote repository
  Invoke-Git "push origin master"
}
