function Reset-GitHard {
# Define a function to reset the repo hard to a tag
    param (
	[Parameter(Mandatory=$true)]
	[string]$TagName
    )

    # Validate the tag name
    if ($TagName -eq $null -or $TagName -eq "") {
	Write-Error "Tag name cannot be null or empty"
	return
    }

    # Reset the repo hard to the tag
    git reset --hard $TagName
}
