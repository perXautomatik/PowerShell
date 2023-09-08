function Move-Directory {

<#
.SYNOPSIS
Moves a directory to a new location.

.DESCRIPTION
Moves a directory to a new location using filter-branch and subdirectory-filter.

.PARAMETER DirName
The name of the directory to move.

.EXAMPLE
Move-Directory -DirName "foo"
#>
    param (
        [Parameter(Mandatory)]
        [string]$DirName
    )

    set -eux

    mkdir -p __github-migrate__
    mvplz="if [ -d $DirName ]; then mv $DirName __github-migrate__/; fi;"
    git filter-branch -f --tree-filter "$mvplz" HEAD

    git filter-branch -f --subdirectory-filter __github-migrate__
}
