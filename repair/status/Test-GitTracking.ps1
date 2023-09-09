function Test-GitTracking {

# Define a function to check if a path is tracked by another path as a normal part of repository or as a submodule
<#
.SYNOPSIS
Checks if a path is tracked by another path as a normal part of repository or as a submodule.

.DESCRIPTION
This function changes the current location to another path and invokes the git status command using the Invoke-Git function.
It checks if the output contains the path as a normal part of repository or as a submodule using regular expression matching.
It returns $true if the path is tracked, otherwise it returns $false.
It also restores the original location after checking.

.PARAMETER Path
The path to check.

.PARAMETER OtherPath
The other path to compare with.

.EXAMPLE
Test-GitTracking -Path "C:\path1" -OtherPath "C:\path2"

This example checks if C:\path1 is tracked by C:\path2 as a normal part of repository or as a submodule and returns $true or $false.
#>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path, # The path to check

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$OtherPath # The other path to compare with
  )
  # Change the current location to the other path
  Push-Location -Path $OtherPath

  # Invoke git status command using the Invoke-Git function and capture the output
  try {
    $GitStatus = Invoke-Git -Command "status --porcelain --untracked-files=no" -verbos
  }
  catch {
    # Print the error as a verbose message and rethrow it
    Write-Verbose $_.Exception.Message
    throw $_.Exception.Message
  }

  # Restore the original location
  Pop-Location

  # Check if the output contains the path as a normal part of repository or as a submodule using regular expression matching
  if ($GitStatus -match [regex]::Escape($Path)) {
    return $true
  }

  return $false

}
