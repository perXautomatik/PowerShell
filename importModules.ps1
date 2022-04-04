

#------------------------------- Credit to : apfelchips -------------------------------
#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

function Get-ModulesAvailable {
    if ( $args.Count -eq 0 ) {
        Get-Module -ListAvailable
    } else {
        Get-Module -ListAvailable $args
    }
}

function Get-ModulesLoaded {
    if ( $args.Count -eq 0 ) {
        Get-Module -All
    } else {
        Get-Module -All $args
    }
}

function TryImport-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Import-Module $args}
    catch { }
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}
function Install-MyModules {
    PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -AllowClobber
    PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -Force -AllowClobber
    PowerShellGet\Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name PSProfiler -Scope CurrentUser -Force -AllowClobber # --> Measure-Script

    # serialization tools: eg. ConvertTo-HashString / ConvertTo-HashTable https://github.com/torgro/HashData
    PowerShellGet\Install-Module -Name hashdata -Scope CurrentUser -Force - AllowClobber

    # useful Tools eg. ConvertTo-FlatObject, Join-Object... https://github.com/RamblingCookieMonster/PowerShell
    PowerShellGet\Install-Module -Name WFTools -Scope CurrentUser -Force -AllowClobber

    # https://old.reddit.com/r/AZURE/comments/fh0ycv/azuread_vs_azurerm_vs_az/
    # https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell
    PowerShellGet\Install-Module -Name AzureAD -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber

    if ( $IsWindows ){
        # Windows Update CLI tool http://woshub.com/pswindowsupdate-module/#h2_2
        # Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        # native alternative: WindowsUpdateProvider\Install-WUUpdates >= Windows Server 2019
        PowerShellGet\Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
    }
}

function Import-MyModules {
    TryImport-Module PSProfiler
    TryImport-Module hashdata
    TryImport-Module WFTools
    TryImport-Module AzureAD
    TryImport-Module SqlServer
    TryImport-Module PSWindowsUpdate
}

# 引入 posh-git
Import-Module posh-git

# 引入 oh-my-posh
#Import-Module oh-my-posh

# 引入 ps-read-line
Import-Module PSReadLine

# 设置 PowerShell 主题
# Set-PoshPrompt ys
#Set-PoshPrompt paradox
#ps ecoArgs;
#Import-Module echoargs ;
#pscx history;
#Install-Module -Name Pscx
#Import-Module -name pscx   


Add-Type -Path "C:\Users\crbk01\AppData\Local\GMap.NET\DllCache\SQLite_v103_NET4_x64\System.Data.SQLite.DLL"

echo "modules imported"