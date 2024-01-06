# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


# Scoop-search
if(Test-CommandExists scoop-search )
{
Invoke-Expression (&scoop-search --hook)
}
