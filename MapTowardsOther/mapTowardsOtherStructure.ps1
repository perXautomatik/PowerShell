 cd 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\8b7c273a-baa2-4933-a5d5-4862e23c0af2'
 
  $y = Get-ChildItem 

 $x = (join-path -childpath (split-path -path (git rev-parse --show-toplevel) -noQualifier) -path 'C:')

 cd $x

$y | %{Resolve-Path -relative $_.fullname }

#--diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]
#Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i.e. regular file, symlink, submodule, …​) changed (T), 
#are Unmerged (U), are Unknown (X), or have had their pairing Broken (B). Any combination of the filter characters (including none) can be used. When * (All-or-none) 
#is added to the combination

git diff --name-status --diff-filter=CMRTUXB HEAD c330f6c5098d9fe42d36d5b21bcb7db9ceb74310 