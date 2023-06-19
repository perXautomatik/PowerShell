<#
.SYNOPSIS
Compare the metadata of two image files using exiftool.

.DESCRIPTION
This script takes two parameters: the paths to the image files to compare. It then changes the current directory to the folder that contains the exiftool executable. It then runs the exiftool command on each image file with the options -a, -u and -g1, which display all metadata, unknown tags and group names respectively. It then compares the output of the exiftool command for each file and displays the differences.

.PARAMETER ImageFile1
The path to the first image file to compare.

.PARAMETER ImageFile2
The path to the second image file to compare.

.EXAMPLE
PS C:\> Compare-ImageMetadata -ImageFile1 "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front (2).jpg" -ImageFile2 "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front.jpg"

This example compares the metadata of two image files using exiftool and displays the differences.
#>

function Compare-ImageMetadata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ImageFile1,
        [Parameter(Mandatory=$true)]
        [string]$ImageFile2
    )

    # Change the current directory to the folder that contains the exiftool executable
    cd "E:\OneDrive - Region Gotland\PortableApps\5. image\PortableApps\geosetter\tools\"

    # Run the exiftool command on each image file with the options -a, -u and -g1
    $set1 = .\exiftool.exe -a -u -g1 $ImageFile1
    $set2 = .\exiftool.exe -a -u -g1 $ImageFile2

    # Compare the output of the exiftool command for each file and display the differences
    Compare-Object $set1 $set2 | Select-Object -ExpandProperty InputObject
}
