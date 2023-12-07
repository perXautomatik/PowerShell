# Chocolatey profile
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}

# Zoxide - 'z' to jump to directories 😋
Invoke-Expression (& {
	$hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
	(zoxide init --hook $hook powershell) -join "`n"
})

# Scoop-search
Invoke-Expression (&scoop-search --hook)

# node.js version manager
# Why so slow? (200-300 ms impact)
#fnm env --use-on-cd | Out-String | Invoke-Expression


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
