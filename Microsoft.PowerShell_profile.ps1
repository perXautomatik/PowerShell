. $env:USERPROFILE\.config\powershell\profile.ps1


#loadMessage
function prompt {
    # Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "Powershell - $pwd";

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host ("Profile:   " + (Split-Path -leaf $MyInvocation.MyCommand.Definition))

Write-Host "This script was invoked by: "+$($MyInvocation.Line)


    # Print -> arrow pompt
    $Host.UI.Write($([char]0x2192))
    return " "
}

$isAdmin=$false
try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
catch { }

$ui = (Get-Host).UI.RawUI
If ($isAdmin) {
    $ui.WindowTitle = "Administrator PowerShell - $pwd"
}
else {
    $ui.WindowTitle = "PowerShell - $pwd"
}
