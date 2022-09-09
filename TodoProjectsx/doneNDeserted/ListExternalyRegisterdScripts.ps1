Get-Command -CommandType ExternalScript |Select-Object -property Name,Path,
@{Name="LastWriteTime";Expression={(Get-Item $_.path).lastWriteTime}},
@{Name="Location";Expression={Split-Path $_.source}} | 
Sort-Object -Property Location |
Format-Table -GroupBy Location -property Name,LastWriteTime