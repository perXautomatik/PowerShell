function Rename-Branch {
  # Define a function to rename the current branch into a name based on the arguments, replacing unallowed chars with safe replacements and truncating it to not be too long
  param (
    [string]$TempFolder,
    [string[]]$Args
  )
  Push-Location $TempFolder
  # Concatenate the arguments with dashes and remove any leading or trailing dashes
  $newName = ($Args -join "-").Trim("-")
  # Replace any unallowed chars with underscores
  $newName = $newName -replace "[^a-zA-Z0-9\-\_\.]", "_"
  # Truncate the name to not exceed 40 characters
  if ($newName.Length -gt 40) {
    $newName = $newName.Substring(0,40)
  }
  # Rename the current branch with the new name
  git branch -m $newName
  Pop-Location
}
