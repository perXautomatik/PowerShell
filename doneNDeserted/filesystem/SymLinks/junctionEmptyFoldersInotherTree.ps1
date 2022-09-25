cd 'B:\Users\chris\Documents'

$emptyDirectories = (Get-ChildItem -Directory | ? { ($_ | Get-ChildItem).length -eq 0 }); $relatedDirectories = @{} ; Get-ChildItem '.\My Games\' -Directory | ? { $emptyDirectories.name -contains $_.name } | %{ $relatedDirectories.add($_.name,$_)} ; $emptyDirectories | %{rm $_ ; junction.exe $_ $relatedDirectories[$_.Name].FullName  }