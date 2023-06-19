<#
.SYNOPSIS
Update or create files and folders with the current date and time.

.DESCRIPTION
This script takes three parameters: the paths to the files or folders to update or create, and two switches to specify whether to update only the modification time or only the access time. It then uses the System.IO.FileSystemInfo class to set the creation, modification and access times of the existing files or folders to the current date and time, or creates new files with the current date and time. It also creates an alias called touch for this function.

.PARAMETER Paths
The paths to the files or folders to update or create. If not specified, it uses the input from the pipeline.

.PARAMETER OnlyModification
A switch to indicate whether to update only the modification time of the existing files or folders.

.PARAMETER OnlyAccess
A switch to indicate whether to update only the access time of the existing files or folders.

.EXAMPLE
PS C:\> Set-FileTime -Paths "C:\Users\user\Documents\test.txt", "C:\Users\user\Documents\test2.txt" -OnlyModification

This example updates only the modification time of the test.txt and test2.txt files to the current date and time.
#>

function Set-FileTime{
  param(
    [string[]]$Paths,
    [switch]$OnlyModification = $false,
    [switch]$OnlyAccess = $false
  )

  begin {
    # Define a helper function to update the file system info object with the current date and time
    function UpdateFileSystemInfo([System.IO.FileSystemInfo]$FsInfo) {
      $DateTime = Get-Date
      if ( $OnlyAccess )
      {
         $FsInfo.LastAccessTime = $DateTime
      }
      elseif ( $OnlyModification )
      {
         $FsInfo.LastWriteTime = $DateTime
      }
      else
      {
         $FsInfo.CreationTime = $DateTime
         $FsInfo.LastWriteTime = $DateTime
         $FsInfo.LastAccessTime = $DateTime
       }
    }
   
    # Define a helper function to update an existing file or folder with the current date and time
    function TouchExistingFile($Arg) {
      if ($Arg -is [System.IO.FileSystemInfo]) {
        UpdateFileSystemInfo($Arg)
      }
      else {
        $ResolvedPaths = Resolve-Path $Arg
        foreach ($RPath in $ResolvedPaths) {
          if (Test-Path -Type Container $RPath) {
            $FsInfo = New-Object System.IO.DirectoryInfo($RPath)
          }
          else {
            $FsInfo = New-Object System.IO.FileInfo($RPath)
          }
          UpdateFileSystemInfo($FsInfo)
        }
      }
    }
   
    # Define a helper function to create a new file with the current date and time
    function TouchNewFile([string]$Path) {
      Set-Content -Path $Path -Value $null;
    }
  }
 
  process {
    # If there is input from the pipeline, update or create it with the current date and time
    if ($_) {
      if (Test-Path $_) {
        TouchExistingFile($_)
      }
      else {
        TouchNewFile($_)
      }
    }
  }
 
  end {
    # If there are paths specified as parameters, update or create them with the current date and time
    if ($Paths) {
      foreach ($Path in $Paths) {
        if (Test-Path $Path) {
          TouchExistingFile($Path)
        }
        else {
          TouchNewFile($Path)
        }
      }
    }
  }
}

# Create an alias called touch for this function
New-Alias touch Set-FileTime
