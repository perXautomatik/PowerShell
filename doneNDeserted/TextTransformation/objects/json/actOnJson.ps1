cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\getChildrenRecursive.ps1
. .\presentJson.ps1

$jsonx = "D:\OneDrive\TabSessionManager - Backup\b33fa6d5-141a-419a-aa4e-c62c5e204965"
$jsonx = Get-Content $jsonx -Raw | ConvertFrom-Json

$presentationMethodPath = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath "presentJson.ps1" )


getChildrenRecursive $jsonx $presentationMethodPath
$jsonx = "C:\Users\chris\OneDrive\Desktop\cluster-windows.json"

$json = [ordered]@{}


(Get-Content $jsonx -Raw | ConvertFrom-Json).PSObject.Properties |
    ForEach-Object { $json[$_.Name] = $_.Value }



$json.SyncRoot

