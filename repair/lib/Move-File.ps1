function Move-File {

<#
.SYNOPSIS
Moves a file to a new directory.

.DESCRIPTION
Moves a file from the current directory to a new directory using filter-branch.

.PARAMETER FileName
The name of the file to move.

.PARAMETER NewDir
The name of the new directory.

.EXAMPLE
Move-File -FileName "my-file" -NewDir "new-dir"
#>
    param (
        [Parameter(Mandatory)]
        [string]$FileName,
        [Parameter(Mandatory)]
        [string]$NewDir
    )

    git filter-branch --tree-filter "
    if [ -f current-dir/$FileName ]; then
      mv current-dir/$FileName $NewDir/
    fi" --force HEAD
}
