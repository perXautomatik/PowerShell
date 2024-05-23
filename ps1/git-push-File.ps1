function PushTrackedFileToBranch {
    param(
      [Parameter(Mandatory = $true)]
      [string] $FilePath
    )
  
    # Check if Git is installed
    if (!(Test-Path -Path (Get-Command git).Path)) {
      Write-Error "Error: Git is not installed."
      return
    }
  
    # Find Git repository root
    $gitRoot = GitGetRepoRoot $FilePath
  
    if (!$gitRoot) {
      Write-Error "Error: File '$FilePath' is not tracked by a Git repository."
      return
    }
  
    # Change directory to Git repository root
    Set-Location $gitRoot
  
    # Check if a branch is checked out
    $currentBranch = git branch --show-current
    if (!$currentBranch) {
      Write-Error "Error: No branch is currently checked out."
      return
    }
  
    # Check if current branch tracks the file
    $trackedByCurrent = (git ls-files $FilePath | Out-Null)
    if ($trackedByCurrent) {
      $targetBranch = Get-TargetBranch
      PushToBranch $FilePath $currentBranch $targetBranch
    } else {
      # Find a branch tracking the file
      $trackingBranch = (git ls-remote --heads --tags | Select-String -Pattern $FilePath | Select-Object -ExpandProperty Path | Split-Path -Parent)
      if (!$trackingBranch) {
        Write-Error "Error: No branch tracks file '$FilePath'."
        return
      }
  
      # Create new branch and push
      $newBranchName = New-UniqueName -Prefix "temp-push-"
      git checkout -b $newBranchName $trackingBranch
      $targetBranch = Get-TargetBranch
      PushToBranch $FilePath $newBranchName $targetBranch
    }
  }
  
  function Get-TargetBranch {
    # Prompt user for target branch or path
    Write-Host "Enter target branch name or path (including remote name if applicable):"
    $targetBranch = Read-Host
  
    # Check if target is a file path
    if (Test-Path -Path $targetBranch) {
      $targetBranch = Resolve-Path $targetBranch -Parent
    }
  
    return $targetBranch
  }
  
  function PushToBranch {
    param (
      [string] $FilePath,
      [string] $SourceBranch,
      [string] $TargetBranch
    )
  
    # Add file and commit if not already tracked
    if (!(git ls-files $FilePath | Out-Null)) {
      git add $FilePath
      git commit -m "Added file '$FilePath' for push"
    }
  
    # Push to target
    git push -u origin $SourceBranch:$TargetBranch
  }
  
  function GitGetRepoRoot {
    param (
      [string] $FilePath
    )
  
    # Use git rev-parse to find the top-level .git directory
    $gitRoot = git rev-parse --show-toplevel --git-dir $FilePath 2>/dev/null
    if ($gitRoot) {
      return $gitRoot.Trim()
    }
  
    return $null
  }
  
  # Example usage
  PushTrackedFileToBranch "C:\project\src\myfile.txt"
  