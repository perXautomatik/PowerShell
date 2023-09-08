function Get-ModifiedFileNames {

<#
.SYNOPSIS
Gets the names of modified files between two commits.

.DESCRIPTION
Gets the names of modified files between two commits using git diff and regex.

.PARAMETER ReferenceCommitId 
The commit id of the reference commit.

.EXAMPLE 
Get-ModifiedFileNames 65c0ce6a8e041b78c032f5efbdd0fd3ec9bc96f5

#>
  param (
      [Parameter(Mandatory)]
      [string]$ReferenceCommitId 
  )

  $regex = 'diff --git a.|\sb[/]'

  git diff --diff-filter=MRC HEAD $ReferenceCommitId | ?{ $_ -match '^diff.*' } | % { $_ -split($regex) }
}
