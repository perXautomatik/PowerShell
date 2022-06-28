
#ps setHistorySavePath
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = Join-Path -Path "$HOME" -ChildPath ".local/share" }; $XDG_DATA_HOME = $env:XDG_DATA_HOME
if (-not $env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = Join-Path -Path "$HOME" -ChildPath ".cache" }; $XDG_CACHE_HOME = $env:XDG_CACHE_HOME

if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:CHEATS_DIR) { $env:CHEATS_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "cheatsheets" }; $CHEATS_DIR = $env:CHEATS_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

if (-not $env:DEVEL_DIR) { $env:DEVEL_DIR = Join-Path -Path "$HOME" -ChildPath "devel" }; $DEVEL_DIR = $env:DEVEL_DIR
if (-not $env:PORTS_DIR) { $env:PORTS_DIR = Join-Path -Path "$HOME" -ChildPath "ports" }; $PORTS_DIR = $env:PORTS_DIR

# Load scripts from the following locations   

$EnvPath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\snipps\snipps$'
$env:Path += ";$EnvPath"

$historyPath = "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath $historyPath 
echo "historyPath: $historyPath"

#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path
$vscodepath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", $vscodepath)

#sqlite dll
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\System.Data.SQLite.dll"  ; 

if ( $(Test-CommandExists 'everything') ) {$alternative = (everything 'wfn:System.Data.SQLite.DLL')[0] ;}

$p = if(Test-Path $workpath){$workpath} else {$alternative} ;
$p = $p ?? 'unable to set path' 

		if( Test-Path $p ) 
		{
			Add-Type -Path $p
			echo $p 
		}

