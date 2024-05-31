param (
    [string]$filePath,
    [string[]]$newTags
)

# Function to load the XMP content and return as XML
function LoadXmpContent {
    param ([string]$path)
    [xml]$xmpContent = Get-Content -Path $path
    return $xmpContent
}

# Function to save the modified XML back to the XMP file
function SaveXmpContent {
    param ([xml]$xmpContent, [string]$path)
    $xmpContent.Save($path)
}

# Function to add new tags to the digiKam:TagsList
function AddTagsToXmp {
    param ([xml]$xmpContent, [string[]]$tags)
    $ns = @{dk = "http://www.digikam.org/ns/1.0/"}
    $rdf = @{rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"}
    $tagsList = $xmpContent.SelectSingleNode("//dk:TagsList", $ns)
    
    # Check if the digiKam:TagsList element exists, if not, create it
    if ($tagsList -eq $null) {
        $desc = $xmpContent.SelectSingleNode("//rdf:Description", $rdf)
        $tagsList = $xmpContent.CreateElement("digiKam:TagsList", $ns.dk)
        $seq = $xmpContent.CreateElement("rdf:Seq", $rdf.rdf)
        $tagsList.AppendChild($seq) > $null
        $desc.AppendChild($tagsList) > $null
    }

    # Add new tags
    foreach ($tag in $tags) {
        $newTag = $xmpContent.CreateElement("rdf:li", $rdf.rdf)
        $newTag.InnerText = $tag
        $tagsList.FirstChild.AppendChild($newTag) > $null
    }
}

# Load the XMP content
$xmpContent = LoadXmpContent -path $filePath

# Add the new tags
AddTagsToXmp -xmpContent $xmpContent -tags $newTags

# Save the modified XMP content
SaveXmpContent -xmpContent $xmpContent -path $filePath

Write-Host "Tags added successfully."
