<synopsis> .SYNOPSIS This script lists the largest files and/or folders in a given path, excluding subfolders. 
A file or folder is considered large if it takes up more than 50% of its parent folder’s size. 

list largestt files and or folders where 
folders = excluding subfolders, filesize where no single file takes up more than 50% of the total filesize.
where file is the oposite, every file that is 50% or larger than it's folders total size.
folders in folders is treated like files, that is
ifany one of them excluding there subfolders total filesize is larger than 50% of there surronding folders consider them as large.
</synopsis>

function Get-LargeItems { param ( [Parameter(Mandatory=$true)] [string]$Path )
  
  # Get the size of a file or folder, excluding subfolders
  function Get-Size {
      param (
          [System.IO.FileSystemInfo]$Item
      )
  
      if ($Item -is [System.IO.FileInfo]) {
          return $Item.Length
      }
      else {
          return (Get-ChildItem $Item.FullName -File | Measure-Object -Sum Length).Sum
      }
  }
  
  # Get the parent folder size of a file or folder, excluding subfolders
  function Get-ParentSize {
      param (
          [System.IO.FileSystemInfo]$Item
      )
  
      $Parent = $Item.Directory
      if ($Parent) {
          return (Get-ChildItem $Parent.FullName -File | Measure-Object -Sum Length).Sum
      }
      else {
          return 0
      }
  }
  
  # Check if a file or folder is large, i.e. more than 50% of its parent folder size
  function Is-Large {
      param (
          [System.IO.FileSystemInfo]$Item
      )
  
      $Size = Get-Size $Item
      $ParentSize = Get-ParentSize $Item
  
      if ($ParentSize -eq 0) {
          return $false
      }
      else {
          return ($Size / $ParentSize) -gt 0.5
      }
  }
  
  # Get all the files and folders in the given path, excluding subfolders
  $Items = Get-ChildItem $Path -File -Directory
  
  # Filter out the items that are not large
  $LargeItems = $Items | Where-Object {Is-Large $_}
  
  # Sort the large items by size in descending order
  $SortedLargeItems = $LargeItems | Sort-Object {Get-Size $_} -Descending
  
  # Return the large items as output
  return $SortedLargeItems
}