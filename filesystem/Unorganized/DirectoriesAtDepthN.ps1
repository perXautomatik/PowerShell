<#
.SYNOPSIS
Get the list of directories at a given depth from the current or a specified folder.

.DESCRIPTION
This script takes two parameters: the root folder to start from, and the depth to search for directories. It then uses the Get-ChildItem cmdlet to get the list of directories recursively at the given depth from the root folder.

.PARAMETER Root
The root folder to start from. If not specified, it defaults to the current folder.

.PARAMETER Depth
The depth to search for directories. This is a mandatory parameter.

.EXAMPLE
PS C:\> ListDirectoriesAtDepth -Root "C:\Users\user\Documents" -Depth 2

This example gets the list of directories at depth 2 from the "C:\Users\user\Documents" folder.
#>

function ListDirectoriesAtDepth {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                   HelpMessage="current folder or provided")] 
        [string]$Root = (Get-Location),

        [Parameter(Mandatory=$true,
                   HelpMessage="depth")] 
        [int]$Depth
    )
    PROCESS {

        # Use the Get-ChildItem cmdlet to get the list of directories recursively at the given depth from the root folder
        Get-ChildItem -Path $Root -Directory -Recurse -Depth $Depth 
    }
}
