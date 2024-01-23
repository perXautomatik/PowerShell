# Define a function to get the color of a pixel from an image file
function Get-image ($ImagePath) {
  # Load the image as a bitmap
  $image = New-Object System.Drawing.Bitmap $ImagePath
  return $image;
}

# Get the image path from the command line argument
$imagePath = "C:\Users\Användaren\Pictures\Skärmbild 2024-01-23 075835.png" #$args[0]

# Get the image dimensions using the Wia.ImageFile COM object
$image = New-Object -ComObject Wia.ImageFile
$image.LoadFile($imagePath)
$width = $image.Width
$height = $image.Height

# Check if the image dimensions are larger than 320x240
if ($width -gt 320 -and $height -gt 240) {
  $image = Get-image($imagePath);
  # Divide the width and height by 13
  $width = $width / 13
  $height = $height / 13
  # Loop over the four sides of the image
  for ($side = 0; $side -lt 4; $side++) {
    # Loop over the 13 pixels on each side
    for ($pixel = 0; $pixel -lt 13; $pixel++) {
      # Calculate the pixel coordinates depending on the side
      switch ($side) {
        0 { # Top side
          $x = $pixel * $width
          $y = 0
          $z = "Top side"
        }
        1 { # Right side
          $x = $width * 12
          $y = $pixel * $height
          $z = "Right side"
        }
        2 { # Bottom side
          $x = (12 - $pixel) * $width
          $y = $height * 12
          $z = "Bottom side"
        }
        3 { # Left side
          $x = 0
          $y = (12 - $pixel) * $height
          $z = "Left side"
        }
      }
      # Round the coordinates to integers
      $x = [int][Math]::Round($x)
      $y = [int][Math]::Round($y)
      # Get the pixel color using the function
      $color = $image.GetPixel($X, $Y).ToString();
      # Print the pixel coordinates and color
      Write-Output $z, $color
    }
  }
  
  # Dispose the image object
  $image.Dispose()
 
}
else {
  # Print a message if the image dimensions are not larger than 320x240
  Write-Output "The image dimensions are not larger than 320x240"
}
