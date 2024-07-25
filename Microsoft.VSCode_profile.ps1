
#ps setHistorySavePath
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = Join-Path -Path "$HOME" -ChildPath ".local/share" }; $XDG_DATA_HOME = $env:XDG_DATA_HOME
if (-not $env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = Join-Path -Path "$HOME" -ChildPath ".cache" }; $XDG_CACHE_HOME = $env:XDG_CACHE_HOME

if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

$isAdmin = ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }

# Load scripts from the following locations   
$profileFolder = (split-path $profile -Parent)

$EnvPath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\snipps\snipps$'
$env:Path += ";$EnvPath"

    $historyPath = "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
    set-PSReadlineOption -HistorySavePath $historyPath 
    echo "historyPath: $historyPath"

# Sometimes home doesn't get properly set for pre-Vista LUA-style elevated admins
    if ($home -eq "") {
        remove-item -force variable:\home
        $home = (get-content env:\USERPROFILE)
        (get-psprovider 'FileSystem').Home = $home
    }

    if ($env:Snipps -eq "" -or (-not ($env:Snipps))) {
        $env:Snipps = join-path -Path $profileFolder -ChildPath 'snipps'

        if ($snipps -eq "") {
            remove-item -force variable:\snipps
            $snipps = (get-content env:Snipps)
            (get-psprovider 'FileSystem').Snipps = $snipps
        }

        if(Test-Path $env:Snipps)
        {
            $envPath = $env:Snipps
            $env:Path += ";$envPath"
        }
    }

    $modeulePath = Join-Path $profileFolder 'Modules' 
    if(!($modeulePath -in  ($env:PSModulePath).split(";") ))
    {
        $env:PSModulePath += ";$modeulePath";
    }
    echo $env:PSModulePath

    