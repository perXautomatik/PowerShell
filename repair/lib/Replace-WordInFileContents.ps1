function Replace-WordInFileContents {

<#
.SYNOPSIS
Replaces all occurrences of a word in file contents.

.DESCRIPTION
Replaces all occurrences of a word in file contents using filter-branch and sed.

.PARAMETER OldWord
The word to replace.

.PARAMETER NewWord
The word to use instead.

.EXAMPLE
Replace-WordInFileContents -OldWord "Result" -NewWord "Stat"
#>
    param (
        [Parameter(Mandatory)]
        [string]$OldWord,
        [Parameter(Mandatory)]
        [string]$NewWord
    )

    git filter-branch --tree-filter '
    for file in $(find . -type f ! -path "*.git*" ! -path "*.idea*")
    do
      sed -i "" -e s/$OldWord/$NewWord/g $file;
    done
    ' --force HEAD

}
