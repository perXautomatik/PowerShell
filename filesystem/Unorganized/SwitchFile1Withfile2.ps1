<#
.SYNOPSIS
This script swaps the current background file with a random one from a folder. It preserves the names of the files by using a temporary random name for the old background file.
#>

function Swap-BackgroundFile {
    # Set the folder path where the background files are stored
    $BGPath = "C:\Users\crbk01\Desktop"

    # Get the current background file by joining the folder path and the file name
    $CurrentBG = Get-Item -Path (Join-Path -Path $BGPath -ChildPath 'DittoDatabase.db')

    # Get a random new background file from the folder, excluding the current one
    $NewBG = Get-ChildItem -Path $BGPath -Filter *.db -Exclude $CurrentBG.Name | Get-Random

    # Get the name of the new background file
    $NewBGName = $NewBG.Name

    # Rename the old background file to a random name, and keep a reference to it with -PassThru
    $OldBG = $CurrentBG | Rename-Item -NewName ([System.IO.Path]::GetRandomFileName()) -PassThru

    # Rename the new background file to the name of the old one
    $NewBG | Rename-Item -NewName 'DittoDatabase.db'

    # Rename the old background file back to the name of the new one
    $OldBG | Rename-Item -NewName $NewBGName
}
