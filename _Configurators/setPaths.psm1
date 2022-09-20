function retrive-FromCache {
    param(
        [Parameter(Mandatory=$true,
        ParameterSetName='SearchString')]
        [string]$fileToFind,
 
        [Parameter(Mandatory=$false,
        ParameterSetName='externalPath')]
        [string]$workpath
    )
 
$cache = ( get-content '.\appdata\Roaming\Everything\Run History.csv' | ConvertFrom-Csv ) |
 % { [system.io.fileinfo] $_.filename } ; $cache += [system.io.fileinfo] $workpath ; 
 $cacheFullName = ($cache  | ? { ([system.io.fileinfo]$_ | Test-Path) } | ? {$_.name -eq $fileToFind}).fullname ;
  $p =  if($cacheFullName) { $cacheFullName } else { if ($(Test-CommandExists 'everything' )) {(everything 'wfn:$fileToFind')[0]} } ; $p = $p ?? 'unable to set path'  ; 
  if( Test-Path $p ) 
  	{ return $p }
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

$EnvPath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\snipps\snipps$'
$env:Path += ";$EnvPath"

$historyPath = "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath $historyPath 

#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path
$vscodepath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", $vscodepath)

#sqlite dll
$fileToFind = 'System.Data.SQLite.dll'
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\$fileTofind"  ; 

$cache = ( get-content 'C:\Users\chris\AppData\Roaming\Everything\Run History.csv' | ConvertFrom-Csv ) | % { [system.io.fileinfo] $_.filename }
$cache += [system.io.fileinfo] $workpath

$cacheFullName = ($cache  | ? { ([system.io.fileinfo]$_ | Test-Path) } | ? {$_.name -eq $fileToFind}).fullname

$p =  if($cacheFullName) { $cacheFullName } else { if ($(Test-CommandExists 'everything' )) {(everything 'wfn:$fileToFind')[0]} }

$p = $p ?? 'unable to set path' 

		if( Test-Path $p ) 
		{
			Add-Type -Path $p
		}


### local variables
$cache2 = get-content '.\appdata\Roaming\Everything\Run History.csv' | ConvertFrom-Csv | ? { ($_.filename | Test-Path) } | %{[system.io.fileinfo]$_.filename} | ? {$_.name = 'whatpulse.db'}
$watPulseDbPath = $cache2.fullname
$whatPulseDbPath = if(Test-Path $watPulseDbPath){$watPulseDbPath} else {
$whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
if ( $(Test-CommandExists 'everything') ) {$whatPulseDbPath = (Everything 'whatpulse.db')[0]; }
}

[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB


[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY

$datagripPath = '$home\appdata\Roaming\JetBrains\DataGrip2021.1'
[Environment]::SetEnvironmentVariable("datagripPath", $datagripPath)
$bComparePath = 'D:\PortableApps\2. fileOrganization\PortableApps\Beyond Compare 4'
[Environment]::SetEnvironmentVariable("bComparePath", $bComparePath)

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