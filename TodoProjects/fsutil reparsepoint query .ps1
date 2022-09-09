#cmd /c mklink /d "C:\Steam\" "\\100.84.7.151\NetBackup\Steam\"

#Get-VirtualDisk | Where-Object {$_.IsManualAttach –EQ  $True}


#get-vhd '\\100.84.7.151\NetBackup\VirtualDrive\BiggerSteamLib.vhdx'

#echo "info about junction target" ;  fsutil reparsepoint query 'D:\SteamV\steamapps\common'

& 'C:\ProgramData\chocolatey\bin\junction.exe' -s -q 'C:\'