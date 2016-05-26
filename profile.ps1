<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>
# Runs all .ps1 files in this module's directory
Get-ChildItem -Path $PSScriptRoot\*.ps1 | ? name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }
# http://blogs.msdn.com/b/powershell/archive/2006/06/24/644987.aspx
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
# http://get-powershell.com/post/2008/06/25/Stuffing-the-output-of-the-last-command-into-an-automatic-variable.aspx
function Out-Default {
    try {
        $input | Tee-Object -Variable global:lastobject | Microsoft.PowerShell.Core\Out-Default
    } catch {
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
