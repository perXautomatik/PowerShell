function Remove-Files { 
<# .SYNOPSIS
Removes files from the index and the working tree.

.DESCRIPTION
This function takes an array of file names as input and uses git rm to remove them from the index and the working tree.
Define a function that removes files from the index and the working tree
.PARAMETER
 Files An array of file names to be removed. #>
param( # Accept an array of file names as input
[string[]]$Files )

#Use git rm with the file names as arguments
git rm $Files --ignore-unmatch }
