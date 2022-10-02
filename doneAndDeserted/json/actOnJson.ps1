cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\getChildrenRecursive.ps1
. .\presentJson.ps1
$jsonx = "C:\Users\chris\OneDrive\Desktop\cluster-windows.json"

$json = [ordered]@{}

$jsonx = "D:\OneDrive\TabSessionManager - Backup\b33fa6d5-141a-419a-aa4e-c62c5e204965"
(Get-Content $jsonx -Raw | ConvertFrom-Json).PSObject.Properties |
    ForEach-Object { $json[$_.Name] = $_.Value }

$presentationMethodPath = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath "presentJson.ps1" )

$json.SyncRoot

getChildrenRecursive $jsonx $presentationMethodPath

