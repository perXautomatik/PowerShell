# Add unix "touch" equivalent
# Adapted from https://superuser.com/a/571154
Function Update-File {
  $file = $args[0]
  if ($null -eq $file) {
    throw "No filename supplied"
  }

  if (Test-Path $file) {
    (Get-ChildItem $file).LastWriteTime = Get-Date
  }
  else {
    New-Item $file
  }
}

<#
.Synopsis
	Yank working directory to system clipboard
#>
Function ywd {
  (Get-Location).path | Set-Clipboard
}

<#
.Synopsis
    Open Windows Terminal in current working directory
#>
Function wtpwd() {
  Param (
    # A valid Windows Terminal profile
    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'profile')]
    [Alias('p')]
    [string] $profile = "Windows Powershell"
  )
  wt -w 0 nt -d (Get-Location).path -p $profile 
}

<#
.Synopsis
    Compile and run an isolated C++ file.
#>
Function Run-Cpp {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$file
  )

  # Strip extension
  if (($file -match "\.cpp$") -or [System.IO.File]::exists($file)) {
    $file = $file.Substring(0, $file.lastIndexOf('.'))
  }
  elseif (![System.IO.File]::exists((Get-ChildItem "$file").FullName)) {
    Write-Warning "File does not exist!"
    return
  }

  g++ "$file.cpp" -o "$file.exe";
  if ($?) {
    &.\"$file.exe"
  }
}

Function Run-Java {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$file
  )

  if (!($file -match "\.java$") -or ![System.IO.File]::exists((Get-ChildItem "$file").FullName)) {
    Write-Warning "File does not exist! >_< :: $file"
    return
  }
  
  $baseFile = $(Split-Path $file -Leaf)
  $class = $baseFile.Substring(0, $baseFile.lastIndexOf('.'))
  $directory = (Get-Item -Path $(Split-Path $file)).FullName
  
  # Compile
  javac -d "$directory" "$file"
  
  # Run
  java -cp "$directory" "$class"
}
 
<#
  .Synopsis
    Reset mIRC, re-use to trial
#>
Function reset-mIRC {
   Remove-Item HKCU:\SOFTWARE\mIRC\LastRun
   Remove-Item -Recurse "$Env:USERPROFILE\AppData\Roaming\mIRC"
}

<#
	Create shim to an executable. A "shim" acts as a proxy to an executable and works better than symlinks for binaries
	dependant on bundled DLLs for example.
	- Dependency: `scoop-shim` installed with `scoop`
	- Platform: Windows
#>
Function Create-Shim {
  Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Alias
  )

   $EXEC_DIR = "${HOME}/bin/shims"
   $SCOOP_SHIM = "${HOME}/scoop/apps/scoop-shim/current/shim.exe"

   $execBase = if ($Alias) {"$Alias.exe"} Else {(Split-Path $File -Leaf)}

   Copy-Item $SCOOP_SHIM "$EXEC_DIR/$execBase"
   Out-File -FilePath "$EXEC_DIR/$($execBase.SubString(0, $execBase.lastIndexOf('.'))).shim" -InputObject "path = $((Get-ChildItem "$file").FullName)" 
}

Function Create-Shortcut {
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$ShortcutPath,
		[Parameter(Mandatory = $true, Position = 1)]
		[string]$Target,
		[Parameter(Mandatory = $false, Position = 2)]
		[string]$Args
	)
	$wshShell = New-Object -comObject Wscript.Shell
	$shortcut = $wshShell.CreateShortcut($ShortcutPath)
	$shortcut.TargetPath = $Target
	$shortcut.Arguments = $args
	$shortcut.Save()
}

Function fzfp {
	fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}

Function im-pg {
	Import-Module posh-git
}

function ll {
  lsd -l @args
}

function cpath {
  Get-Location | Set-Clipboard
}

function profile {
  nvim "$HOME\.config\powershell\profile.ps1"
}

function winconfig {
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

function dotfiles {
  lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME
}

function gst {
  git status @args
}

function gss {
  git status -s
}

function gloo {
  git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short @args
}

function ga {
  git add @args
}

function getProcess {
  Get-Process | Group-Object -Property ProcessName |
  Select-Object Count, Name,
  @{
    Name       = 'Memory usage(Total in MB)';
    Expression = { '{0:N2}' -f (($_.Group |
          Measure-Object WorkingSet -Sum).Sum / 1MB) }
  }
}

# Get-MyProcess brave, neovide, explorer
Function Get-MyProcess {
  [cmdletbinding()]
  Param([string[]]$Name)

  $Name | foreach-object {
    Get-Process -name $_ -PipelineVariable pv |
    Measure-Object Workingset -sum -average |
    Select-object @{Name = "Name"; Expression = { $pv.name } },
    Count,
    @{Name = "SumMB"; Expression = { [math]::round($_.Sum / 1MB, 2) } },
    @{Name = "AvgMB"; Expression = { [math]::round($_.Average / 1MB, 2) } }
  }
}

Function fs($path) {
  Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
  Measure-Object -Property Length -Sum |
  Select-Object Count, @{Name = "Size(MB)"; Expression = { '{0:N2}' -f ($_.Sum / 1MB) } }
}

Function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function ll {
  lsd -l @args
}

function cpath {
  Get-Location | Set-Clipboard
}

function profile {
  nvim "$HOME\.config\powershell\profile.ps1"
}

function winconfig {
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
}

function dotfiles {
  lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME
}

function gst {
  git status @args
}

function gss {
  git status -s
}

function gloo {
  git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short @args
}

function ga {
  git add @args
}

function getProcess {
  Get-Process | Group-Object -Property ProcessName |
  Select-Object Count, Name,
  @{
    Name       = 'Memory usage(Total in MB)';
    Expression = { '{0:N2}' -f (($_.Group |
          Measure-Object WorkingSet -Sum).Sum / 1MB) }
  }
}

# Get-MyProcess brave, neovide, explorer
Function Get-MyProcess {
  [cmdletbinding()]
  Param([string[]]$Name)

  $Name | foreach-object {
    Get-Process -name $_ -PipelineVariable pv |
    Measure-Object Workingset -sum -average |
    Select-object @{Name = "Name"; Expression = { $pv.name } },
    Count,
    @{Name = "SumMB"; Expression = { [math]::round($_.Sum / 1MB, 2) } },
    @{Name = "AvgMB"; Expression = { [math]::round($_.Average / 1MB, 2) } }
  }
}

Function fs($path) {
  Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue |
  Measure-Object -Property Length -Sum |
  Select-Object Count, @{Name = "Size(MB)"; Expression = { '{0:N2}' -f ($_.Sum / 1MB) } }
}

Function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

## Which
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Imports
function Load-Module ($m) {
    if (!(Get-Module | Where-Object { $_.Name -eq $m })) {
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $m }) {
            Import-Module $m -Verbose
        }
        else {
            if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
        }
    }
}
