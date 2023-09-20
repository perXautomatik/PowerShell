function Reset-GitHard {
  <#
  .Synopsis
  This function resets the current Git repository hard to a given tag name
  .Parameter TagName
  The name of the tag to reset to
  .Example
  Reset-GitHard -TagName "before merge"
  #>
    [CmdletBinding()]
    param (
      # The name of the tag to reset to
      [Parameter(Mandatory=$true)]
      [ValidateScript({git tag -l | Select-String $_})]
      [string]$TagName
    )

    # Validate the tag name
    if ($null -eq $TagName -or $TagName -eq "") {
	Write-Error "Tag name cannot be null or empty"
	return
    }
  
    # Reset the repo hard to the tag
    # Invoke the git reset command with the tag name and --hard option
    git reset --hard $TagName
  }
