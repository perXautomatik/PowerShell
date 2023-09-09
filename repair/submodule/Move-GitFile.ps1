function Move-GitFile ($file) {

# A function to move a .git file to the corresponding module folder
    param (
        [System.IO.FileInfo]$file,
    )
  global:$modules | 
  	Get-ChildItem -Directory | 
		?{ $_.name -eq $file.Directory.Name } | 
			select -First 1 | % {
    # Move the folder to the target folder
    rm $file -force ;
	 Move-Item -Path $_.fullname -Destination $file -force 
  }
}
