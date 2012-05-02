$nextId = (get-history -count 1).Id + 1;
$currentPath = (get-location).Path.replace($home, "~")
$idx = $currentPath.IndexOf("::")
if ($idx -gt -1) { $currentPath = $currentPath.Substring($idx + 2) }

$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity
$title = $currentPath

if ($windowTitle -ne $null)
{
    $title = ($title + "  »  " + $windowTitle)
}

if ($psISE)
{
    $color = "Black";
}
elseif ($windowsPrincipal.IsInRole("Administrators") -eq 1)
{
    $color = "Yellow";
}
else
{
    $color = "Green";
}

Write-HgStatus (Get-HgStatus)
Write-GitStatus (Get-GitStatus)

write-host (" [" + $nextId + "]") -NoNewLine -ForegroundColor $color
if ((get-location -stack).Count -gt 0) { write-host ("+" * ((get-location -stack).Count)) -NoNewLine -ForegroundColor Cyan }

set-title $title
return " "