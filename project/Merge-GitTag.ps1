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
      # The name of the tag to merge from 
      [Parameter(Mandatory=$true)]
	  [ValidateNotNullOrEmpty()]
      [ValidateScript({git tag -l | Select-String $_})]
      [string]$TagName 
    )
    try {
            # Invoke the git merge command with the tag name and --no-commit option 
            git merge $TagName --no-commit 
        
            # Resolve the merge by unioning both of the conflicting files
            git config merge.union.driver true
        
            # Check if there are any merge conflicts 
            if (git diff --name-only --diff-filter=U) { 
                # Loop through the conflicted files and resolve them by unioning their contents 
                foreach ($file in (git diff --name-only --diff-filter=U)) { 
                        # Use git merge-file command with --union option to union the contents of the file 
                        git merge-file --union $file 
                        # Add the resolved file to the index 
                        git add $file 
                    }
                }
            git commit -m "Merged tag $TagName"
        }
    catch {
		# Write an error message and exit
		Write-Error "Failed to merge tag $TagName : $_"
		exit 1
    }
  }
