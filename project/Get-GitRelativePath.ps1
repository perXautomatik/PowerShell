function Get-GitRelativePath {
# Define a function to get the relative path of a file in the repo
    param (
	[Parameter(Mandatory=$true)]
	[string]$FilePath
    )

    # Validate the file path
    if ($FilePath -eq $null -or $FilePath -eq "") {
	Write-Error "File path cannot be null or empty"
	return
    }

    if (-not (Test-Path $FilePath)) {
	Write-Error "File path does not exist"
	return
    }

    # Get the relative path of the file in the repo
    git ls-files --full-name $FilePath
}
