function Clone-Repo {
  # Define a function to clone the current repository into a temporary folder using TortoiseGit
  param (
    [string]$RepoUrl,
    [string]$TempFolder
  )
  $cloneCmd = "TortoiseProc.exe /command:clone /path:`"$TempFolder`" /url:`"$RepoUrl`" /closeonend:1"
  Invoke-Expression $cloneCmd
}
