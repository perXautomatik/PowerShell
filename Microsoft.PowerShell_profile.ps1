# Modules
$ENV:EDITOR = "code"
$ENV:VISUAL = "code"

# Remove useless ugly beep
Set-PSReadlineOption -BellStyle None

function Print {
    [CmdletBinding()]
    param (
        $message,
        $foreground,
        $background
    )
    Write-Host $message -ForegroundColor $foreground -BackgroundColor $background -NoNewline
}

function Space {
    Write-Host " " -NoNewline
}

function PrintPrompt () {
    # Directory Printing
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    Print $pwd White Black
    Space
}

function prompt {
    # Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "$pwd";

    PrintPrompt

    # Print -> arrow pompt
    $Host.UI.Write($([char]0x2192))
    return " "
}
