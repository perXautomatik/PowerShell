#Requires -Version 7

# Version 1.2.10

# check if newer version
<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty. 
 #>


if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
}
# $0: %UserProfile%\Documents\PowerShell\Profile.ps1 # for PS-Core
# src:
$Profile.CurrentUserCurrentHost = $PSCommandPath # this file is my Profile
$global:profile_initialized = $false

$gistUrl = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"
$latestVersionFile = [System.IO.Path]::Combine("$HOME",'.latest_profile_version')
$versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"


# Increase history
$MaximumHistoryCount = 10000

  $global:LASTEXITCODE = $currentLastExitCode

function timer($script,$message){
    $t = [system.diagnostics.stopwatch]::startnew()
    $job = Start-ThreadJob -ScriptBlock $script
    
    while($job.state -ne "Completed"){    
        Write-Output = "$message Elapsed: $($t.elapsed) "                
        start-sleep 1
    }
    $t.stop()
    $job | Receive-Job
}


# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

$profileFolder = (split-path $PROFILE -Parent)

#------------------------------- check online for profileUpdates BEGIN -------------------------------
# downloads and set version numbers
.\profileImport.ps1
#------------------------------- check online for profileUpdates END   -------------------------------

#------------------------------- Import updateTypeData BEGIN -------------------------------
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
#------------------------------- Import updateTypeData END   -------------------------------

#------------------------------- Import Modules BEGIN -------------------------------
$pos = ($profileFolder+'\importModules.psm1');
Import-Module -name $pos  -Scope Global -PassThru
Import-MyModules; echo "modules imported"
#------------------------------- Import Modules END   -------------------------------

#------------------------------- Import EverythingModules BEGIN -------------------------------
$pos = ($profileFolder+'\EverythingHelpers.psm1');
Import-Module -name $pos  -Scope Global -PassThru
Import-MyModules; echo "modules imported"
#------------------------------- Import EverythingModules BEGIN  -------------------------------

#------------------------------- Import GitHelpers BEGIN -------------------------------
$pos = ($profileFolder+'\GitHelpers.psm1');
Import-Module -name $pos  -Scope Global -PassThru
Import-MyModules; echo "modules imported"
#------------------------------- Import GitHelpers BEGIN  -------------------------------

#------------------------------- Import HelperFunctions BEGIN -------------------------------
$pos = ($profileFolder+'\functions.psm1')
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import HelperFunctions END   -------------------------------

#------------------------------- Set Paths           -------------------------------
$varpath  = ($profileFolder+'\setPaths.psm1');
$script = {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
timer -script $script -message 'adding paths '

#------------------------------- Set Paths  end       -------------------------------


#-------------------------------   Set Variables BEGIN    -------------------------------
$varPath = ($profileFolder+'\setVariables.ps1'); 
$script = {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
timer -script $script -message 'adding variables '

#-------------------------------    Set Variables END     -------------------------------

#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)
$aliasPath =($profileFolder+'\profileAliases.ps1') ; 
timer -message "adding aliases" -script { Add-Content -Path $using:PROFILE -Value (Get-Content $using:aliasPath) } 
#-------------------------------    Set alias END     -------------------------------

#------------------------------- Console BEGIN -------------------------------
$aliasPath =($profileFolder+'\prompt.ps1') ; 
timer -message "import console" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
#------------------------------- Console END   -------------------------------


#------------------------------- overloading begin
    & .\RO_betterToStringHashMaps.ps1
#-------------------------------  overloading end


#------------------------------- SystemMigration      -------------------------------

#choco check if installed
#path to list of aps to install
#choco ask to install if not present

#list of portable apps,download source
#path
#download and extract if not present, ask to confirm

#path to portable apps
#path to standard download location


#git Repos paths and origions,
#git systemwide profile folder
#git global path

#everything data folder
#autohotkey script to run on startup

#startup programs

#reg to add if not present

#------------------------------- SystemMigration end  -------------------------------

if (( $error | ?{ $_ -match 'everything' } ).length -gt 0)
{
    $everythingError = $true
}

if (( $error | ?{ $_ -match 'sqlite' } ).length     -gt 0)
{
    $sqliteError = $true
}

