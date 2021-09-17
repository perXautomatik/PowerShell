﻿cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\getChildrenRecursive.ps1
. .\presentJson.ps1

$jsonx = "D:\OneDrive\TabSessionManager - Backup\93c75706-a3d3-45c6-a5ef-e5bb0d7ccf7d"
$jsonx = Get-Content $jsonx -Raw | ConvertFrom-Json

$presentationMethodPath = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath "presentJson.ps1" )


getChildrenRecursive $jsonx $presentationMethodPath

