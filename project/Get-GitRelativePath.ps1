function Get-GitRelativePath {
  <#
  .Synopsis
  This function gets the relative path of a file in the current Git repository
  .Parameter FilePath
  The absolute or relative path of the file
  .Outputs
  The relative path of the file in the current Git repository
  .Example
  Get-GitRelativePath -FilePath ".\foo\bar.txt"
  #>
    [CmdletBinding()]
    param (
      # The path of the file
      [Parameter(Mandatory=$true)]
      [ValidateScript({Test-Path $_})]
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
    # Get the absolute path of the file
    $absolutePath = Resolve-Path $FilePath
  
    # Get the relative path of the file in the repo
    git ls-files --full-name $FilePath
    # Get the root path of the current Git repository
    $rootPath = git rev-parse --show-toplevel
  
    # Get the relative path of the file by removing the root path from the absolute path
    $relativePath = $absolutePath -replace "^$rootPath\\"
  
    # Write the relative path to stdout
    Write-Output $relativePath
  }
