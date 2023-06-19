<#
.SYNOPSIS
This script gets the clipboard content and puts it in a file in the current folder, asking the user for the file name.
#>

function Save-ClipboardContent {
    # Get the clipboard content as a string
    $content = Get-Clipboard -Text

    # Check if the clipboard is empty
    if (-not $content) {
        Write-Warning "The clipboard is empty."
        return
    }

    # Ask the user for the file name
    $fileName = Read-Host "Enter the file name"

    # Check if the file name is valid
    if (-not $fileName) {
        Write-Warning "The file name cannot be empty."
        return
    }

    # Add the .txt extension if not present
    if (-not $fileName.EndsWith(".txt")) {
        $fileName += ".txt"
    }

    # Create the file path in the current folder
    $filePath = Join-Path -Path (Get-Location) -ChildPath $fileName

    # Check if the file already exists
    if (Test-Path -Path $filePath) {
        Write-Warning "The file $fileName already exists."
        return
    }

    # Write the clipboard content to the file
    Set-Content -Path $filePath -Value $content

    # Write a success message
    Write-Host "The clipboard content has been saved to $fileName."
}
