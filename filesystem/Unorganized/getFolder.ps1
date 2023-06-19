<#
.SYNOPSIS
Show a folder browser dialog and return the selected folder path.

.DESCRIPTION
This script takes one parameter: the initial directory to display in the folder browser dialog. It then uses the System.Windows.Forms.FolderBrowserDialog class to create and show a folder browser dialog with the root folder set to MyComputer. If the initial directory is specified, it sets the selected path of the dialog to it. It then returns the selected path of the dialog after the user closes it.

.PARAMETER InitialDirectory
The initial directory to display in the folder browser dialog.

.EXAMPLE
PS C:\> Get-Folder -InitialDirectory "C:\Users\user\Documents"

This example shows a folder browser dialog with the initial directory set to "C:\Users\user\Documents" and returns the selected folder path.
#>

function Get-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$InitialDirectory
    )

    # Load the System.Windows.Forms assembly
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

    # Create a new folder browser dialog object
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog

    # Set the root folder of the dialog to MyComputer
    $FolderBrowserDialog.RootFolder = 'MyComputer'

    # If the initial directory is specified, set the selected path of the dialog to it
    if ($InitialDirectory) { $FolderBrowserDialog.SelectedPath = $InitialDirectory }

    # Show the dialog and wait for the user to close it
    [void] $FolderBrowserDialog.ShowDialog()

    # Return the selected path of the dialog
    return $FolderBrowserDialog.SelectedPath
}
