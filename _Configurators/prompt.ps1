function prompt {

  $color = @{
    Reset = "`e[0m"
    Red = "`e[31;1m"
    Green = "`e[32;1m"
    Yellow = "`e[33;1m"
  }

  $lastCmdTime = ""
  $lastCmd = Get-History -Count 1
  if ($null -ne $lastCmd) {
    $cmdTime = ($lastCmd.EndExecutionTime - $lastCmd.StartExecutionTime).TotalMilliseconds
    $timeColor = $color.Green
    if ($cmdTime -gt 250 -and $cmdTime -lt 1000) {
      $timeColor = $color.Yellow
    } elseif ($cmdTIme -ge 1000) {
      $timeColor = $color.Red
    }

    $lastCmdTime = "[$timeColor$($cmdTime)$($color.Reset)]"
  }

  $gitBranch = ""
  if (Test-Path ./.git) {
    $branch = git rev-parse --abbrev-ref --symbolic-full-name --% @{u}
    $branchColor = $color.Green
    if ($branch -match "/master") {
      $branchColor = $color.Red
    }
    $gitBranch = "[$branchColor$branch$($color.Reset)]"
  }

  "PS $lastCmdTime $($executionContext.SessionState.Path.CurrentLocation)$gitBranch$('>' * ($nestedPromptLevel + 1)) "
}
