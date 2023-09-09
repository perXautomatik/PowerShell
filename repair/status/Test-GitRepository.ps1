function Test-GitRepository {

# Define a function to check if a path is a valid git repository
<#
.SYNOPSIS
Checks if a path is a valid git repository.

.DESCRIPTION
This function checks if a path is a valid directory and contains a .git folder.
It returns $true if both conditions are met, otherwise it returns $false.

.PARAMETER Path
The path to check.

.EXAMPLE
Test-GitRepository -Path "C:\path1"

This example checks if C:\path1 is a valid git repository and returns $true or $false.
#>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path # The path to check
  )
  # Check if the path is a valid directory and contains a .git folder
  if (Test-Path -Path $Path -PathType Container -ErrorAction SilentlyContinue) {
    if (Test-Path -Path "$Path\.git" -ErrorAction SilentlyContinue) {
      return $true
    }
  }
  return $false
}
