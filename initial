function CountLines ($source,$target,$original)
{    
    $lines = (Get-Content C:\Test1\File1.txt) | %{ $_.tolower()}
    
# case insensitive
$hash = @{}
$lines | $hash[$_]++


    

$hash | convertTo-csv > $target

}