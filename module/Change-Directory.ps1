function Change-Directory {
    <#
    .SYNOPSIS
    Changes the current directory to the specified path.
    .EXAMPLE
    Change-Directory -Path 'C:\Users\chris\AppData'
    #>
# This function changes the current directory to the specified path
    [CmdletBinding()]
    param(
      # The path to change to
      [Parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$Path
    )

  
    # Change the current directory
    Set-Location -Path $Path
  }
