<#
.SYNOPSIS
Launch a separate explorer process to access a remote computer's C drive.

.DESCRIPTION
This script takes one parameter: the name of the remote computer to access. It then modifies the registry key for the current user to enable the SeparateProcess option for explorer. It then maps a network drive to the C drive of the remote computer using the current user's credentials. It then launches a new explorer process to open the network drive.

.PARAMETER ComputerName
The name of the remote computer to access.

.EXAMPLE
PS C:\> Launch-RemoteExplorer -ComputerName "server01"

This example launches a separate explorer process to access the C drive of the server01 computer.
#>

function Launch-RemoteExplorer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName
    )

    # Define the registry key for the current user's explorer settings
    $regKey ="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\advanced"

    # Get the current user's name and domain
    $user = $env:username
    $domain = $env:userdomain

    # Set the SeparateProcess value to 1 to enable launching a separate explorer process
    Set-ItemProperty -Path $regKey -Name SeparateProcess -Value 1

    # Map a network drive to the C drive of the remote computer using the current user's credentials
    net use \\$ComputerName\c$ /user:$domain\$user

    # Launch a new explorer process to open the network drive
    explorer.exe \\$ComputerName\c$
}
