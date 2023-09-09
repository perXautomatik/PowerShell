function Move-ModuleFolder {

# Define a function that moves the module folder to the repository path, replacing the .git file
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
