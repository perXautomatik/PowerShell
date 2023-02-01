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

function doImport()
{
    function im($pt) {Import-Module -name ($profileFolder+'\'+$pt+'.psm1')  -Scope Global -PassThru}

    'importModules', 'EverythingHelpers', 'GitHelpers', 'functions', 'sqlite' | % { im -pt $_ }

    Import-MyModules; echo "modules imported"
}

    doImport

function destroyProfile {Set-Content -Path $PROFILE -Value ''}

function rebuildProfile
{
    
    function adC ($u) { 
    
        $varpath  = ($profileFolder+'\'+$u+'.ps1');
        timer -message $u -script {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}

    }
    
    'setPaths','setVariables','profileAliases','prompt','PsReadLineIntial' | % { adc -u $_ }
    
     $TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ;
      $TAType::Add('accelerators',$TAType) ;
    
}


if (( $error | ?{ $_ -match 'everything' } ).length -gt 0)
{
    $everythingError = $true
}

if (( $error | ?{ $_ -match 'sqlite' } ).length     -gt 0)
{
    $sqliteError = $true
}

