$isAdmin = ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }