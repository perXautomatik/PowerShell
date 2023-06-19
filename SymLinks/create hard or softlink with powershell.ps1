<#
.SYNOPSIS
Create a symbolic link or a junction to a target file or folder.

.DESCRIPTION
This script takes two parameters: the target file or folder to link, and the path to create the link. It then uses the New-Item cmdlet to create the symbolic link or the junction. This requires Windows 10 or Powershell 5.0 or higher, and Developer Mode enabled to not require admin privileges.

.PARAMETER Target
The target file or folder to link.

.PARAMETER Link
The path to create the link.

.EXAMPLE
PS C:\> Make-Link -Target "C:\Users\crbk01\OneDrive - Region Gotland\WindowsPowerShell\PSReadline" -Link "C:\Users\crbk01\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline"

This example creates a junction from "C:\Users\crbk01\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline" to "C:\Users\crbk01\OneDrive - Region Gotland\WindowsPowerShell\PSReadline".
#>

function Make-Link {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Target,
        [Parameter(Mandatory=$true)]
        [string]$Link
    )

    # Use the New-Item cmdlet to create the symbolic link or the junction
    New-Item -Path $Link -ItemType SymbolicLink -Value $Target
}
