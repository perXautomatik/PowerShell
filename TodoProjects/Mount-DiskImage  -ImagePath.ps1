<#
$virtualDrivePath = 'U:\VirtualDrive\'

| % {

switch($_.basename)
'BiggerSteamLib' {}

}


Mount-DiskImage  -ImagePath "\\100.84.7.151\NetBackup\VirtualDrive\BiggerSteamLib.vhdx" -NoDriveLetter -Passthru | 
    Get-Disk | 
    Get-Partition | 
    where { ($_ | Get-Volume) -ne $Null } | 
    Add-PartitionAccessPath -AccessPath "D:\SteamV\steamapps\common"

#>
Get-ChildItem '\\100.84.7.151\NetBackup\VirtualDrive\*' -include *.vhdx | select fullname