### local variables
$whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
if ( $(Test-CommandExists 'everything') ) {$whatPulseDbPath = (Everything 'whatpulse.db')[0]; }
[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB


[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY




$datagripPath = '$home\appdata\Roaming\JetBrains\DataGrip2021.1'
[Environment]::SetEnvironmentVariable("datagripPath", $datagripPath)
$bComparePath = 'D:\PortableApps\2. fileOrganization\PortableApps\Beyond Compare 4'
[Environment]::SetEnvironmentVariable("bComparePath", $bComparePath)

echo "paths set"
$isAdmin = ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }
# Alias File
# Computer : 5CG84229D5
# Date/Time : 28 June 2022 13:24:18
# Exported by : crbk01



set-alias -Name:"accelerators" -Value:"[accelerators]::Get" -Description:"" -Option:"None"
set-alias -Name:"basename" -Value:"Split-Path" -Description:"" -Option:"AllScope"
set-alias -Name:"bcompare" -Value:"start-bc" -Description:"" -Option:"AllScope"
set-alias -Name:"browserflags" -Value:"start-BrowserFlags" -Description:"" -Option:"AllScope"
set-alias -Name:"cat" -Value:"Get-Content" -Description:"" -Option:"AllScope"
set-alias -Name:"cd" -Value:"Set-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"chdir" -Value:"Set-Location" -Description:"" -Option:"AllScope"

set-alias -Name:"clear" -Value:"Clear-Host" -Description:"" -Option:"AllScope"



set-alias -Name:"cls" -Value:"Clear-Host" -Description:"" -Option:"AllScope"



set-alias -Name:"copy" -Value:"Copy-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"cp" -Value:"Copy-Item" -Description:"" -Option:"AllScope"




set-alias -Name:"del" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"df" -Value:"get-volume" -Description:"" -Option:"AllScope"

set-alias -Name:"dir" -Value:"Get-Childitem" -Description:"" -Option:"AllScope"


set-alias -Name:"echo" -Value:"Write-Output" -Description:"" -Option:"AllScope"
set-alias -Name:"edprofile" -Value:"start-Notepad-Profile" -Description:"" -Option:"None"
set-alias -Name:"env" -Value:"Get-Environment" -Description:"      custom   aliases" -Option:"AllScope"


set-alias -Name:"erase" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"etsn" -Value:"Enter-PSSession" -Description:"" -Option:"None"
set-alias -Name:"everything" -Value:"invoke-Everything" -Description:"" -Option:"AllScope"
set-alias -Name:"executeThis" -Value:"invoke-FuzzyWithEverything" -Description:"" -Option:"AllScope"
set-alias -Name:"exp-pro" -Value:"open-ProfileFolder" -Description:"" -Option:"None"
set-alias -Name:"exsn" -Value:"Exit-PSSession" -Description:"" -Option:"None"

set-alias -Name:"fhx" -Value:"Format-Hex" -Description:"" -Option:"None"
set-alias -Name:"filesinfolasstream" -Value:"read-pathsAsStream" -Description:"" -Option:"AllScope"

set-alias -Name:"flush-dns" -Value:"Clear-DnsClientCache" -Description:"" -Option:"AllScope"






set-alias -Name:"gcb" -Value:"Get-Clipboard" -Description:"" -Option:"None"





set-alias -Name:"getip" -Value:"Get-IPv4Routes" -Description:"" -Option:"AllScope"
set-alias -Name:"getip6" -Value:"Get-IPv6Routes" -Description:"" -Option:"AllScope"
set-alias -Name:"getnic" -Value:"get-mac" -Description:"" -Option:"AllScope"


set-alias -Name:"gin" -Value:"Get-ComputerInfo" -Description:"" -Option:"None"
set-alias -Name:"GitAdEPathAsSNB" -Value:"invoke-GitSubmoduleAdd" -Description:"" -Option:"AllScope"
set-alias -Name:"gitSilently" -Value:"invoke-GitLazySilently" -Description:"" -Option:"AllScope"
set-alias -Name:"gitSingleRemote" -Value:"invoke-gitFetchOrig" -Description:"" -Option:"AllScope"
set-alias -Name:"gitsplit" -Value:"subtree-split-rm-commit" -Description:"" -Option:"AllScope"
set-alias -Name:"GitUp" -Value:"invoke-GitLazy" -Description:"" -Option:"AllScope"
set-alias -Name:"gjb" -Value:"Get-Job" -Description:"" -Option:"None"







set-alias -Name:"gsn" -Value:"Get-PSSession" -Description:"" -Option:"None"

set-alias -Name:"gtz" -Value:"Get-TimeZone" -Description:"" -Option:"None"


set-alias -Name:"h" -Value:"Get-History" -Description:"" -Option:"None"
set-alias -Name:"history" -Value:"Get-History" -Description:"" -Option:"AllScope"
set-alias -Name:"HistoryPath" -Value:"(Get-PSReadlineOption).HistorySavePath" -Description:"" -Option:"AllScope"
set-alias -Name:"home" -Value:"open-here" -Description:"" -Option:"AllScope"
set-alias -Name:"icm" -Value:"Invoke-Command" -Description:"" -Option:"None"







set-alias -Name:"isFolder" -Value:"get-isFolder" -Description:"" -Option:"AllScope"

set-alias -Name:"kill" -Value:"Stop-Process" -Description:"" -Option:"AllScope"
set-alias -Name:"lp" -Value:"Out-Printer" -Description:"" -Option:"AllScope"
set-alias -Name:"ls" -Value:"Get-ChildItem" -Description:"" -Option:"None"
set-alias -Name:"lsx" -Value:"get-Childnames" -Description:"" -Option:"AllScope"
set-alias -Name:"make" -Value:"invoke-Nmake" -Description:"" -Option:"AllScope"
set-alias -Name:"man" -Value:"help" -Description:"" -Option:"None"
set-alias -Name:"md" -Value:"mkdir" -Description:"" -Option:"AllScope"


set-alias -Name:"mount" -Value:"New-PSDrive" -Description:"" -Option:"None"
set-alias -Name:"move" -Value:"Move-Item" -Description:"" -Option:"AllScope"

set-alias -Name:"mv" -Value:"Move-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"MyAliases" -Value:"read-aliases" -Description:"" -Option:"AllScope"




set-alias -Name:"nsn" -Value:"New-PSSession" -Description:"" -Option:"None"



set-alias -Name:"open" -Value:"Invoke-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"OpenAsADmin" -Value:"invoke-powershellAsAdmin" -Description:"" -Option:"AllScope"
set-alias -Name:"os-update" -Value:"Update-Packages" -Description:"" -Option:"AllScope"
set-alias -Name:"parameters" -Value:"get-parameters" -Description:"" -Option:"None"
set-alias -Name:"pastDo" -Value:"find-historyInvoke" -Description:"" -Option:"AllScope"
set-alias -Name:"pastDoEdit" -Value:"find-historyAppendClipboard" -Description:"" -Option:"AllScope"
set-alias -Name:"popd" -Value:"Pop-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"printpaths" -Value:"read-EnvPaths" -Description:"" -Option:"AllScope"
set-alias -Name:"ps" -Value:"Get-Process" -Description:"" -Option:"AllScope"
set-alias -Name:"psVersion" -Value:"$PSVersionTable.PSVersion.Major " -Description:"" -Option:"AllScope"
set-alias -Name:"pushd" -Value:"Push-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"pwd" -Value:"Get-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"r" -Value:"Invoke-History" -Description:"" -Option:"None"

set-alias -Name:"rcjb" -Value:"Receive-Job" -Description:"" -Option:"None"

set-alias -Name:"rd" -Value:"Remove-Item" -Description:"" -Option:"AllScope"

set-alias -Name:"realpath" -Value:"Resolve-Path" -Description:"cmd-like" -Option:"AllScope"
set-alias -Name:"reboot" -Value:"exit-Nrenter" -Description:"" -Option:"AllScope"
set-alias -Name:"refreshenv" -Value:"Update-SessionEnvironment" -Description:"" -Option:"None"
set-alias -Name:"reload" -Value:"initialize-profile" -Description:"" -Option:"AllScope"
set-alias -Name:"remote" -Value:"invoke-gitRemote" -Description:"" -Option:"AllScope"
set-alias -Name:"ren" -Value:"Rename-Item" -Description:"" -Option:"AllScope"

set-alias -Name:"rjb" -Value:"Remove-Job" -Description:"" -Option:"None"
set-alias -Name:"rm" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"rmdir" -Value:"Remove-Item" -Description:"" -Option:"AllScope"




set-alias -Name:"rsn" -Value:"Remove-PSSession" -Description:"" -Option:"None"


set-alias -Name:"sajb" -Value:"Start-Job" -Description:"" -Option:"None"




set-alias -Name:"scb" -Value:"Set-Clipboard" -Description:"" -Option:"None"

set-alias -Name:"set" -Value:"Set-Variable" -Description:"" -Option:"AllScope"




set-alias -Name:"sls" -Value:"Select-String" -Description:"" -Option:"None"


set-alias -Name:"spjb" -Value:"Stop-Job" -Description:"" -Option:"None"



set-alias -Name:"start-powershellAsAdmin" -Value:"invoke-powershellAsAdmin" -Description:"" -Option:"AllScope"
set-alias -Name:"start-su" -Value:"start-powershellAsAdmin" -Description:"" -Option:"None"
set-alias -Name:"stz" -Value:"Set-TimeZone" -Description:"" -Option:"None"


set-alias -Name:"touch" -Value:"Set-FileTime" -Description:"" -Option:"AllScope"
set-alias -Name:"type" -Value:"Get-Content" -Description:"" -Option:"AllScope"
set-alias -Name:"uptime" -Value:"read-uptime" -Description:"" -Option:"AllScope"
set-alias -Name:"version" -Value:"System.Management.Automation.PSVersionHashTable" -Description:"bash-like" -Option:"None"

set-alias -Name:"which" -Value:"Get-Command" -Description:"" -Option:"AllScope"
set-alias -Name:"wjb" -Value:"Wait-Job" -Description:"" -Option:"None"

