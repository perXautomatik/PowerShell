# Note that this code uses things only available in PSCore6
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

    $lastCmdTime = "$($color.Grey)[$timeColor$($cmdTime)$units$($color.Grey)]$($color.Reset) "
  }

  # get git branch information if in a git folder
  $gitBranch = ""
  if (Test-Path ./.git) {
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
  }

  # truncate the current location if too long
  $currentDirectory = $executionContext.SessionState.Path.CurrentLocation.Path
  $maxPath = 24
  if ($currentDirectory.Length -gt $maxPath) {
    $currentDirectory = "`u{2026}" + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
  }

  "$($lastExit)PS$($color.Reset) $lastCmdTime$currentDirectory$gitBranch$('>' * ($nestedPromptLevel + 1)) "
}
