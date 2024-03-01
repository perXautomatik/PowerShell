#Requires -Version 7

# Version 1.2.13

# check if newer version
$gistid = "62a71500a0f044477698da71634ab87b"
$gistUrl = "https://api.github.com/gists/$gistid"
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
	    $null = Start-ThreadJob -Name "Get version of `$profile from gist" -ArgumentList $gistUrl, $latestVersionFile, $versionRegEx -ScriptBlock 
		{
	      param ($gistUrl, $latestVersionFile, $versionRegEx)

	      try {
		
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
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist, try again next time"
      }
    }
  }
}

$global:profile_initialized = $false

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
set-alias -name reload-profile -value reloadProfile
set-alias -name uptime -value uptimef
set-alias -name print-path -value printpath
#######################################################
#set-alias -Name cd -Value aliasChangeDirectory -Option AllScope

function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
	& $profile
}
function print-path {
	($Env:Path).Split(";")
}
# filesInFolAsStream ;
function aliasfilesInFolAsStream {
	get-childitem | out-string -stream
}
set-alias -Name filesinfolasstream -Value aliasfilesInFolAsStream

#new ps OpenAsADmin
function aliasopenasadminf {
	Start-Process powershell -Verb runAs
}

set-alias -Name OpenAsADmin -Value aliasopenasadminf

Function aliasEFunc {Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | Where{ $_ -notmatch 'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' }}  ;
set-alias -name EveryGitRepo -Value aliasEFunc

Function aliasEGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ;
set-alias -name gitSilently -Value aliasEGSfunc

Function aliasEGSRfunc
{
	out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ;
	 %{$proc -split '\n'} | %{ $properties = $_ -split '[\t\s]';
	  $remote = try{ New-Object PSObject -Property @{ name = $properties[0].Trim();
	    url = $properties[1].Trim();  type = $properties[2].Trim() } } catch {'noRemote'} ;
	     $remote | select-object -first 1 | select url}
	  } ;
set-alias -name gitSingleRemote -Value aliasEGSRfunc

function aliasFunctionEverything([string]$filter)
	{Search-Everything -filter $filter -global}

set-alias -name code -value '& $env:code'

set-alias -name everything -value aliasFunctionEverything

function aliasPshellHistoryPath {
	(Get-PSReadlineOption).HistorySavePath
}
set-alias -name pshelHistorypath -value aliasPshellHistoryPath

function aliasPastDo($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ }
}

set-alias -name pastDo -value aliasPastDo

function aliasPastDoEdit($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }
}

set-alias -name pastDoEdit -value aliasPastDoEdit

function aliasExecuteThis($searchstring) {
menu @(everything "ext:exe $searchString") | %{& $_ }
}

set-alias -name executeThis -value aliasExecuteThis


function aliasMyAliases {
Get-Alias -Definition alias* | select name
}

set-alias -name MyAliases -value aliasMyAliases




#Git Ad $leaf as submodule from $remote and branch $branch
Function aliasEFuncGT([string]$leaf,[string]$remote,[string]$branch)
{
 git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch
 } ;
set-alias -name GitAdEPathAsSNB -value aliasEFuncGT

Function aliasEGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ;
set-alias -name GitUp -value aliasEGLp
function aliasrb {
shutdown /r
}
set-alias -Name reboot -Value aliasrb

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


Set-Alias history    Get-History -Option AllScope
Set-Alias kill       Stop-Process -Option AllScope
Set-Alias pwd        Get-Location -Option AllScope
Set-Alias which      Get-Command -Option AllScope

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}

function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}


function set-x {
    Set-PSDebug -trace 2
}

function set+x {
    Set-PSDebug -trace 0
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if ( $args.Count -eq 0 ) {
        Get-Childitem env:
    } elseif( $args.Count -eq 1 ) {
        Start-Process (Get-Command $args[0]).Source
    } else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}
Set-Alias env        Get-Environment -Option AllScope

# define these environment variables if not set already and also provide them as PSVariables
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR
if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

function cdc { Set-Location "$XDG_CONFIG_HOME" }
function cdd { Set-Location "$DESKTOP_DIR" }
function cdn { Set-Location "$NOTES_DIR" }
function cdt { Set-Location "$TODO_DIR" }

function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }

if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ( $gitrootdir ) {
            Set-Location $gitrootdir
        }
    }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args
            }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim {
           . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`'
        }

        if ( -Not (Test-CommandExists 'sh') ){
            Set-Alias sh   git-sh -Option AllScope
        }

        if ( -Not (Test-CommandExists 'bash') ){
            Set-Alias bash   git-bash -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vi') ){
            Set-Alias vi   git-vim -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vim') ){
            Set-Alias vim   git-vim -Option AllScope
        }
    }
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


function gj { Get-Job | select id, name, state | ft -a }
function sj ($id = '*') { Get-Job $id | Stop-Job; gj }
function rj { Get-Job | ? state -match 'comp' | Remove-Job }

function man {
    Get-Help $args[0] | out-host -paging
}


function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($k.VirtualKeyCode -eq $null -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}


function Reload-Profile {
    . $PROFILE.CurrentUserCurrentHost
}



if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }

    function Restart-Explorer {
        Get-Process explorer | Stop-Process
        Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"
    }
}
function Get-HostExecutable {
    if ( $PSVersionTable.PSEdition -eq "Core" ) {
        $ConsoleHostExecutable = (get-command pwsh).Source
    } else {
        $ConsoleHostExecutable = (get-command powershell).Source
    }
    return $ConsoleHostExecutable
}

# https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Start-PsElevatedSession { 
    # Open a new elevated powershell window
    if (!(Test-Administrator)) {
        if ($host.Name -match 'ISE') {
            start PowerShell_ISE.exe -Verb runas
        } else {
            start powershell -Verb runas -ArgumentList $('-noexit ' + ($args | Out-String))
        }
    } else {
        Write-Warning 'Session is already elevated'
    }
} 
Set-Alias -Name su -Value Start-PsElevatedSession

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
