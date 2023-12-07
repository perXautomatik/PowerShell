
# Source scripts
. "$PSScriptRoot/internal/env.ps1"
. "$PSScriptRoot/internal/aliases.ps1"
. "$PSScriptRoot/internal/functions.ps1"
. "$PSScriptRoot/internal/autocompletions.ps1"


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
Import-Module-Verified "Terminal-Icons" #Load-Module "Terminal-Icons"

Import-Module-Verified "cd-extras" #Load-Module "cd-extras"  

Load-Module "PSReadLine"

. "$PSScriptRoot/internal/loads.ps1"
. "$PSScriptRoot/internal/key-config.ps1"
. "$HOME\.config\powershell\lf_icons.ps1"


# Encoding
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

Set-PSReadLineOption -PredictionSource History

# PSReadLine config. from https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Set-PSReadLineOption -EditMode Emacs

