function Merge-Refs {
  # Define a function to merge all head refs in the filtered repository into a single branch using the strategy "theirs" and --allow-unrelated-history
  param (
    [string]$TempFolder,
    [string]$BranchName
  )
  Push-Location $TempFolder
  git checkout -b $BranchName
  foreach ($ref in (git show-ref --heads | Select-String -Pattern "refs/heads/" | ForEach-Object { $_.Line.Split()[-1] })) {
    if ($ref -ne "refs/heads/$BranchName") {
      git merge --strategy-option=theirs --allow-unrelated-histories -m "Merge $ref into $BranchName" $ref
      if ($?) {
        git branch -D $ref
      }
    }
  }
  Pop-Location
}
