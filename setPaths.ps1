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



$fileToFind = '\snipps'
$workpath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\$fileToFind' ;
$EnvPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
$env:Path += ";$EnvPath"


$fileToFind = 'ConsoleHost_history.txt'
$workpath =  "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\$fileToFind" ; 
set-PSReadlineOption -HistorySavePath (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )

#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path

$fileToFind = 'vscode-portable.exe'
$workpath =  "D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\$fileTofind"  ; 
[Environment]::SetEnvironmentVariable("code", (retrive-FromCache -SearchString $fileToFind -externalPath $workpath ))

#sqlite dll
$fileToFind = 'System.Data.SQLite.dll'
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\$fileTofind"  ; 
Add-Type -Path (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )



### local variables

$whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"

$fileToFind = 'whatpulse.db'
$whatPulseDbPath = (retrive-FromCache -SearchString $fileToFind)

[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB

[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY

$fileToFind = 'DataGrip2021.1'
$workpath = "$home\appdata\Roaming\JetBrains\$fileTofind"  ; 
$datagripPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
[Environment]::SetEnvironmentVariable("datagripPath", $datagripPath)


$fileToFind = 'Beyond Compare 4'
$workpath = "D:\PortableApps\2. fileOrganization\PortableApps\$fileTofind"  ; 
$bComparePath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
[Environment]::SetEnvironmentVariable("bComparePath", $bComparePath)

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