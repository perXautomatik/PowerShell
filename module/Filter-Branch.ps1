function Filter-Branch {
      <#
    .SYNOPSIS
    Filters a branch to a subdirectory and rewrites its history.
    .EXAMPLE
    Filter-Branch -Subdirectory 'Roaming/Vortex/' -Branch '--all'
    #>
  # This function filters a branch to a subdirectory and rewrites its history
    [CmdletBinding()]
    param(
      # The subdirectory to filter to
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Subdirectory,
  
      # The branch to filter
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Branch
    )
  

  
    # Filter the branch to the subdirectory and rewrite its history
    git filter-branch -f --subdirectory-filter $Subdirectory -- $Branch 
  }
