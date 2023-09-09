function index-Remove ($name,$path)
	{
		try {
			# Change to the parent path and forget about the files in the target folder
			Set-Location $path
			# Check if the files in the target folder are already ignored by git
			if ((git ls-files --error-unmatch --others --exclude-standard --directory --no-empty-directory -- "$name") -eq "") {
			Write-Warning "The files in $name are already ignored by git"
			}
			else {
			git rm -r --cached $name
			git commit -m "forgot about $name"
			}
		}
		catch {
			Write-Warning "Failed to forget about files in $name"
			Write-Warning $_.Exception.Message
		}
	}
