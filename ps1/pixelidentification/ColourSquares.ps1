function Get-Image {
    <#
    .SYNOPSIS
    Loads an image from the specified path.

    .PARAMETER ImagePath
    The path to the image file.

    .OUTPUTS
    System.Drawing.Bitmap object representing the loaded image.
    #>
    param (
        [string]$ImagePath
    )

    $bitmap = New-Object System.Drawing.Bitmap $ImagePath
    return $bitmap
}

function Get-NearestColor {
    <#
    .SYNOPSIS
    Finds the nearest predefined color from a set of colors.

    .PARAMETER PixelColor
    The RGB color value of the pixel.

    .PARAMETER PredefinedColors
    An array of predefined colors (System.Drawing.Color objects).

    .OUTPUTS
    The nearest predefined color.
    #>
    param (
        [System.Drawing.Color]$PixelColor,
        [System.Drawing.Color[]]$PredefinedColors
    )

    $nearestColor = $PredefinedColors | Sort-Object {
        [math]::Sqrt(
            ($_.R - $PixelColor.R) * ($_.R - $PixelColor.R) +
            ($_.G - $PixelColor.G) * ($_.G - $PixelColor.G) +
            ($_.B - $PixelColor.B) * ($_.B - $PixelColor.B)
        )
    } | Select-Object -First 1

    return $nearestColor
}

function Divide-ImageIntoSquares {
    <#
    .SYNOPSIS
    Divides an image into 16 equal squares and retrieves the nearest color for each square.

    .PARAMETER ImagePath
    The path to the image file.

    .OUTPUTS
    A hashmap where keys are square indices (1 to 16) and values are arrays of nearest colors.
    #>
    param (
        [string]$ImagePath
    )

    $bitmap = Get-Image -ImagePath $ImagePath

    # Define your predefined set of colors here
    $webSafeColors = @(
        # RGB values for 256 colors (e.g., web-safe palette)
        # Add your own RGB values here
        # Example: [System.Drawing.Color]::FromArgb(255, 0, 0),  # Red
        # ...
    )

    # Calculate square dimensions
    $squareWidth = [math]::Floor($bitmap.Width / 4)
    $squareHeight = [math]::Floor($bitmap.Height / 4)

    # Initialize the hashmap
    $nearestColors = @{}

    # Iterate through each square
    for ($row = 0; $row -lt 4; $row++) {
        for ($col = 0; $col -lt 4; $col++) {
            $squareIndex = $row * 4 + $col + 1
            $squareRect = [System.Drawing.Rectangle]::FromLTRB(
                $col * $squareWidth, $row * $squareHeight,
                ($col + 1) * $squareWidth, ($row + 1) * $squareHeight
            )

            $colors = @()
            for ($x = $squareRect.Left; $x -lt $squareRect.Right; $x++) {
                for ($y = $squareRect.Top; $y -lt $squareRect.Bottom; $y++) {
                    $color = $bitmap.GetPixel($x, $y)
                    $nearestColor = Get-NearestColor -PixelColor $color -PredefinedColors $webSafeColors
                    $colors += $nearestColor
                }
            }

            $nearestColors[$squareIndex] = $colors
        }
    }

    # Dispose of the bitmap
    $bitmap.Dispose()

    return $nearestColors
}

# Example usage:
$imagePath = "E:\sessionStorage\a_vin\240523_151507\f_000e6a.JPG"  # Replace with the actual image path
$result = Divide-ImageIntoSquares -ImagePath $imagePath

# Display the result
$result
