#..\ForumAnsweres\pipe-objects-into-arrays.ps1

. "D:\Project Shelf\PowerShellProjectFolder\scripts\TodoProjects\ForumAnsweres\pipe-objects-into-arrays.ps1"


function merge-files {
param([string[]]$a)

#one liner = Get-Content inputFile1.txt, inputFile2.txt | Set-Content joinedFile.txt

 
    (Get-Content ($a | Sort-Object -Property @{expres={(Get-Content $_ | Measure-Object).count }} -Descending | Tee-Object -Variable v | chunk-object)) | Set-Content ($v | select -First 1)
 
 trap {
    throw $_.Exception
    break
 }

 ($v | select -Skip 1) | Remove-Item


 echo "merged " + (($v | select -Skip 1) | chunk-object )
 echo "to " + ($v | select -first 1)


}

merge-files -a "D:\Project Shelf\PowerShellProjectFolder\scripts\TodoProjects\hello.ps1","D:\Project Shelf\PowerShellProjectFolder\scripts\TodoProjects\hello2.ps1"