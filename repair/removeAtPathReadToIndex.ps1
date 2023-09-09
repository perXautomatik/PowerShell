function removeAtPathReadToIndex {

#Git-InitializeSubmodules -repoPath 'G:\ToGit\projectFolderBare\scoopbucket-presist'

# \removeAtPathReadToIndex.ps1

    param (
        [Parameter(Mandatory=$true, HelpMessage=".git, The path of the git folder to convert")]
        [ValidateScript({Test-Path $_ -PathType Container ; Resolve-Path -Path $_ -ErrorAction Stop})] 
        [Alias("GitFolder")][string]$errorus,[Parameter(Mandatory=$true,HelpMessage="subModuleRepoDir, The path of the submodule folder to replace the git folder")]
        #can be done with everything and menu
        [Parameter(Mandatory=$true,HelpMessage="subModuleDirInsideGit")]
        [ValidateScript({Test-Path $_ -PathType Container ; Resolve-Path -Path $_ -ErrorAction Stop})]
        [Alias("SubmoduleFolder")][string]$toReplaceWith
    )

        # Get the config file path from the git folder
        $configFile = Join-Path $GitFolder 'config'
        # Push the current location and change to the target folder

        # Get the target folder, name and parent path from the git folder
        Write-Verbos "#---- asFile"
 
        $asFile = ([System.IO.Fileinfo]$errorus.trim('\'))
     
        Write-Verbos $asFile
    
        $targetFolder = $asFile.Directory
        $name = $targetFolder.Name
        $path = $targetFolder.Parent.FullName  

        about-Repo #does nothing without -verbos

        
        Push-Location
        Set-Location $targetFolder
        
        index-Remove $name	$path

        # Change to the parent path and get the root of the git repository
        
        # Add and absorb the submodule using the relative path and remote url
        $relative = get-Relative $path $targetFolder

        Add-AbsorbSubmodule -Ref ( get-Origin) -Relative $relative

        # Pop back to the previous location
        Pop-Location

        # Restore the previous error action preference
        $ErrorActionPreference = $previousErrorAction

    }
