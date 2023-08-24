# more ideas
# https://github.com/sushihangover/SushiHangover-PowerShell/blob/master/Microsoft.PowerShell_profile.ps1

c:
cd\
$env:path = @(
    $env:path
    'C:\Program Files (x86)\Notepad++\'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\cmd'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\bin'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\share\git-tfs'
    'C:\Users\admin\AppData\Local\Apps\2.0\C31EKMVW.15A\TWAQ6XY3.BAX\gith..tion_317444273a93ac29_0003.0000_328216539257acd4'
    'C:\Users\admin\AppData\Local\GitHub\lfs-amd64_1.1.0;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319'
) -join ';'


# https://www.reddit.com/r/PowerShell/comments/2x8n3y/getexcuse/
function Get-Excuse {
    (Invoke-WebRequest http://pages.cs.wisc.edu/~ballard/bofh/excuses -OutVariable excuses).content.split([Environment]::NewLine)[(get-random $excuses.content.split([Environment]::NewLine).count)]
}

function fourdigitpw {
    $fpw = 1111
    while ($fpw -split '' | ? {$_} | group | ? count -gt 1) {
        $fpw = -join(1..4 | % {Get-Random -Minimum 0 -Maximum 10})
    }
    $fpw
}

# https://www.reddit.com/r/PowerShell/comments/447t7q/yet_another_random_password_script/
# Add-Type -AssemblyName System.Web
# [System.Web.Security.Membership]::GeneratePassword(12,5)
# random password like Asdf1234
function rpw {
    $pw = ''
    while (($pw -split '' | ? {$_} | group).count -ne 8) {
        $pw = -join$($([char](65..90|Get-Random));$(1..3|%{[char](97..122|Get-Random)});$(1..4|%{0..9|Get-Random}))
    }
    $pw
}

# eject removable drives
function ej ([switch]$more) {
    $count = 0
    if ($more) {
        $drives = [io.driveinfo]::getdrives() | ? {$_.drivetype -notmatch 'Network' -and !(dir $_.name users -ea 0)}
    } else {
        $drives = [io.driveinfo]::getdrives() | ? {$_.drivetype -match 'Removable' -and $_.driveformat -match 'fat32'}
    }
    if ($drives) {
        write-host $($drives | select name, volumelabel, drivetype, driveformat, totalsize | ft -a | out-string)
        $letter = Read-Host "Drive letter ($(if ($drives.count -eq 1) {$drives} else {'?'}))"
        if (!$letter) {$letter = $drives.name[0]}
        $eject = New-Object -ComObject Shell.Application
        $eject.Namespace(17).ParseName($($drives | ? name -Match $letter)).InvokeVerb('Eject')
    }
}

#function py { . C:\Python27\python.exe }
function py { . C:\Users\admin\AppData\Local\Programs\Python\Python35-32\python.exe }

$global:profile_initialized = $false

$gistUrl = "https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e"



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


<#
function prompt {
    #$global:LINE = $global:LINE + 1

    Write-Host "$((get-date).ToString('HH:mm:ss')) " -n #-f Cyan
    #Write-Host ' {' -n -f Yellow
    Write-Host (Shorten-Path (pwd).Path) -n #-f Cyan
    #Write-Host '}' -n -f Yellow
    #Write-Host " $('[' + $($global:LINE) + ']')" -n -f Yellow
    return $(if ($nestedpromptlevel -ge 1) { '>>' }) + '>'
}

$p = {
    function prompt {
        "$((get-date).ToString('HH:mm:ss')) $(Shorten-Path (pwd).Path)" + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '>'
    }
}

#function prompt {
#    "$((get-date).ToString('HH:mm:ss')) $(Shorten-Path (pwd).Path)" + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '>'
#}
#>

function lunch {
    sleep 3000
    Write-Host •
    MessageBox clock in
}

# http://stackoverflow.com/questions/3097589/getting-my-public-ip-via-api
# https://www.reddit.com/r/PowerShell/comments/4parze/formattable_help/
function wimi {
    ((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
}
<#
((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
((iwr https://api.ipify.org/?format=json).content | ConvertFrom-Json).IP
(iwr http://ipv4bot.whatismyipaddress.com/).content
(iwr http://icanhazip.com/).content.trim()
(iwr http://ifconfig.me/ip).content.trim() # takes a long time
(iwr http://checkip.dyndns.org/).content -replace '[^\d.]+' # takes a long time
#>

function java {
    param (
        [switch]$download
    )
    
    if ($download) {
        $page = iwr http://java.com/en/download/windows_offline.jsp
        $version = $page.RawContent -split "`n" | ? {$_ -match 'recommend'} | select -f 1 | % {$_ -replace '^[^v]+| \(.*$'}
        $link = $page.links.href | ? {$_ -match '^http.*download'} | select -f 1
        iwr $link -OutFile "c:\temp\Java $version.exe"
    } else {
        $(iwr http://java.com/en/download).Content.Split("`n") | ? {$_ -match 'version'} | select -f 1
    }
}

#function Format-List {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-List}
#function Format-Table {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-Table}
#if ($LastFormat) {$global:lastobject=$LastFormat; $LastFormat=$Null}

<#
# sal stop stop-process
sal ss select-string
sal wh write-host
sal no New-Object
sal add Add-Member
#>