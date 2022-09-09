cls
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser


. '\\100.84.7.151\NetBackup\Project Shelf\PowerShellProjectFolder\Scripts\TodoProjects\Tokenization.ps1'



cd 'C:\Users\chris\AppData\Roaming\Microsoft\Windows\PowerShell'

$mytable = ((git rev-list --all) | 
select -First 10 |
 %{ (git grep "echo" $_ )}) | %{ $all = $_.Split(':') ; [system.String]::Join(":", $all[2..$all.length]) }


$HashTable=@{}
foreach($r in $mytable)
{
   $HashTable[$r]++
}
$errors = $null

$HashTable.GetEnumerator() | Sort-Object -property @{Expression = "value"; Descending = $true},name  |
 ?{ $_.name -ne $null} |  select value, @{Expression={(TokenizeOccurence $_.name)} ; Name = "token"}, name  | select token -First 1 | Format-Custom

