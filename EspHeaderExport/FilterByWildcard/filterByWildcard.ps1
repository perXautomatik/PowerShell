$folder = Get-ChildItem C:\test\test1\
$wildcards = @(".txt",".doc",".xls")
$files = Get-ChildItem -Path $folderPath | where {$_.extension -in $wildcards}
$files

#Url: https://stackoverflow.com/questions/55294576/filtering-file-extensions-with-powershell