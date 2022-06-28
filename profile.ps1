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


Function IIf($If, $IfTrue, $IfFalse) {
    If ($If) {If ($IfTrue -is "ScriptBlock") {&$IfTrue} Else {$IfTrue}}
    Else {If ($IfFalse -is "ScriptBlock") {&$IfFalse} Else {$IfFalse}}
}


function timer($script, $interval = 1,$message){
    $t = [system.diagnostics.stopwatch]::startnew()
    $job = start-job -script $script
    while($job.state -eq "running"){
    $results =  [PSCustomObject]@{
            messageT = "$message Elapsed: $($t.elapsed) "
            results = $job | Receive-Job
        }
        start-sleep $interval
    }
    $t.stop()
    return $results
}

# Increase history
$MaximumHistoryCount = 10000


# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

$profileFolder = (split-path $profile -Parent)

#-------------------------------   Set Variables BEGIN    -------------------------------

$aliasPath = ($profile | Split-Path -Parent)+'\setVariables.ps1'
timer -message "Setting variables" -script { Add-Content -Path $Profile -Value (Get-Content $aliasPath) }

#-------------------------------    Set Variables END     -------------------------------

#------------------------------- Import HelperFunctions BEGIN -------------------------------
$pos = join-path -Path $profileFolder -ChildPath 'functions.ps1'
timer -message "import HelperFunctions" -script {Import-Module $pos}
#------------------------------- Import HelperFunctions END   -------------------------------

#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)
$aliasPath = ($profile | Split-Path -Parent)+'\profileAliases.ps1'
timer -message "loading aliases" -script { Add-Content -Path $Profile -Value (Get-Content $aliasPath) }

#-------------------------------    Set alias END     -------------------------------

#------------------------------- Set Paths           -------------------------------

$paths = join-path -Path (split-path $profile -Parent)  -ChildPath 'setPaths.ps1'
timer -message "set paths" -script {Import-Module  $paths}
#------------------------------- Set Paths  end       -------------------------------

#------------------------------- Import Modules BEGIN -------------------------------

$pos = join-path -Path $profileFolder -ChildPath 'importModules.ps1'
timer -message "import modules" -script {Import-Module $pos}
#------------------------------- Import Modules END   -------------------------------


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


