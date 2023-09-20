function Filter-GitRepo {
<#
    .Synopsis
    This function filters a Git repository into a new branch by keeping only files that match a given pattern
    .Parameter FileName
    The pattern to match for file names. It can be a glob or a regular expression.
    .Parameter BranchName
    The name of the new branch to create. If not specified, it will use the file name as the branch name.
    .Example
    Filter-GitRepo -FileName "*.txt" -BranchName "text-files"
#>
    [CmdletBinding()]
    param (
      # The pattern to match for file names 
      [Parameter(Mandatory=$true)]
      [string]$FileName,

      # The name of the new branch to create 
      [Parameter(Mandatory=$false)]
      [string]$BranchName 
    )

    # Get the branch name from the parameter or use the file name as the branch name 
    if ($BranchName -eq $null) { 
      $BranchName = $FileName 
    } 

    # Create a new branch from the current one 
    git checkout -b $BranchName 

    # Filter the new branch to only keep files with filenames that match the pattern 
    git filter-repo --path-glob "*$FileName*" 
  }
