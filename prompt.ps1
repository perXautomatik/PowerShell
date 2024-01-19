<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

#loadMessage
echo "Microsoft.PowerShell_profile.ps1"

#Requires -Version 6
$MaximumHistoryCount = 10000


#src: https://stackoverflow.com/a/34098997/7595318
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

#if ( Test-IsInteractive )  { 	(preferably use -noLogo) } # Clear-Host # remove advertisements 


function Download-Latest-Profile {
    New-Item $( Split-Path $($PROFILE.CurrentUserCurrentHost) ) -ItemType Directory -ea 0
    if ( $(Get-Content "$($PROFILE.CurrentUserCurrentHost)" | Select-String "62a71500a0f044477698da71634ab87b" | Out-String) -eq "" ) {
        Move-Item -Path "$($PROFILE.CurrentUserCurrentHost)" -Destination "$($PROFILE.CurrentUserCurrentHost).bak"
    }
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/apfelchips/62a71500a0f044477698da71634ab87b/raw/Profile.ps1" -OutFile "$($PROFILE.CurrentUserCurrentHost)"
    Reload-Profile
}

# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

#------------------------------- Set Paths           -------------------------------

$paths = join-path -Path (split-path $profile -Parent)  -ChildPath 'setPaths.ps1'

Import-Module  $paths
#------------------------------- Set Paths  end       -------------------------------

#------------------------------- Import Modules BEGIN -------------------------------

$profileFolder = (split-path $profile -Parent)
$pos = join-path -Path $profileFolder -ChildPath 'importModules.ps1'
 Import-Module $pos
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

#------------------------------- Styling begin --------------------------------------					      
#change selection to neongreen
#https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
$colors = @{
   "Selection" = "$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m"
}
Set-PSReadLineOption -Colors $colors

#------------------------------- Styling begin --------------------------------------	

if ( (($error.length | group).name -eq $null ) -and  (Test-IsInteractive)   ) { 
    Clear-Host # remove advertisements (preferably use -noLogo)
}
	# Keep the existing window title

if ( $(Test-CommandExists 'get-title') )
{

	$windowTitle = (get-title).Trim()

	if ($windowTitle.StartsWith("Administrator:")) {
	    $windowTitle = $windowTitle.Substring(14).Trim()
	}
}
    $nextId = (get-history -count 1).Id + 1;
    # KevMar logging

function prompt {

  $lastSuccess = $?

  $color = @{
    Reset = "`e[0m"
    Red = "`e[31;1m"
    Green = "`e[32;1m"
    Yellow = "`e[33;1m"
    Grey = "`e[37m"
  }

  # set color of PS based on success of last execution
  if ($lastSuccess -eq $false) {
    $lastExit = $color.Red
  } else {
    $lastExit = $color.Green
  }


  # get the execution time of the last command
  $lastCmdTime = ""
  $lastCmd = Get-History -Count 1
  if ($null -ne $lastCmd) {
    $cmdTime = $lastCmd.Duration.TotalMilliseconds
    $units = "ms"
    $timeColor = $color.Green
    if ($cmdTime -gt 250 -and $cmdTime -lt 1000) {
      $timeColor = $color.Yellow
    } elseif ($cmdTime -ge 1000) {
      $timeColor = $color.Red
      $units = "s"
      $cmdTime = $lastCmd.Duration.TotalSeconds
      if ($cmdTime -ge 60) {
        $units = "m"
        $cmdTIme = $lastCmd.Duration.TotalMinutes
      }
    }

    $lastCmdTime = "$($color.Grey)[$timeColor$($cmdTime.ToString("#.##"))$units$($color.Grey)]$($color.Reset) "
  }

  # get git branch information if in a git folder or subfolder
  $gitBranch = ""
  $path = Get-Location
  while ($path -ne "") {
    if (Test-Path (Join-Path $path .git)) {
      $branch = git rev-parse --abbrev-ref --symbolic-full-name --% @{u}

      # handle case where branch is local
      if ($lastexitcode -ne 0) {
        $branch = git rev-parse --abbrev-ref HEAD
      }

      $branchColor = $color.Green

      if ($branch -match "/master") {
        $branchColor = $color.Red
      }
      $gitBranch = " $($color.Grey)[$branchColor$branch$($color.Grey)]$($color.Reset)"
      break
    }

    $path = Split-Path -Path $path -Parent
  }

  # truncate the current location if too long
  $currentDirectory = $executionContext.SessionState.Path.CurrentLocation.Path
  $maxPath = 24
  if ($currentDirectory.Length -gt $maxPath) {
    $currentDirectory = "`u{2026}" + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
  }

  "$($lastExit)PS$($color.Reset) $lastCmdTime$currentDirectory$gitBranch$('>' * ($nestedPromptLevel + 1)) "
}
gcm fsdf -erroraction silentlycontinue
if ( (($error.length | group).name -eq $null ) -and  (Test-IsInteractive)   ) { 
    Clear-Host # remove advertisements (preferably use -noLogo)
}
	# Keep the existing window title

