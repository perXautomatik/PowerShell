function unearthiffind ()
{

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
