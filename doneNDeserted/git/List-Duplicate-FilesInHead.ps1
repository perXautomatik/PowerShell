function list-git-DupeObjectHash
{
param([string]$path)
$current = $PWD

cd $path

git ls-tree -r HEAD |
    %{ [pscustomobject]@{unkown=$_.substring(0,6);blob=$_.substring(7,4); hash=$_.substring(12,40);relativePath=$_.substring(53)} } |
        Group-Object -Property hash |
         ? { $_.count -ne 1 } | 
            Sort-Object -Property count -Descending |
                %{ $_.group } 
 cd $current
 }               
                
 list-git-DupeObjectHash -path 'C:\Users\chris\Desktop\New folder' | 
                    select @{name="h1";expre={$_.hash.substring(38)}}, relativepath
