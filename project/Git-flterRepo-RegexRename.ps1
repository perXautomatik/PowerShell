function Git-flterRepo-RegexRename {

# A powershell function that does the following:
# - Takes two relative paths as arguments
# - Uses filter-repo to change the name of a file from the old path to the new path

  # Get the arguments
  param (
    [string]$oldPath,
    [string]$newPath
  )

  # Check if the arguments are valid
  if (-not $oldPath -or -not $newPath) {
    Write-Error "Please provide two relative paths as arguments"
    return
  }

  # Use filter-repo to rename the file
  git filter-repo  --path-regex '^.*/$oldPath$' --path-rename :$newPath
}
