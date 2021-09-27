[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]
  $Location,
  [Parameter(Mandatory=$false)]
  $wildcards
)

$folder = Get-ChildItem $location #C:\test\test1\
#$wildcards = @(".txt",".doc",".xls")
$files = Get-ChildItem -Path $folderPath | where {$_.extension -notin $wildcards}
$files

#Url: https://stackoverflow.com/questions/55294576/filtering-file-extensions-with-powershell