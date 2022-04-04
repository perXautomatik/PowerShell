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
# $0: %UserProfile%\Documents\PowerShell\Profile.ps1 # for PS-Core
# src:

$gistUrl = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"
$latestVersionFile = [System.IO.Path]::Combine("$HOME",'.latest_profile_version')
$versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"

if ([System.IO.File]::Exists($latestVersionFile)) {
  $latestVersion = [System.IO.File]::ReadAllText($latestVersionFile)
  $currentProfile = [System.IO.File]::ReadAllText($profile)
  [version]$currentVersion = "0.0.0"
  if ($currentProfile -match $versionRegEx) {
    $currentVersion = $matches.Version
  }

  if ([version]$latestVersion -gt $currentVersion) {
    Write-Verbose "Your version: $currentVersion" -Verbose
    Write-Verbose "New version: $latestVersion" -Verbose
    $choice = Read-Host -Prompt "Found newer profile, install? (Y)"
    if ($choice -eq "Y" -or $choice -eq "") {
      try {
        $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop
        $gistProfile = $gist.Files."profile.ps1".Content
        Set-Content -Path $profile -Value $gistProfile
        Write-Verbose "Installed newer version of profile" -Verbose
        . $profile
        return
      }
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
      }
    }
  }
}

$global:profile_initialized = $false
$Profile.CurrentUserCurrentHost = $PSCommandPath # this file is my Profile
# Runs all .ps1 files in this module's directory
Get-ChildItem -Path $PSScriptRoot\*.ps1 | ? name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }
function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}
function Select-Value { # src: https://geekeefy.wordpress.com/2017/06/26/selecting-objects-by-value-in-powershell/
    [Cmdletbinding()]
    param(
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )
    process {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name
        If ( $Property ) {
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}

# http://blogs.msdn.com/b/powershell/archive/2006/06/24/644987.aspx

function prompt {

  function Initialize-Profile {

    $null = Start-ThreadJob -Name "Get version of `$profile from gist" -ArgumentList $gistUrl, $latestVersionFile, $versionRegEx -ScriptBlock {
      param ($gistUrl, $latestVersionFile, $versionRegEx)

      try {
        $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop

        $gistProfile = $gist.Files."profile.ps1".Content
        [version]$gistVersion = "0.0.0"
        if ($gistProfile -match $versionRegEx) {
          $gistVersion = $matches.Version
          Set-Content -Path $latestVersionFile -Value $gistVersion
        }
      }
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist to check for newer version"
      }
    }

    if ((Get-Module PSReadLine).Version -lt 2.2) {
      throw "Profile requires PSReadLine 2.2+"
    }
  $global:LASTEXITCODE = $currentLastExitCode
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
# http://get-powershell.com/post/2008/06/25/Stuffing-the-output-of-the-last-command-into-an-automatic-variable.aspx
function Out-Default {
    if ($input.GetType().ToString() -ne 'System.Management.Automation.ErrorRecord') {
        try {
            $input | Tee-Object -Variable global:lastobject | Microsoft.PowerShell.Core\Out-Default
        } catch {
            $input | Microsoft.PowerShell.Core\Out-Default
        }
    } else {
        $input | Microsoft.PowerShell.Core\Out-Default
    }
}
if ((Get-ExecutionPolicy) -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
}

Function IIf($If, $IfTrue, $IfFalse) {
    If ($If) {If ($IfTrue -is "ScriptBlock") {&$IfTrue} Else {$IfTrue}}
    Else {If ($IfFalse -is "ScriptBlock") {&$IfFalse} Else {$IfFalse}}
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if($args.Count -eq 0){
        Get-Childitem env:
    }
    elseif($args.Count -eq 1) {
        Start-Process (Get-Command $args[0]).Source
    }
    else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}
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

# Increase history
$MaximumHistoryCount = 10000

function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }

function git-root {
    $gitrootdir = (git rev-parse --show-toplevel)
    if ($gitrootdir) {
        Set-Location $gitrootdir
    }
}
# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

$profileFolder = (split-path $PROFILE -Parent)

#------------------------------- Import Modules BEGIN -------------------------------
$pos = ($profileFolder+'\importModules.psm1');
Import-Module -name $pos  -Scope Global -PassThru
Import-MyModules; echo "modules imported"
#------------------------------- Import Modules END   -------------------------------

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
$aliasPath =($profileFolder+'\console.ps1') ; 
timer -message "import console" -script {Add-Content -Path $using:Profile -Value (Get-Content $using:aliasPath) } 
#------------------------------- Console END   -------------------------------


#------------------------------- overloading begin

#https://www.sapien.com/blog/2014/10/21/a-better-tostring-method-for-hash-tables/

#better hashtable ToString method
Update-TypeData -TypeName "System.Collections.HashTable"   `
-MemberType ScriptMethod `
-MemberName "ToString" -Value { $hashstr = "@{"; $keys = $this.keys; foreach ($key in $keys) { $v = $this[$key];
       if ($key -match "\s") { $hashstr += "`"$key`"" + "=" + "`"$v`"" + ";" }
       else { $hashstr += $key + "=" + "`"$v`"" + ";" } }; $hashstr += "}";
       return $hashstr }
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
