cd 'C:\Users\Användaren\AppData\Roaming\Vortex\darkestDungeon\mods\dlcloverslabHeroes\heroes'
ls |
 %{Get-ChildItem -dir -path $_.fullname}  |
  ?{$_.basename -match ((split-path $_.fullname -parent) | 
  split-path -Leaf ) } | 
  %{
      
   $currentname = $_.basename;
      $path=$_.fullname;
     $parentPath = (split-path $path -parent)
     $rosterHash = (( Get-ChildItem -file -Path $path\* -filter '*_portrait_roster*' | select -first 1) |  Get-FileHash).hash;
     $newPath = Join-Path $parentPath $rosterHash;

  if (Test-Path $newPath) {
   $toMove = $path | Get-ChildItem;

   $toMove | Move-Item -Destination $newPath;
   
}

else {
   '' > $path/$currentname.txt
   Rename-Item -Path $path $rosterHash;

}
}