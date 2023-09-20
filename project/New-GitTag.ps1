function New-GitTag {
<#
.Synopsis
This function creates a new Git tag with the given name and message
.Parameter TagName
The name of the new Git tag
.Parameter TagMessage
The message of the new Git tag
.Example
New-GitTag -TagName "before merge" -TagMessage "Before merge"
#>
    [CmdletBinding()]
    param (
      # The name of the new Git tag
      [Parameter(Mandatory=$true)]
      [string]$TagName,
  
      # The message of the new Git tag
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

    # Invoke the git tag command with the parameters
    # Create the tag with the message
    git tag -a $TagName -m $TagMessage
  }
