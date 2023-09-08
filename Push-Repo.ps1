function Push-Repo {
  # Define a function to push all branches in the filtered repository back to the original repository
  param (
    [string]$TempFolder,
    [string]$RepoUrl
  )
  Push-Location $TempFolder
  git push --all origin 
}
