cd 'D:\Vortex Mods\DarkestDungeon' 


Get-ChildItem | ?{$name = (( Get-ChildItem -dir -Path $_ | select -first 1)) ; $regex = "^.*$name.*$" ;$_.basename -cnotmatch $regex} |
%{
   
  $q=$_.fullname;
  
  $name = (( Get-ChildItem -dir -Path $q | select -first 1));
  $bname = $_.BaseName;
  $name = "$name$bname";
  $FileName = Join-Path (split-path $_.fullname -parent) $name;

    if (Test-Path $FileName) {
    $toMove = $q | Get-ChildItem;

    $toMove | Move-Item -Destination $FileName;
  
    }

    else {
   
       Rename-Item -Path $q $name;
    }

}