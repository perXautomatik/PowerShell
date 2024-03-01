#Requires -Version 7

# Version 1.2.13

# check if newer version
$gistid = "62a71500a0f044477698da71634ab87b"
$gistUrl = "https://api.github.com/gists/$gistid"
$latestVersionFile = [System.IO.Path]::Combine("$HOME",'.latest_profile_version')
$versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"
$global:profile_initialized = $false

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
	    $null = Start-ThreadJob -Name "Get version of `$profile from gist" -ArgumentList $gistUrl, $latestVersionFile, $versionRegEx -ScriptBlock 
		{
	      param ($gistUrl, $latestVersionFile, $versionRegEx)
	
	        $gist = Invoke-RestMethod $gistUrl -ErrorAction Stop    	
	        $gistProfile = $gist.Files."profile.ps1".Content
	        [version]$gistVersion = "0.0.0"
	        if ($gistProfile -match $versionRegEx) {
	          $gistVersion = $matches.Version
			    New-Item $( Split-Path $($PROFILE.CurrentUserCurrentHost) ) -ItemType Directory -ea 0
			    if ( $(Get-Content "$($PROFILE.CurrentUserCurrentHost)" | Select-String $gistId | Out-String) -eq "" ) {
			        Move-Item -Path "$($PROFILE.CurrentUserCurrentHost)" -Destination "$($PROFILE.CurrentUserCurrentHost).bak"
			    }
	    Set-Content -Path $latestVersionFile -Value $gistVersion
        Set-Content -Path $profile -Value $gistProfile
        Write-Verbose "Installed newer version of profile" -Verbose
        . $profile
        return
      }
      }
      }
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
      }    
  }
}
}



function prompt {

  function Initialize-Profile {        
	  
	if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name PSReadLine)) ) {
	    # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
	    TryImport-Module PSReadLine

    if ((Get-Module PSReadLine).Version -lt 2.2) {
      throw "Profile requires PSReadLine 2.2+"
    }

    # setup psdrives
    if ([System.IO.File]::Exists([System.IO.Path]::Combine("$HOME",'test'))) {
      New-PSDrive -Root ~/test -Name Test -PSProvider FileSystem -ErrorAction Ignore > $Null
    }

    if (!(Test-Path repos:)) {
      if (Test-Path ([System.IO.Path]::Combine("$HOME",'git'))) {
        New-PSDrive -Root ~/repos -Name git -PSProvider FileSystem > $Null
      }
      elseif (Test-Path "d:\PowerShell") {
        New-PSDrive -Root D:\ -Name git -PSProvider FileSystem > $Null
      }
    }
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
	
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardWord
    Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
    
	Set-PSReadLineKeyHandler -Chord F2 -Function SwitchPredictionView
    
	Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    
	Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete

    if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
<#
        Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
		#>
		Set-PSReadLineOption -Colors @{ Selection = "`e[92;7m"; InLinePrediction = "`e[2m" } -PredictionSource HistoryAndPlugin
    }


