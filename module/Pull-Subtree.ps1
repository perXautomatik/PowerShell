function Pull-Subtree {
        <#
     .SYNOPSIS
     Pulls in any new commits from a remote subtree.
     .EXAMPLE
     Pull-Subtree -Prefix 'Roaming/Vortex/' -Remote 'C:\Users\chris\AppData\.git' -Branch LargeINcluding 
     #>
  # This function pulls in any new commits from a remote subtree
    [CmdletBinding()]
    param(
      # The prefix of the subtree
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Prefix,
  
      # The remote repository of the subtree
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Remote,
  
      # The branch of the subtree
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Branch
    )
     # Pull in any new commits from the remote subtree 
     git subtree pull --prefix $Prefix $Remote $Branch 
  }
