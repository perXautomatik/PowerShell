function compareNonull {
    param(
        [Parameter()][ValidateNotNullOrEmpty()][string]$hash1,
        [Parameter()][ValidateNotNullOrEmpty()][string]$hash2
    )
    return $hash1 -eq $hash2
}

function CompareFiles {

    param(
        [Parameter()][ValidateNotNullOrEmpty()][string]$Filepath1=$(throw "file not found: '$Filepath1'"),
        [Parameter()][ValidateNotNullOrEmpty()][string]$Filepath2=$(throw "file not found: '$Filepath2'")
    )

    $file1 = $Filepath1 | split-path -leaf
    $file2 = $Filepath2 | split-path -leaf
    $dir1  = (Get-Item $filepath1) -is [System.IO.DirectoryInfo]
    $dir2  = (Get-Item $filepath2) -is [System.IO.DirectoryInfo]
    $hash1 = (Get-FileHash $Filepath1).Hash
    $hash2 = (Get-FileHash $Filepath2).Hash


    $returnStatement = 
    [PSCustomObject]@{        
        filepath1=      $filepath1
        filepath2=      $filepath2
        file1 =         $file1
        file2 =         $file2        
        isDir1 =        $dir1
        isDir2 =        $dir2
        hash1 =         $hash1
        hash2 =         $hash2
        nameMatch =     ($file1 -eq $file2)
        HashMatch =     compareNonull $hash1 $hash2 -ErrorAction SilentlyContinue
        bothFolders =   ($dir1 -and $dir2)
    }
    return $returnStatement
}


#$foldA = Get-ChildItem -path 'D:\Steam\steamapps\workshop\content\262060\2216182993\heroes\' | %{($_.FullName | Out-String).trim()} 
#$foldB = Get-ChildItem -path 'D:\Steam\steamapps\workshop\content\262060\loverslabHeroes\heroes' | %{($_.FullName | Out-String ).trim()} 

#$foldb
[String]$outer = '';
$foldAy.count
$foldBy.count

#$foldA | %{ get-name $_  ;  "--------------------------------------------------" ; $_ -is [System.String]}
#$foldA | %{ $outer +=[string]$_ ; "text" ; $outer;   CompareFiles($outer,$outer) ; $outer = ''}


#$foldb | %{ get-name $_  ;  "--------------------------------------------------" ; $_ -is [System.String]}
#%{"aaa"; $_.file1;"-----";$_.file2 ; "ccc" }

$foldBx = Get-ChildItem -path 'D:\Steam\steamapps\workshop\content\262060\loverslabHeroes\heroes'
$foldAx = Get-ChildItem -path 'D:\Steam\steamapps\workshop\content\262060\2216182993\heroes\'

$a = $foldAx | ?{ $foldBx.basename -contains $_.basename  }
$b = $foldBx | ?{ $foldAx.basename -contains $_.basename  }

($b.count/$foldBx.count).tostring("P") + "|" + ($a.count/$foldax.count).tostring("P")


#$foldA | %{ $outer = $_ ; if ($outer -is [System.String]) { $foldB | %{ if ($_ -is [System.String]) { CompareFiles $_ $outer } } } } | where {$_.nameMatch} |select -first 1 

function assesssSimilarityAndRecurse()
    if file, match oposing files for maximum average and top match
    if folder, match name then recurse. 

