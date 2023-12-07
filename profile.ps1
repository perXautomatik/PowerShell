
Import-Module "$( $ENV:DOTFILES_DIR )/komorebi/helpers.psm1" -DisableNameChecking
Import-Module "$( $ENV:DOTFILES_DIR )/powershell/helpers.psm1" -DisableNameChecking
Import-Module "$( $ENV:DOTFILES_DIR )/powershell/launch.psm1" -DisableNameChecking
	    
# adds 400ms to startup time
# Import-Module -Name Terminal-Icons

# dahlbyk/posh-git config (adds 300ms to startup)
# Import-Module posh-git

# dahlbyk/posh-git config (adds 300ms to startup)
Import-Module-Verified "posh-git"
Load-Module "posh-git"

# adds 400ms to startup time
Import-Module-Verified "Terminal-Icons"
Load-Module "Terminal-Icons"

Import-Module-Verified "cd-extras"
Load-Module "cd-extras"  

Load-Module "PSReadLine"

# Source scripts
. "$PSScriptRoot/internal/env.ps1"
. "$PSScriptRoot/internal/aliases.ps1"
. "$PSScriptRoot/internal/functions.ps1"
. "$PSScriptRoot/internal/autocompletions.ps1"
. "$PSScriptRoot/internal/loads.ps1"
. "$PSScriptRoot/internal/key-config.ps1"



# Fix Prompt
Clear-Host
$scripts = "$HOME\.config\powershell\Scripts"
$env:path += ";$scripts"
$env:EDITOR = "nvim"
$env:PAGER = "bat"
$env:FX_SHOW_SIZE = "true"
. "$HOME\.config\powershell\lf_icons.ps1"

# Set dotfiles path (PS module)
$DotFilesPath = "$HOME/dotfiles"

### fzf config
$env:FZF_DEFAULT_COMMAND = 'fd --type f'
$env:FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
$env:FZF_ALT_C_COMMAND = "fd --type d"

# Encoding
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

Set-PSReadLineOption -PredictionSource History

# PSReadLine config. from https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Set-PSReadLineOption -EditMode Emacs

### Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# For zoxide v0.8.0+
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
  })


### starship config
# Usage: Add 'Invoke-Expression (&starship init powershell)' to the end of your
# PowerShell $PROFILE. Prerequisites: A Powerline font installed and enabled in
# your terminal. 'starship' suggests installing 'extras/vcredist2019'.
if (Get-Command "starship" -ErrorAction SilentlyContinue) {
    $Env:STARSHIP_CONFIG = "$Env:userprofile\.config\starship.toml"
    $Env:STARSHIP_DISTRO = "SKY"
    Invoke-Expression (&starship init powershell)
}

if (Get-Command "komorebic" -ErrorAction SilentlyContinue) {
    $Env:KOMOREBI_CONFIG_HOME = "$Env:userprofile\.config\komorebi"
    $Env:KOMOREBI_AHK_V1_EXE = "C:\Program Files\AutoHotkey\v1.1.36.02\AutoHotkeyU64.exe"
    $Env:KOMOREBI_AHK_V2_EXE = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"

    function start-tiling {
        komorebic.exe start --await-configuration
        Start-Process -FilePath "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" -ArgumentList "$Env:userprofile\.config\komorebi\komorebi.ahk"
    }

    function stop-tiling {
        komorebic.exe restore-windows

        Stop-Process -Name "komorebi" -Force -ErrorAction SilentlyContinue
        Stop-Process -Name "pythonw" -Force -ErrorAction SilentlyContinue
    }

}      
