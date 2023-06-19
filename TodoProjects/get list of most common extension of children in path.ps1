<#
.SYNOPSIS
Get the list of most common extensions of files in a given path and convert the path into a custom object with two properties: Hash and Sorted.

.DESCRIPTION
This script takes a path as a parameter and scans the files in that path recursively. It groups the files by their extensions and sorts them by count. It then selects the top 10 most common extensions and creates a custom object with two properties: Hash and Sorted. The Hash property is a hashtable that maps each extension to its count. The Sorted property is a string that contains the extensions sorted alphabetically and separated by commas. The script outputs the custom object to the pipeline.

.PARAMETER Path
The path to scan for files and their extensions.

.EXAMPLE
PS C:\> Get-CommonExtensions -Path "C:\Users\user\Documents"

Hash                                                         Sorted
----                                                         ------
{@{.txt=15; .docx=12; .pdf=10; .xlsx=8; .pptx=6; .jpg=5; ... .csv,.docx,.jpg,.pdf,.png,.pptx,.ps1,.txt,.xlsx,.zip}

This example scans the "C:\Users\user\Documents" folder and outputs the custom object with the Hash and Sorted properties.
#>

function Get-CommonExtensions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Get the list of files in the path and their extensions
    $files = Get-ChildItem -Path $Path -Recurse -File | Select-Object Name, Extension

    # Group the files by extension and sort by count
    $grouped = $files | Group-Object Extension | Sort-Object Count -Descending

    # Get the top 10 most common extensions
    $top10 = $grouped | Select-Object -First 10

    # Convert the path into a custom object with two properties: Hash and Sorted
    $pathObject = [PSCustomObject]@{
        Hash = $top10 | ForEach-Object { @{ $_.Name = $_.Count } } # Create a hashtable for each extension and count pair
        Sorted = ($top10.Name | Sort-Object) -join "," # Sort the extensions alphabetically and join them with a comma
    }

    # Output the path object
    $pathObject
}