<#
      Set-PSReadLineKeyHandler -Chord Ctrl+Shift+c -Function Copy
      Set-PSReadLineKeyHandler -Chord Ctrl+Shift+v -Function Paste
	  #>
}

 
  }             
	

  if ($global:profile_initialized -ne $true) {
    $global:profile_initialized = $true
    Initialize-Profile
  }

  $currentLastExitCode = $LASTEXITCODE
  $lastSuccess = $?

  $color = @{
    Reset = "`e[0m"
    Red = "`e[31;1m"
    Green = "`e[32;1m"
    Yellow = "`e[33;1m"
    Grey = "`e[37;0m"
    White = "`e[37;1m"
    Invert = "`e[7m"
    RedBackground = "`e[41m"
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
    if (Test-Path ([System.IO.Path]::Combine($path,'.git'))) {
      # need to do this so the stderr doesn't show up in $error
      $ErrorActionPreferenceOld = $ErrorActionPreference
      $ErrorActionPreference = 'Ignore'
      $branch = git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
      $ErrorActionPreference = $ErrorActionPreferenceOld

      # handle case where branch is local
      if ($lastexitcode -ne 0 -or $null -eq $branch) {
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
  $consoleWidth = [Console]::WindowWidth
  $maxPath = [int]($consoleWidth / 2)
  if ($currentDirectory.Length -gt $maxPath) {
    $currentDirectory = "`u{2026}" + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
  }

  # check if running dev built pwsh
  $devBuild = ''
  if ($PSHOME.Contains("publish")) {
    $devBuild = " $($color.White)$($color.RedBackground)DevPwsh$($color.Reset)"
  }

  "${lastCmdTime}${currentDirectory}${gitBranch}${devBuild}`n${lastExit}PS$($color.Reset)$('>' * ($nestedPromptLevel + 1)) "

  # set window title
  try {
    $prefix = ''
    if ($isWindows) {
      $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
      $windowsPrincipal = [Security.Principal.WindowsPrincipal]::new($identity)
      if ($windowsPrincipal.IsInRole("Administrators") -eq 1) {
        $prefix = "Admin:"
      }
    }

    $Host.ui.RawUI.WindowTitle = "$prefix$PWD"
  } catch {
    # do nothing if can't be set
  }

  $global:LASTEXITCODE = $currentLastExitCode
}

echo "profile loaded"
#-------------------------------   Set alias BEGIN    -------------------------------

Set-Alias history    Get-History -Option AllScope
Set-Alias kill       Stop-Process -Option AllScope
Set-Alias pwd        Get-Location -Option AllScope
Set-Alias which      Get-Command -Option AllScope

# custom aliases         
if ( ($PSVersionTable.PSEdition -eq $null) -or ($PSVersionTable.PSEdition -eq "Desktop") ) {
    $PSVersionTable.PSEdition = "Desktop"
    $IsWindows = $true
}

#-------------------------------    Set alias END     -------------------------------
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

if ( Test-IsInteractive ) {
Clear-Host # remove advertisements (preferably use -noLogo)


# define these environment variables if not set already and also provide them as PSVariables
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR
if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

function cdc { Set-Location "$XDG_CONFIG_HOME" }
function cdd { Set-Location "$DESKTOP_DIR" }
function cdn { Set-Location "$NOTES_DIR" }
function cdt { Set-Location "$TODO_DIR" }

#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

function Get-ModulesAvailable {
    if ( $args.Count -eq 0 ) {
        Get-Module -ListAvailable
    } else {
        Get-Module -ListAvailable $args
    }
}

function Get-ModulesLoaded {
    if ( $args.Count -eq 0 ) {
        Get-Module -All
    } else {
        Get-Module -All $args
    }
}

function TryImport-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Import-Module $args}
    catch { }
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}



# don't override chocolatey sudo or unix sudo
if ( -not $(Test-CommandExists 'sudo') ) {
    function sudo() {
		# http://www.lavinski.me/my-powershell-profile/
		function Elevate-Process {
		    $file, [string]$arguments = $args
		    $psi = new-object System.Diagnostics.ProcessStartInfo $file
		    $psi.Arguments = $arguments
		    $psi.Verb = 'runas'

		    $psi.WorkingDirectory = Get-Location
		    [System.Diagnostics.Process]::Start($psi)
		}

        if ( $args.Length -eq 0 ) {
            Elevate-Process $(Get-HostExecutable) 
        } elseif ( $args.Length -eq 1 ) {
            Elevate-Process $args[0] 
        } else {
            Elevate-Process $args[0] -ArgumentList $args[1..$args.Length]
        }
    }
}


function Install-MyModules {
    PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -AllowClobber
    PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name PSProfiler -Scope CurrentUser -Force -AllowClobber # --> Measure-Script

    # serialization tools: eg. ConvertTo-HashString / ConvertTo-HashTable https://github.com/torgro/HashData
    PowerShellGet\Install-Module -Name hashdata -Scope CurrentUser -Force - AllowClobber

    # useful Tools eg. ConvertTo-FlatObject, Join-Object... https://github.com/RamblingCookieMonster/PowerShell
    PowerShellGet\Install-Module -Name WFTools -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber

}

function Import-MyModules {
    TryImport-Module PSProfiler
    TryImport-Module hashdata
    TryImport-Module WFTools
    TryImport-Module SqlServer
}

if ( -not $IsWindows ) {
    function Test-IsAdmin {
        if ( (id -u) -eq 0 ) {
            return $true
        }
        return $false
    }
}


if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name posh-git)) ) {
        TryImport-Module posh-git
}

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"

} # interactive test close
