<#
.SYNOPSIS
Display the used and free space of up to three drives.

.DESCRIPTION
This script takes three parameters: the names of the drives to check. It then uses the Get-PSDrive cmdlet to get the used and free space of each drive and writes them to the host. If a drive name is not specified, it skips the remaining drives.

.PARAMETER Drive1
The name of the first drive to check. This is a mandatory parameter.

.PARAMETER Drive2
The name of the second drive to check. This is an optional parameter.

.PARAMETER Drive3
The name of the third drive to check. This is an optional parameter.

.EXAMPLE
PS C:\> .\display-disk-space.ps1 -Drive1 "C" -Drive2 "D" -Drive3 "E"

This example displays the used and free space of the C, D and E drives.
#>

# Define a function to display the used and free space of up to three drives
function Display-DiskSpace {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Drive1,
        [Parameter(Mandatory=$false)]
        [string]$Drive2,
        [Parameter(Mandatory=$false)]
        [string]$Drive3
    )

    # Get the used and free space of the first drive and write them to the host
    $diskdata = Get-PSDrive -Name $Drive1 | Select-Object -Property Used, Free
    Write-Host "$($Drive1) has $($diskdata.Used) Used and $($diskdata.Free) free"

    # If the second drive name is specified, get its used and free space and write them to the host
    if ($Drive2) {
        $diskdata = Get-PSDrive -Name $Drive2 | Select-Object -Property Used, Free
        Write-Host "$($Drive2) has $($diskdata.Used) Used and $($diskdata.Free) free"

        # If the third drive name is specified, get its used and free space and write them to the host
        if ($Drive3) {
            $diskdata = Get-PSDrive -Name $Drive3 | Select-Object -Property Used, Free
            Write-Host "$($Drive3) has $($diskdata.Used) Used and $($diskdata.Free) free"
        }
    }
} #function

# Call the function with the parameters from the command line
Display-DiskSpace -Drive1 $Drive1 -Drive2 $Drive2 -Drive3 $Drive3

#EOF
