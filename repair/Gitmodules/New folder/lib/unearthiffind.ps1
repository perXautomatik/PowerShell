function unearthiffind ()
{


# requries gitmodulesfile


# \GitSyncSubmoduleWithConfig.ps1
<#
.SYNOPSIS
Synchronizes the submodules with the config file.

.DESCRIPTION
This function synchronizes the submodules with the config file, using the Git-helper and ini-helper modules. The function checks the remote URLs of the submodules and updates them if they are empty or local paths. The function also handles conflicts and errors.

.PARAMETER GitDirPath
The path of the git directory where the config file is located.

.PARAMETER GitRootPath
The path of the git root directory where the submodules are located.

.PARAMETER FlagConfigDecides
A switch parameter that indicates whether to use the config file as the source of truth in case of conflicting URLs.
#>

# A function to move a .git Folder into the current directory and remove any gitfiles present
    param (
        [Parameter(Mandatory=$true)]
        [string]$toRepair,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
        # Get the module folder that matches the name of the parent directory
        Get-ChildItem -Path $Modules -Directory | Where-Object { $_.Name -eq $toRepair.Directory.Name } | Select-Object -First 1 | % {

        # Move the module folder to replace the .git file
        Remove-Item -Path $toRepair -Force 
        Move-Item -Path $_.FullName -Destination $toRepair -Force 
    }
}
