param (
    [string]$directoryPath = "P:\Images\mobilBakgrund\"
)

# Function to check for accompanying .txt and .xmp files and process tags
function ProcessImageFiles {
    param ([string]$imagePath)

    $imageName = [System.IO.Path]::GetFileNameWithoutExtension($imagePath)
    $txtFilePath = "$directoryPath\$imageName.txt"
    $xmpFilePath = "$directoryPath\$imageName.xmp"

    # Check if .txt file exists
    if (Test-Path $txtFilePath) {
        $tags = Get-Content $txtFilePath -Raw
        $tagsArray = $tags -split ","

        # Check if .xmp file exists
        if (Test-Path $xmpFilePath) {
            # Use the previous script to add tags to the .xmp file
            & "C:\Users\CbRootz\Documents\WindowsPowerShell\ps1\Ongoings\Pictures\XmpWriting\XmpInserting.ps1" -filePath $xmpFilePath -newTags $tagsArray
        } else {
            # Call exiftool to generate a .xmp file
            & exiftool -o .xmp "$imagePath"
            if (Test-Path $xmpFilePath) {
                # Add tags to the newly created .xmp file
                & "C:\Users\CbRootz\Documents\WindowsPowerShell\ps1\Ongoings\Pictures\XmpWriting\XmpInserting.ps1" -filePath $xmpFilePath -newTags $tagsArray
            } else {
                Write-Host "Failed to create .xmp file for $imageName"
            }
        }
    } else {
        Write-Host "No .txt file found for $imageName"
    }
}

# Function to add new tags to the digiKam:TagsList in the .xmp file

# Get all image files in the directory
$imageFiles = Get-ChildItem -Path $directoryPath -File | Where-Object { $_.Extension -match "\.(jpg|jpeg|png|tif|tiff)$" }

# Process each image file
foreach ($imageFile in $imageFiles) {
    ProcessImageFiles -imagePath $imageFile.FullName
}

Write-Host "Processing complete."
