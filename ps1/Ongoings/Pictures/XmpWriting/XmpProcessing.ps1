param (
    [string]$directoryPath = "P:\Pictures\ToOrganize\ImageAssistant_Batch_Image_Downloader\Search - vintage hardcore sex _ MOTHERLESS_COM _\"
)

# Function to check for accompanying .txt and .xmp files and process tags
function ProcessImageFiles {
    param ([string]$imagePath)

    $imageName = [System.IO.Path]::GetFileNameWithoutExtension($imagePath)
    $txtFilePath =  join-path $directoryPath "$imageName.txt"
    $xmpFilePath = join-path $directoryPath "$imageName.xmp"

    # Check if .txt file exists
    if (Test-Path $txtFilePath) {
        $tags = Get-Content $txtFilePath -Raw
        $tagsArray = ($tags -split ",") | % { $_.trim()}

        # Check if .xmp file exists
        if (Test-Path $xmpFilePath) {
            # Use the previous script to add tags to the .xmp file
            try {
                & "C:\Users\CbRootz\Documents\WindowsPowerShell\ps1\Ongoings\Pictures\XmpWriting\XmpInserting.ps1" -filePath $xmpFilePath -newTags $tagsArray    
            }
            catch {
                Write-Error "failed to write to $xmpFilePath"
            }
            
        } else {
            # Call exiftool to generate a .xmp file
            try {
                '<?xpacket begin="." id="W5M0MpCehiHzreSzNTczkc9d"?><x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 4.4.0-Exiv2">  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">    <rdf:Description rdf:about="" xmlns:exif="http://ns.adobe.com/exif/1.0/" xmlns:tiff="http://ns.adobe.com/tiff/1.0/" xmlns:xap="http://ns.adobe.com/xap/1.0/" xmlns:digiKam="http://www.digikam.org/ns/1.0/" xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/" exif:DateTimeOriginal="2023-07-03T14:17:14Z" tiff:DateTime="2023-07-03T14:17:14Z" xap:MetadataDate="2023-07-03T14:17:14Z" xap:CreateDate="2023-07-03T14:17:14Z" xap:ModifyDate="2023-07-03T14:17:14Z" digiKam:ColorLabel="0" photoshop:DateCreated="2023-07-03T14:17:14Z" photoshop:Urgency="0">      <digiKam:TagsList>        <rdf:Seq>        </rdf:Seq>      </digiKam:TagsList>    </rdf:Description>  </rdf:RDF></x:xmpmeta><?xpacket end="w"?>' |
                 Out-File $xmpFilePath -Force            }
            catch {
                Write-Error "failed to exiftool to $imagePath"
            }
            
            if (Test-Path $xmpFilePath) {
                # Add tags to the newly created .xmp file
                try {
                    & "C:\Users\CbRootz\Documents\WindowsPowerShell\ps1\Ongoings\Pictures\XmpWriting\XmpInserting.ps1" -filePath $xmpFilePath -newTags $tagsArray    
                }
                catch {
                    Write-Error "failed to write to $xmpFilePath"
                }                
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
$imageFiles = Get-ChildItem -Path $directoryPath -File | Where-Object { $_.Extension -match "\.(jpg|jpeg|png|tif|tiff|webp)$" }

# Process each image file
foreach ($imageFile in $imageFiles) {
    ProcessImageFiles -imagePath $imageFile.FullName
}

Write-Host "Processing complete."
