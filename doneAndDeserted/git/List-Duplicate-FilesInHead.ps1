git ls-tree -r HEAD |
    %{ [pscustomobject]@{unkown=$_.substring(0,6);blob=$_.substring(7,4); hash=$_.substring(12,40);relativePath=$_.substring(53)} } |
        Group-Object -Property hash |
         ? { $_.count -ne 1 } | 
            Sort-Object -Property count -Descending |
                %{ $_.group } | 
                    select @{name="h1";expression={$_.hash.substring(38)}}, relativepath