if ( $(Test-CommandExists 'get-title') )
{

	$windowTitle = (get-title).Trim()

	if ($windowTitle.StartsWith("Administrator:")) {
	    $windowTitle = $windowTitle.Substring(14).Trim()
	}
}
    $nextId = (get-history -count 1).Id + 1;
    # KevMar logging
    $LastCmd = Get-History -Count 1
    if ($LastCmd) {
        $lastId = $LastCmd.Id
        Add-Content -Value "# $($LastCmd.StartExecutionTime)" -Path $PSLogPath
        Add-Content -Value "$($LastCmd.CommandLine)" -Path $PSLogPath
        Add-Content -Value '' -Path $PSLogPath
        $howlongwasthat = $LastCmd.EndExecutionTime.Subtract($LastCmd.StartExecutionTime).TotalSeconds
    }

gcm fsdf -erroraction silentlycontinue
	$currentPath = (get-location).Path.replace($home, "~")
	$idx = $currentPath.IndexOf("::")
	if ($idx -gt -1) { $currentPath = $currentPath.Substring($idx + 2) }

	$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity
$title = $currentPath

if ($windowTitle -ne $null)
{
    $title = ($title + "  »  " + $windowTitle)
}

if ($psISE)
{
    $color = "Black";
}
elseif ($windowsPrincipal.IsInRole("Administrators") -eq 1)
{
    $color = "Yellow";
}
else
{
    $color = "Green";
}


    # Kerazy_POSH propmt
    # Get Powershell version information
    $MajorVersion = $PSVersionTable.PSVersion.Major
    $MinorVersion = $PSVersionTable.PSVersion.Minor

    # Detect if the Shell is 32- or 64-bit host
    if ([System.IntPtr]::Size -eq 8) {
        $ShellBits = 'x64 (64-bit)'
    } elseif ([System.IntPtr]::Size -eq 4) {
        $ShellBits = 'x86 (32-bit)'
    }

    # Set Window Title to display Powershell version info, Shell bits, username and computername
    $host.UI.RawUI.WindowTitle = "PowerShell v$MajorVersion.$MinorVersion $ShellBits | $env:USERNAME@$env:USERDNSDOMAIN | $env:COMPUTERNAME | $env:LOGONSERVER"

    # Set Prompt Line 1 - include Date, file path location
    Write-Host(Get-Date -UFormat "%Y/%m/%d %H:%M:%S ($howlongwasthat) | ") -NoNewline -ForegroundColor DarkGreen
    Write-Host(Get-Location) -ForegroundColor DarkGreen

    # Set Prompt Line 2
    # Check for Administrator elevation
    if (Test-IsAdmin) {
        Write-Host '# ADMIN # ' -NoNewline -ForegroundColor Cyan
    } else {        
        Write-Host '# User # ' -NoNewline -ForegroundColor DarkCyan
    }

    if ($psISE) { $color = "Black"; }
    elseif ($windowsPrincipal.IsInRole("Administrators") -eq 1)
    { $color = "Yellow";}
    else{ $color = "Green";}

if ( $(Test-CommandExists 'Write-HgStatus') )
{
	Write-HgStatus (Get-HgStatus)
	Write-GitStatus (Get-GitStatus)
}
	write-host (" [" + $nextId + "]") -NoNewLine -ForegroundColor $color
	if ((get-location -stack).Count -gt 0) { write-host ("+" * ((get-location -stack).Count)) -NoNewLine -ForegroundColor Cyan }


if ( $(Test-CommandExists 'set-title') )
{    $title = $currentPath  
    if ($windowTitle -ne $null) { $title = ($title + "  »  " + $windowTitle) }
	set-title $title
}

	return " "

    Write-Host '»' -NoNewLine -ForeGroundColor Green
    ' ' # need this space to avoid the default white PS>  



# Style default PowerShell Console
$shell = $Host.UI.RawUI

$shell.WindowTitle= "PS"

$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "White"

$colors = $host.PrivateData
$colors.verbosebackgroundcolor = "Magenta"
$colors.verboseforegroundcolor = "Green"
$colors.warningbackgroundcolor = "Red"
$colors.warningforegroundcolor = "white"
$colors.ErrorBackgroundColor = "DarkCyan"
$colors.ErrorForegroundColor = "Yellow"

# Load custom theme for Windows Terminal
#Set-Theme LazyAdmin
Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"
Write-Host "admin: $isAdmin"