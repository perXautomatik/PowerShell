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
& "$PSScriptRoot\profileImport.ps1";

#------------------------------- check online for profileUpdates END   -------------------------------

#------------------------------- Import updateTypeData BEGIN -------------------------------
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
#------------------------------- Import updateTypeData END   -------------------------------
#------------------------------- overloading begin
& "$PSScriptRoot\RO_betterToStringHashMap.ps1";
#-------------------------------  overloading end


#------------------------------- Import Modules BEGIN -------------------------------
$pos = ($profileFolder+'\importModules.psm1');
Import-Module -name $pos  -Scope Global -PassThru
Import-MyModules; echo "modules imported"
#------------------------------- Import Modules END   -------------------------------

#------------------------------- Import EverythingModules BEGIN -------------------------------
$pos = ($profileFolder+'\EverythingHelpers.psm1');
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import EverythingModules BEGIN  -------------------------------

#------------------------------- Import GitHelpers BEGIN -------------------------------
$pos = ($profileFolder+'\GitHelpers.psm1');
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import GitHelpers BEGIN  -------------------------------

#------------------------------- Import HelperFunctions BEGIN -------------------------------
$pos = ($profileFolder+'\functions.psm1')
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import HelperFunctions END   -------------------------------

#------------------------------- Import sqlite BEGIN -------------------------------
$pos = ($profileFolder+'\sqlite.psm1')
Import-Module -name $pos  -Scope Global -PassThru
#------------------------------- Import sqlite END   -------------------------------



function destroyProfile
{
    Set-Content -Path $PROFILE -Value ''
}
function rebuildProfile
{
    
    #------------------------------- Cache Paths           ------------------------------- # creates path cache, if not pressent, expect other methods to destroy cache case of false paths. # path file should be simpler to parse than to calling everything
    $varpath  = ($profileFolder+'\setPaths.psm1');
    timer -message 'adding paths' -script {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
    #------------------------------- Cache Paths  end       -------------------------------

    #-------------------------------   Set Variables BEGIN    -------------------------------
    $varPath = ($profileFolder+'\setVariables.ps1'); 
    timer -message 'adding variables' -script {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
    #-------------------------------    Set Variables END     -------------------------------

    #-------------------------------   Set alias BEGIN    -------------------------------
    $aliasPath =($profileFolder+'\profileAliases.ps1') ;  $TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType) ;
    timer -message "adding aliases" -script { Add-Content -Path $using:PROFILE -Value (Get-Content $using:aliasPath) } 
    #-------------------------------    Set alias END     -------------------------------

    #------------------------------- Console BEGIN -------------------------------
    $aliasPath =($profileFolder+'\prompt.ps1') ; 
    timer -message "import console" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
    #------------------------------- Console END   -------------------------------

    #------------------------------- Console BEGIN -------------------------------
    $aliasPath =($profileFolder+'\PsReadLineIntial.ps1') ; 
    timer -message "PsReadLine Intial" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
    #------------------------------- Console END   -------------------------------
    
}


if (( $error | ?{ $_ -match 'everything' } ).length -gt 0)
{
    $everythingError = $true
}

if (( $error | ?{ $_ -match 'sqlite' } ).length     -gt 0)
{
    $sqliteError = $true
}

