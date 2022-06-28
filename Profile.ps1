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


# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

$profileFolder = (split-path $PROFILE -Parent)

#-------------------------------   Set Variables BEGIN    -------------------------------
$varPath = ($profileFolder+'\setVariables.ps1'); 
$script = {Add-Content -Path $using:PROFILE -Value (Get-Content $using:varpath)}
timer -script $script -message 'adding variables '

#-------------------------------    Set Variables END     -------------------------------

#------------------------------- Import HelperFunctions BEGIN -------------------------------
$pos = ($profileFolder+'\functions.psm1')
timer -message "import HelperFunctions" -script {Import-Module -name $using:pos  -Scope Global -PassThru} 
#------------------------------- Import HelperFunctions END   -------------------------------

#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)
$aliasPath =($profileFolder+'\profileAliases.ps1') ; 
timer -message "adding aliases" -script { Add-Content -Path $using:PROFILE -Value (Get-Content $using:aliasPath) } 
#-------------------------------    Set alias END     -------------------------------

#------------------------------- Import Modules BEGIN -------------------------------
$pos = ($profileFolder+'\importModules.psm1');
timer -message "import modules" -script {Import-Module -name $using:pos  -Scope Global -PassThru}
#------------------------------- Import Modules END   -------------------------------

#------------------------------- Set Paths           -------------------------------
$paths  = ($profileFolder+'\setPaths.psm1');
timer -message "importing paths" -script {Import-Module -name  $using:paths  -Scope Global -PassThru} 
#------------------------------- Set Paths  end       -------------------------------



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
