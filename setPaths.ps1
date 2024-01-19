function retrive-FromCache {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SearchString,
 
        [Parameter(Mandatory=$false)]        
        [string]$externalPath
    )
 
$cache = ( get-content '.\appdata\Roaming\Everything\Run History.csv' | ConvertFrom-Csv ) |
 % { [system.io.fileinfo] $_.filename } ;
 if (!([string]::IsNullOrEmpty($externalPath)) )
 { $cache += [system.io.fileinfo] $externalPath ; }
 $cacheFullName = ($cache  | ? { ([system.io.fileinfo]$_ | Test-Path) } | ? {$_.name -eq $SearchString}).fullname ;
  $p = $( if($cacheFullName) { $cacheFullName } else { if($(Test-CommandExists 'everything' )) { if( $(everything 'wfn:$SearchString') ) {(everything 'wfn:$SearchString')}}})    
    
     ; $p = $p ?? 'unable to set path'  ; 
  if( Test-Path $p ) 
  	{ return ($p | select -First 1 ) }
}

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
$profileFolder = (split-path $profile -Parent)


$EnvPath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\snipps\snipps$'
$fileToFind = '\snipps'
$workpath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\$fileToFind' ;
$EnvPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
$env:Path += ";$EnvPath"


$fileToFind = 'ConsoleHost_history.txt'
$workpath =  "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\$fileToFind" ; 
$historyX = "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )

if( test-path $historyX) {$global:historyPath = $historyX} else {"$historyX not found"}

#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path

$fileToFind = 'vscode-portable.exe'
$vscodepath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", (retrive-FromCache -SearchString $fileToFind -externalPath $workpath ))
if( test-path $vscodepath) {[Environment]::SetEnvironmentVariable("code", $vscodepath)} else {"$vscodepath not found"}


#sqlite dll
$fileToFind = 'System.Data.SQLite.dll'
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\$fileTofind"  ; 
Add-Type -Path (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
if (Test-ModuleExists 'pseverything') {
$alternative = @(everything 'wfn:System.Data.SQLite.DLL')[0] ;
$p = if(Test-Path $workpath){$workpath} else {$alternative} ;
Add-Type -Path $p
}
else
{"pseverything not loaded" ; "sqlite not loaded"}

		}
	}
### local variables

$global:whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
if (Test-ModuleExists 'pseverything') { $global:whatPulseDbPath = @(Everything 'whatpulse.db')[0];
$fileToFind = 'whatpulse.db'
$whatPulseDbPath = (retrive-FromCache -SearchString $fileToFind)

[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB
} else {"whatPulseDbpath not set"}

[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY

$fileToFind = 'DataGrip2021.1'
$datagripx = '$home\appdata\Roaming\JetBrains\DataGrip2021.1'
if (test-path $datagripx) { $global:datagripPath = $datagripx ; [Environment]::SetEnvironmentVariable("datagripPath", $datagripx) } else {"datagrippath not set"}
$datagripPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
[Environment]::SetEnvironmentVariable("datagripPath", $datagripPath)


$fileToFind = 'Beyond Compare 4'
$bcompareX = 'D:\PortableApps\2. fileOrganization\PortableApps\Beyond Compare 4'
$bComparePath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
if (test-path $bcompareX) { $global:bComparePath = $bcompareX ; [Environment]::SetEnvironmentVariable("bComparePath", $bcompareX)
} else {"bcompare path not set"}
#-------------------------------    Functions END     -------------------------------

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"

echo "paths set"
echo "XDG_CONFIG_HOME $env:XDG_CONFIG_HOME"
echo "XDG_DATA_HOME $env:XDG_DATA_HOME"
echo "XDG_CACHE_HOME $env:XDG_CACHE_HOME"
echo "DESKTOP_DIR $env:DESKTOP_DIR"
echo "NOTES_DIR $env:NOTES_DIR"
echo "CHEATS_DIR $env:CHEATS_DIR"
echo "TODO_DIR $env:TODO_DIR"
echo "DEVEL_DIR $env:DEVEL_DIR"
echo "PORTS_DIR $env:PORTS_DIR"
echo "WHATPULSE_DB $env:WHATPULSE_DB"
echo "WHATPULSE_QUERY $env:WHATPULSE_QUERY"
echo "datagripPath $env:datagripPath"
echo "bComparePath $env:bComparePath"
echo "snipps $EnvPath"
$historyPath =  (get-PSReadlineOption).HistorySavePath;
echo "historyPath: $historyPath"
echo "VscodePath $env:code"