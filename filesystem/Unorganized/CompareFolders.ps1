<#
.SYNOPSIS
Compare and copy files from two folders to a third folder.

.DESCRIPTION
This script takes three parameters: the paths to the two source folders and the path to the destination folder. It then gets the list of files in each source folder recursively and compares them by name and length. It then copies the files that are different or missing from one source folder to the other to the destination folder, overwriting any existing files.

.PARAMETER SourceFolder1
The path to the first source folder to compare and copy files from.

.PARAMETER SourceFolder2
The path to the second source folder to compare and copy files from.

.PARAMETER DestinationFolder
The path to the destination folder to copy files to.

.EXAMPLE
PS C:\> Compare-Copy-Files -SourceFolder1 "E:\ToDatabase\Sqlite\Google\Chrome Beta\User Data" -SourceFolder2 "E:\ToDatabase\Sqlite\Google\ChromeDevProjects'\User Data" -DestinationFolder "C:\Folder3"

This example compares and copies files from "E:\ToDatabase\Sqlite\Google\Chrome Beta\User Data" and "E:\ToDatabase\Sqlite\Google\ChromeDevProjects'\User Data" to "C:\Folder3".
#>

function Compare-Copy-Files {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourceFolder1,
        [Parameter(Mandatory=$true)]
        [string]$SourceFolder2,
        [Parameter(Mandatory=$true)]
        [string]$DestinationFolder
    )

    # Get the list of files in each source folder recursively
    $Files1 = Get-ChildItem -Path $SourceFolder1 -Recurse 
    $Files2 = Get-ChildItem -Path $SourceFolder2 -Recurse

    # Compare the files by name and length
    $Comparison = Compare-Object -ReferenceObject $Files1 -DifferenceObject $Files2 -Property Name, Length

    # Copy the files that are different or missing from one source folder to the other to the destination folder, overwriting any existing files
    $Comparison | Where-Object {$_.SideIndicator -eq "<="} | ForEach-Object {
        Copy-Item -Path "$SourceFolder1\$($_.Name)" -Destination $DestinationFolder -Force
    }
    $Comparison | Where-Object {$_.SideIndicator -eq "=>"} | ForEach-Object {
        Copy-Item -Path "$SourceFolder2\$($_.Name)" -Destination $DestinationFolder -Force
    }
}
