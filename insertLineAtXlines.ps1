$File = Get-Content D:\Documents\sotvattenfastigheter.sql
$length = $File.Count
$offset = 5
$firstLine = $File[1]; 
$i = $offset

do
{
    if($i%900 -eq 0) {
    $Line = $File[$i-1].Substring(0, $File[$i-1].LastIndexOf(","))
    $InsertLine = $firstLine

    $NewData = "$Line

    $InsertLine"

    $File[$i-1] = $NewData
    $i = $i+$offset
    }
    else
    {
        $i++;
    }

}
While ($i -le $length)

$File | Set-Clipboard