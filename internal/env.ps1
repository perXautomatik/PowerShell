# General
$Env:PAGER = "less.exe"


# Python
$env:PYTHONIOENCODING="utf-8"
if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:CHEATS_DIR) { $env:CHEATS_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "cheatsheets" }; $CHEATS_DIR = $env:CHEATS_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

$scripts = "$HOME\.config\powershell\Scripts"
$env:path += ";$scripts"
$env:FX_SHOW_SIZE = "true"
# Set dotfiles path (PS module)
$ENV:DOTFILES_DIR = "$HOME/.config" 

# Load scripts from the following locations  

$profileFolder = (split-path $profile -Parent)
$EnvPath = join-path -Path $profileFolder -ChildPath 'Snipps'
echo "EnvPath: $EnvPath"

#$env:Path += ";$EnvPath"

$historyPath = "$home\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath $historyPath
echo "historyPath: $historyPath"

### global variables
$whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
if ( $(Test-CommandExists 'everything') ) {$whatPulseDbPath = (Everything 'whatpulse.db')[0]; }
[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB


[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY

echo "paths set"