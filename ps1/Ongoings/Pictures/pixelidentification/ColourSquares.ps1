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

# Function to process a subimage and get average hue
function Get-AverageHue {
    param (
      [Parameter(Mandatory=$true)]
      [string] $ImagePath
    )
  
    Convert-Image -Path $ImagePath -Format HSV -Evaluate set:colorspace space=HSLa \
      -Statistics mean Channel=H | Select-Object -ExpandProperty Channels[0].Mean
  }
  
  function Verb-Noun {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
        <#
        .SYNOPSIS
            # Split the image and get average hue
        .DESCRIPTION
            A longer description of the function, its purpose, common use cases, etc.
        .NOTES
            Information or caveats about the function e.g. 'This function is not supported in Linux'
        .LINK
            Specify a URI to a help page, this will show when Get-Help -Online is used.
        .EXAMPLE
            Test-MyTestFunction -Verbose
            Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
        #>
        
        Convert-Image -Path $imagePath -Crop "$x,$y,$cellWidth,$cellHeight" -OutPath $subImagePath
        $averageHue = Get-AverageHue -ImagePath $subImagePath
        Remove-Item $subImagePath
      
    }
    
    end {
        
    }
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

  function Get-AverageHue {
    <#
    .SYNOPSIS
    Calculates the average hue value for a given rectangle within an image.
  
    .PARAMETER ImagePath
    The path to the image file.
  
    .PARAMETER Rectangle
    A rectangle defining the area to analyze (System.Drawing.Rectangle object).
  
    .OUTPUTS
    The average hue value within the specified rectangle.
    #>
    param (
      [string]$ImagePath,
      [System.Drawing.Rectangle]$Rectangle
    )
  
    $bitmap = Get-Image -ImagePath $ImagePath
    $converter = New-Object System.Drawing.ColorConverter
  
    $totalHue = 0.0
    $pixelCount = 0
  
    for ($x = $Rectangle.Left; $x -lt $Rectangle.Right; $x++) {
      for ($y = $Rectangle.Top; $y -lt $Rectangle.Bottom; $y++) {
        $color = $bitmap.GetPixel($x, $y)
        $hsv = $converter.ConvertToHsl($color)
        $totalHue += $hsv.H
        $pixelCount++
      }
    }
  
    if ($pixelCount -gt 0) {
      $averageHue = $totalHue / $pixelCount
    } else {
      $averageHue = 0.0  # Handle cases with no pixels in the rectangle
    }
  
    # Dispose of the bitmap
    $bitmap.Dispose()
  
    return $averageHue
  }
  
  function Divide-ImageIntoSquares {
    <#
    .SYNOPSIS
    Divides an image into 16 equal squares and retrieves the nearest color for each square.

    .PARAMETER ImagePath
    The path to the image file.
  
    .PARAMETER Rows
    The number of rows to divide the image into (default 10).
  
    .PARAMETER Columns
    The number of columns to divide the image into (default 10).
  
    .OUTPUTS
    A hashtable where keys are square indices (1 to Rows*Columns) and values are the average hue for that square.
    #>
    param (
      [string]$ImagePath,
      [int]$Rows = 10,
      [int]$Columns = 10
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
    $squareWidth = [math]::Floor($bitmap.Width / $Columns)
    $squareHeight = [math]::Floor($bitmap.Height / $Rows)
  
    # Initialize the hashtable
    $averageHues = @{}
  
    # Iterate through each square
    for ($row = 0; $row -lt $Rows; $row++) {
      for ($col = 0; $col -lt $Columns; $col++) {
        $squareIndex = $row * $Columns + $col + 1
        $squareRect = [System.Drawing.Rectangle]::FromLTRB(
          $col * $squareWidth, $row * $squareHeight,
          ($col + 1) * $squareWidth, ($row + 1) * $squareHeight
        )

        $averageHues[$squareIndex] = $averageHue
      }
    }

    # Dispose of the bitmap
    $bitmap.Dispose()
  
    return $averageHues
  }

# Example usage:
$imagePath = "E:\sessionStorage\a_vin\240523_151507\f_000e6a.JPG"  # Replace with the actual image path
$result = Divide-ImageIntoSquares -ImagePath $imagePath

# Display the result
$result
