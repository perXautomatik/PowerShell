function Merge-GitTag {
<#
.SYNOPSIS
Merges a tag to the repo and resolves conflicts by unioning files.

.DESCRIPTION
This function merges a tag to the current branch of the repo and resolves any merge conflicts by unioning both of the conflicting files. It also commits the merge with a message containing the tag name.

.PARAMETER TagName
The name of the tag to merge. This parameter is mandatory and cannot be null or empty.

.EXAMPLE
Merge-GitTag -TagName "v1.0"

This example merges the tag "v1.0" to the current branch and resolves any conflicts by unioning files.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()]
	[string]$TagName
    )

    try {
	# Merge the tag to the repo
	git merge $TagName

	# Resolve the merge by unioning both of the conflicting files
	git config merge.union.driver true
	git add .
	git commit -m "Merged tag $TagName"
    }
    catch {
	# Write an error message and exit
	Write-Error "Failed to merge tag $TagName: $_"
	exit 1
    }
}
