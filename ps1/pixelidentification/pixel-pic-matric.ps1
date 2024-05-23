# Define image path and desired matrix dimensions
$imagePath = "your_image.jpg"
$rows = 10
$cols = 10

# Function to process a subimage and get average hue
function Get-AverageHue {
  param (
    [Parameter(Mandatory=$true)]
    [string] $ImagePath
  )

  Convert-Image -Path $ImagePath -Format HSV -Evaluate set:colorspace space=HSLa \
    -Statistics mean Channel=H | Select-Object -ExpandProperty Channels[0].Mean
}

# Split image into regions (adjust geometry based on rows and cols)
$cellWidth = [Math]::Floor((Get-Item $imagePath).Width / $cols)
$cellHeight = [Math]::Floor((Get-Item $imagePath).Height / $rows)

# Loop through each cell and calculate average hue
$hueMatrix = @()
for ($i = 0; $i -lt $rows; $i++) {
  for ($j = 0; $j -lt $cols; $j++) {
    # Define subimage geometry
    $x = $j * $cellWidth
    $y = $i * $cellHeight
    $subImagePath = "$($imagePath)-sub_[$i,$j].jpg"

    # Split the image and get average hue
    Convert-Image -Path $imagePath -Crop "$x,$y,$cellWidth,$cellHeight" -OutPath $subImagePath
    $averageHue = Get-AverageHue -ImagePath $subImagePath
    Remove-Item $subImagePath

    # Add average hue to matrix
    $hueMatrix += $averageHue
  }
}

# Print the hue matrix
Write-Host "Hue Matrix:"
$hueMatrix | ForEach-Object { Write-Host $_ }
