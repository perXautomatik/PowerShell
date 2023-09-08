function Filter-Repo {
  # Define a function to run git filter-repo on the cloned repository with the given arguments
  param (
    [string]$TempFolder,
    [string[]]$Args
  )
  Push-Location $TempFolder
  git filter-repo $Args
  Pop-Location
}
