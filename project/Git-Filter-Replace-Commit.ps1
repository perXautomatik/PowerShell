function Git-Filter-Replace-Commit {
    <#
    .Synopsis
    This function replaces a commit in a Git repository with another commit using a replacement rule
    .Parameter ReplacementRule
    The replacement rule that specifies which commit to replace with which commit. It should be in the format of "old-ref:new-ref"
    .Example
    Replace-GitCommit -ReplacementRule "refs/heads/master:81a708d refs/heads/project-history/master:c6e1e95"
    #>
    [CmdletBinding()]
    param (
      # The replacement rule that specifies which commit to replace with which commit 
      [Parameter(Mandatory=$true)]
      [ValidateScript({$_ -match "^refs\/.*:.* refs\/.*:.*$"})]
      [string]$ReplacementRule
    )
  
    # Create a file that contains the replacement rule
    $replacementsFile = "replacements.txt"
    Set-Content -Path $replacementsFile -Value $ReplacementRule
  
    # Use git-filter-repo to replace the commit
    git filter-repo --replace-refs $replacementsFile
  }
