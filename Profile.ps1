<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Copyright: No copyright. You can use this code for anything with no warranty. 
 #>

if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
}   
 

$pos = ($PSScriptRoot+'\internal\importModules.psm1');
Import-Module -name $pos   -DisableNameChecking -PassThru
Import-Module "$PSScriptRoot/helpers.psm1" -DisableNameChecking -PassThru

if ( Test-IsInteractive )  { 	
# (preferably use -noLogo)
Clear-Host # remove advertisements 
} 

# Source scripts
. "$PSScriptRoot/internal/functions.ps1"
. "$PSScriptRoot/internal/env.ps1"
. "$PSScriptRoot/internal/aliases.ps1"
. "$PSScriptRoot/internal/autocompletions.ps1"

Import-Module "$PSScriptRoot/launch.psm1" -DisableNameChecking

$gistUrl = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"
$latestVersionFile = [System.IO.Path]::Combine("$HOME",'.latest_profile_version')
$versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"

  $global:LASTEXITCODE = $currentLastExitCode
Import-Module-Verified "PSReadLine"

# Encoding
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	


# Increase history
$MaximumHistoryCount = 10000
#------------------------------- Import updateTypeData BEGIN -------------------------------
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
#------------------------------- overloading begin
& "$PSScriptRoot\RO_betterToStringHashMap.ps1";
#------------------------------- Import Modules BEGIN -------------------------------
$profileFolder = $PSScriptRoot

#Import-MyModules; echo "modules imported"
#------------------------------- Import EverythingModules BEGIN -------------------------------
$pos = ($profileFolder+'\internal\EverythingHelpers.psm1');
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import sqlite BEGIN -------------------------------
$pos = ($profileFolder+'\internal\sqlite.psm1')
Import-Module -name $pos  -Scope Global -PassThru

. "$PSScriptRoot/internal/loads.ps1"
. "$PSScriptRoot/internal/key-config.ps1"

Import-Module-Verified "cd-extras" #Load-Module "cd-extras"  

# dahlbyk/posh-git config (adds 300ms to startup)
Import-Module-Verified "posh-git"



function destroyProfile
{
    Set-Content -Path $PROFILE -Value ''
}

function rebuildProfile
{
    $varpath  = ($profileFolder+'\internal\setPaths.psm1');
    timer -message 'adding paths' -script {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
    #-------------------------------   Set Variables BEGIN    -------------------------------
    $varPath = ($profileFolder+'\internal\setVariables.ps1'); 
    timer -message 'adding variables' -script {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
    #-------------------------------   Set alias BEGIN    -------------------------------
    $aliasPath =($profileFolder+'\internal\profileAliases.ps1') ;  $TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType) ;
    timer -message "adding aliases" -script { Add-Content -Path $using:PROFILE -Value (Get-Content $using:aliasPath) } 
    #------------------------------- Console BEGIN -------------------------------
    $aliasPath =($profileFolder+'\internal\prompt.ps1') ; 
    timer -message "import console" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
    #------------------------------- Console BEGIN -------------------------------
    $aliasPath =($profileFolder+'\internal\PsReadLineIntial.ps1') ; 
    timer -message "PsReadLine Intial" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
}


if (( $error | ?{ $_ -match 'everything' } ).length -gt 0)
{
    $everythingError = $true
}

if (( $error | ?{ $_ -match 'sqlite' } ).length     -gt 0)
{
    $sqliteError = $true
}
