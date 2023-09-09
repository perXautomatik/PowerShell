function Push-AllBranches {
       
    <#
    .SYNOPSIS
    Pushes all branches to a remote repository.
    .EXAMPLE
    Push-AllBranches -Remote 'D:\ToGit\AppData'
    #>
  # This function pushes all branches to a remote repository
    [CmdletBinding()]
    param(
      # The remote repository to push to
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Remote
    )

  
    # Push all branches to the remote repository
    git push --all $Remote
  }
