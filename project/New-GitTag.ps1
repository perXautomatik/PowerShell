function New-GitTag {
# Define a function to create a git tag with a message

    param (
	[Parameter(Mandatory=$true)]
	[string]$TagName,

	[Parameter(Mandatory=$true)]
	[string]$TagMessage
    )

    # Validate the tag name and message
    if ($TagName -eq $null -or $TagName -eq "") {
	Write-Error "Tag name cannot be null or empty"
	return
    }

    if ($TagMessage -eq $null -or $TagMessage -eq "") {
	Write-Error "Tag message cannot be null or empty"
	return
    }

    # Create the tag with the message
    git tag -a $TagName -m $TagMessage
}
