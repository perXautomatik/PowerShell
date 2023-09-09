function Get-IgnoredFiles {
#Call the Rewrite-History function
<# .SYNOPSIS
Lists all the ignored files that are cached in the index.

.DESCRIPTION
This function uses git ls-files with the -c, --ignored and --exclude-standard options to list all the files that are ignored by
Use git ls-files with the -c, --ignored and --exclude-standard options
.gitignore or other exclude files, and also have their content cached in the index. #>


git ls-files -s --ignored --exclude-standard -c }
