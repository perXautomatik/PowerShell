function Rewrite-History { 

<# .SYNOPSIS
Rewrites the history of the current branch by removing all the ignored files.

.DESCRIPTION
This function uses git filter-branch with the -f, --index-filter and --prune-empty options to rewrite the history of the current branch by removing all the ignored files from each revision, and also removing any empty commits that result from this operation. It does this by modifying only the index, not the working tree, of each revision.
#Define a function that rewrites the history of the current branch by removing all the ignored files
#Use git filter-branch with the -f, --index-filter and --prune-empty options#>

   # Call the Get-IgnoredFiles function and pipe the output to Remove-Files function

    git filter-branch -f --index-filter {
	Get-IgnoredFiles | Remove-Files
	} --prune-empty }
