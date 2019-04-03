#Requires -Version 6

# Version 1.0.5

# check if newer version
$gist = Invoke-RestMethod https://api.github.com/gists/a208d2bd924691bae7ec7904cab0bd8e
$gistProfile = $gist.Files."profile.ps1".Content
$currentProfile = Get-Content $profile -Raw
if ($gistProfile.GetHashCode() -ne $currentProfile.GetHashCode()) {
  [version]$currentVersion = "0.0.0"
  $versionRegEx = "# Version (?<version>\d+\.\d+\.\d+)"
  if ($currentProfile -match $versionRegEx) {
    $currentVersion = $matches.Version
  }

  [version]$gistVersion = "0.0.0"
  if ($gistProfile -match $versionRegEx) {
    $gistVersion = $matches.Version
  }

  if ($gistVersion -gt $currentVersion) {
    Write-Verbose "Your version: $currentVersion" -Verbose
    Write-Verbose "New version: $gistVersion" -Verbose
    $choice = Read-Host -Prompt "Found newer profile, install? (Y)"
    if ($choice -eq "Y" -or $choice -eq "") {
      Set-Content -Path $profile -Value $gistProfile
      Write-Verbose "Installed newer version of profile" -Verbose
      . $profile
      return
    }
  }
}

Set-PSReadLineOption -EditMode Emacs -ShowToolTips

# ensure dotnet cli is in path
$dotnet = Get-Command dotnet -CommandType Application -ErrorAction Ignore
if ($null -eq $dotnet) {
  if (Test-Path ~/.dotnet/dotnet) {
    $env:PATH += [System.IO.Path]::PathSeparator + (Join-Path (Resolve-Path ~) ".dotnet")
  }
}

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

  # set window title
  try {
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
}
