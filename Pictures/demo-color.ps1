<#
.SYNOPSIS

#demo-color.ps1

# Jeffery Hicks
# http://jdhitsolutions.com/blog
# follow on Twitter: http://twitter.com/JeffHicks
# 
# "Those who forget to script are doomed to repeat their work."
Display the available console colors and their samples.

.DESCRIPTION
This script takes two switches: ListOnly and Combo. If ListOnly is specified, it displays a sorted list of the console color names. If Combo is specified, it displays all possible combinations of foreground and background colors. If neither switch is specified, it displays the console color names with their corresponding background colors.

.PARAMETER ListOnly
A switch to indicate whether to display only the list of console color names.

.PARAMETER Combo
A switch to indicate whether to display all combinations of foreground and background colors.

.EXAMPLE
PS C:\> .\demo-color.ps1 -ListOnly

This example displays a sorted list of the console color names.
#>

# Define a function to display the available console colors and their samples
function Demo-Color {
    [CmdletBinding()]
    param (
        [switch]$ListOnly,
        [switch]$Combo
    )

    # Enumerate color options for the current console
    $colors = [System.Enum]::GetNames([System.ConsoleColor])

    if ($ListOnly) {
        # Display a sorted list of colors
        $colors | Sort-Object
    }
    else {
        # Clear the screen
        Clear-Host

        if ($Combo) { # Cycle through all background and foreground combinations
            for ($i = 0; $i -lt $colors.count; $i++) { 
                for ($j = 0; $j -lt $colors.count; $j++) {
                    if ($colors[$i] -ne $colors[$j]) {
                        # Format the message with the color names
                        $msg = "{0} on {1}" -f $colors[$i], $colors[$j]
                        # Write the message with the corresponding colors
                        Write-Host $msg -ForegroundColor $colors[$i] -BackgroundColor $colors[$j]
                    } #if
                } #for $j
            } #for $i
        } #if $Combo
        else {
            # Show the list of colors with their corresponding background colors
            for ($i = 0; $i -lt $colors.count; $i++) { 
                Write-Host " $($colors[$i])   " -BackgroundColor $colors[$i]
            } #for
        } #else no $Combo
    } #else no $ListOnly
} #function

# Call the function with the parameters from the command line
Demo-Color -ListOnly:$ListOnly -Combo:$Combo

#EOF
#EOF