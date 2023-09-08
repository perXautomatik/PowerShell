function Remove-AllFilesExcept {
<#
.SYNOPSIS
Removes all files except those of a given name.

.DESCRIPTION
Removes all files except those of a given name from the Git history using filter-branch.

.PARAMETER FileName
The name of the file to keep.

.EXAMPLE
Remove-AllFilesExcept -FileName "readme.md"
#>
    param (
        [Parameter(Mandatory)]
        [string]$FileName
    )

    git filter-branch --prune-empty -f --index-filter "git ls-tree -r --name-only --full-tree $GIT_COMMIT | grep -v '$FileName' | xargs git rm -r"
}
