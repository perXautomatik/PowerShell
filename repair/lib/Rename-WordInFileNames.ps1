function Rename-WordInFileNames {

<#
.SYNOPSIS
Renames all occurrences of a word in file names.

.DESCRIPTION
Renames all occurrences of a word in file names using filter-branch and string replacement.

.PARAMETER OldWord
The word to replace.

.PARAMETER NewWord
The word to use instead.

.EXAMPLE
Rename-WordInFileNames -OldWord "Result" -NewWord "Stat"
#>
    param (
        [Parameter(Mandatory)]
        [string]$OldWord,
        [Parameter(Mandatory)]
        [string]$NewWord
    )

    git filter-branch --tree-filter '
    for file in $(find . ! -path "*.git*" ! -path "*.idea*")
    do
      if [ "$file" != "${file/$OldWord/$NewWord}" ]
      then
        mv "$file" "${file/$OldWord/$NewWord}"
      fi
    done
    ' --force HEAD

}
