function setProfile($p,$g) { Set-Content -Path $p -Value $g }
$gitInvoke = { param([ref]$gist,[ref]$gistProfile) $gist.value = Invoke-RestMethod $gistUrl -ErrorAction Stop ; 
                $gistProfile.value = $gist.Files."profile.ps1".Content }

function versionSetCheck 
{ param([ref]$cv,[ref]$cp) $cv.value = "0.0.0"
  if ($cp.value -match $versionRegEx) {
    $cv.value = $matches.Version
  }                         
  return cv.value
}
$tryUpdateProfile =     {
      param ($gistUrl, $latestVersionFile, $versionRegEx)
      try {
          	& $gitInvoke ([ref]$gist,[ref]$gistprofile)
            versionSetCheck ([ref]$gistVersion,[ref]$gistProfile)
          	setProfile $latestVersionFile $gistVersion

            Write-Verbose "Installed newer version of profile" -Verbose
          . $profile
          return
      }
      catch {
        # we can hit rate limit issue with GitHub since we're using anonymous
        Write-Verbose -Verbose "Was not able to access gist to check for newer version"
      }
    }

function Initialize-Profile {

    $null = Start-ThreadJob -Name "Get version of `$profile from gist" -ArgumentList $gistUrl, $latestVersionFile, $versionRegEx -ScriptBlock 
    $tryUpdateProfile

    if ((Get-Module PSReadLine).Version -lt 2.2) {
      throw "Profile requires PSReadLine 2.2+"
    }
  }

  function prompt {
    Write-Verbose "Your version: $currentVersion" -Verbose; Write-Verbose "New version: $latestVersion" -Verbose
    $choice = Read-Host -Prompt "Found newer profile, install? (Y)"
    if ($choice -eq "Y" -or $choice -eq "") {
      Initialize-Profile
    }
    $global:LASTEXITCODE = $currentLastExitCode    
  }



if ([System.IO.File]::Exists($latestVersionFile)) {
  $latestVersion = [System.IO.File]::ReadAllText($latestVersionFile)
  $currentProfile = [System.IO.File]::ReadAllText($profile)

  if ([version]$latestVersion -gt (versionSetCheck ([ref]$currentVersion,[ref]$currentProfile))) {
    prompt
  }

}