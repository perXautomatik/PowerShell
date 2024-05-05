

$TagLibDll = "B:\PortableApplauncher\portable\5--audio\PortableApps\Last.fm-Scrubbler-WPF-Beta-1.22\taglib-sharp.dll"
Add-Type -Path $TagLibDll

# Specify the folder containing your images and XMP files
$imageFolder = "P:\Pictures\ToOrganize\BW\WithMetadataFiles\BwSemisorted\DoesItBelong\things i find sexy to show sabrina\--\3,3\5,0"

# Get all image files (you can adjust the filter as needed)
$imageFiles = Get-ChildItem -Path $imageFolder -Filter *.jpg
$pp = (Get-ChildItem -Path $imageFolder -Filter *.txt)
$keyWs = (get-content -path $pp.FullName).ToString()
$tags = @( $keyWs -split "," | %{ $_.trim() } )

foreach ($imageFile in $imageFiles) {
    # Load the image file
    cd $imageFolder
    $base = ($imageFile.BaseName);

    $newXMp = $base+".xmp"
    
    
    rm $newXMp

    exiftool $imageFile.FullName -o $newXMp
    $keyWs = "'"+ (@($tags | %{ $_ -replace " ", "_"}) -join ",") + "'"

    exiftool -keywords=$keyWs $imageFile.FullName;
    # Read existing XMP metadata (if any)
    $existingTags = $tag.ImageTag.Keywords

    # Add your custom tags (replace with your actual tags)
    $newTags = $tags

    # Combine existing and new tags
    $combinedTags = $existingTags + $newTags

    # Set the updated tags
    $tag.ImageTag.Keywords = $combinedTags

    # Save the modified XMP data back to the image file
    $tag.Save()
    
}

Write-Host "XMP metadata updated for $($imageFiles.Count) image(s)."