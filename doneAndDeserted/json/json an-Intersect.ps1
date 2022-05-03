$path1 = "D:\Project Shelf\RawData\Unsorted\jx.json"
$path2 = "D:\Project Shelf\RawData\Unsorted\jx -copy.json"

#Invoke-WebRequest -Uri "https://gist.githubusercontent.com/perXautomatik/a61f28b31538eecf42fae3641051b1ac/raw/04e82646790ae38d52ff337af7ec96b791855da5/Chrome" -OutFile $path1 
#Invoke-WebRequest -Uri "https://gist.githubusercontent.com/perXautomatik/a61f28b31538eecf42fae3641051b1ac/raw/04e82646790ae38d52ff337af7ec96b791855da5/ChromeX" -OutFile $path2


## Will list the content present in Both the files
$file1 = (Get-Content -Path $path1) | ConvertFrom-Json -depth 10
$file2 = (Get-Content -Path $path2) | convertfrom-json -depth 10
$file1 | Measure-Object 
$file2 | Measure-Object
$file1.bookmarks


[linq.enumerable]::intersect( [object[]]($file1), [object[]]($file2) ) 


#| Export-Csv -NoTypeInformation -Path "C:\ps\result\result.csv"

## will list the content present either in one of the files but not in both
$res = [Collections.Generic.HashSet[String]]( [string[]]($file1) )
#$res.SymmetricExceptWith( [string[]]($file2) )
$res
# | Export-Csv -NoTypeInformation -Path "C:\ps\result\result.csv"

## For union operation, you can try like this
[system.linq.enumerable]::union([object[]](1,2,3),[object[]](2,3,4))

