$path = 'D:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db'

cd $path

Get-ChildItem -Directory | % {
 
 #git submodule add -b "$path\.git" $_.Name
 $q = $_.fullname+'\.git'
 git submodule add -b -- $q $_.Name
 
 $_.Name
 git submodule absorbgitdirs 
 
}