cd 'C:\Users\chris\AppData\Roaming\Microsoft\Windows\PowerShell'

Get-ChildItem -Filter *.patch | select -First 1 | % { 

git apply --3way --ignore-space-change --ignore-whitespace -check $_.Name 2>er.txt
$x = Get-Content .\er.txt | select -Last 1
if ( $x -eq "Applied patch PSReadline/ConsoleHost_history.txt cleanly." )
{
mv $_.name cleanly
git commit -m ''
}
else
{
Read-Host "Press enter to continue..."
}
}
