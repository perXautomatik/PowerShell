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
    param ([xml]$xmpContent, [string[]]$tagsToAdd)
    

        $xml = $xmpContent

    # Find all `significant namespace declarations` from the XML file
    $nsList = $xml.SelectNodes("//namespace::*[not(. = ../../namespace::*)]")
    # Then add them into the NamespaceManager
    $nsmgr = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $nsList | ForEach-Object {
        $nsmgr.AddNamespace($_.LocalName, $_.Value)
    }

    # Getting hash from XML, using XPath
    
$xpath = "/x:xmpmeta/rdf:RDF/rdf:Description/digiKam:TagsList/rdf:Seq"
$q = $xml.SelectSingleNode($xpath, $nsmgr)
    $tagsList = $q 
    
    # Create a set to store unique tags
    $uniqueTags = New-Object 'System.Collections.Generic.HashSet[string]'

    # Check if the digiKam:TagsList element exists, if not, create it
    if ($tagsList -eq $null) {
        $desc = $xmpContent.SelectSingleNode("/x:xmpmeta/rdf:RDF/rdf:Description", $nsmgr)
        
        $tagsList = $xmpContent.CreateElement("digiKam:TagsList", $ns.dk)
        $seq = $xmpContent.CreateElement("rdf:Seq", $rdf.rdf)
        $tagsList.AppendChild($seq) > $null
        $desc.AppendChild($tagsList) > $null
    } else {
        # Load existing tags into the set
        $tagsList.ChildNodes | %{ 
            $u = $_.InnerText
            $uniqueTags.Add($u) 
        }
    }

    # Add new tags to the set if they're not already present
    $tagsToAdd | ForEach-Object {
        if (-not $uniqueTags.Contains($_)) {
            $uniqueTags.Add($_)
            $newTag = $xmpContent.CreateElement("rdf:li", $rdf.rdf)
            $newTag.InnerText = $_
            $tagsList.FirstChild.AppendChild($newTag) > $null
        }
    }

    # Save the modified XMP content
    SaveXmpContent -xmpContent $xmpContent -path $filePath

    # Verification step
    $verificationContent = LoadXmpContent -path $filePath
    $verifiedTagsList = $verificationContent.SelectSingleNode("//dk:TagsList", $ns)
    $verifiedTags = $verifiedTagsList.FirstChild.ChildNodes | ForEach-Object { $_.InnerText }

    # Compare expected tags with verified tags
    $isVerified = $uniqueTags.SetEquals($verifiedTags)
    if (-not $isVerified) {
        Write-Host "Verification failed. The XMP file does not contain the expected tags."
        # Attempt to revert changes by restoring the original content
        SaveXmpContent -xmpContent $originalContent -path $filePath
    } else {
        Write-Host "Tags added and verified successfully."
    }
}

function example {
    param (
    [string]$filePath,
    [string[]]$newTags
    )

# Load the original XMP content before making changes
$originalContent = LoadXmpContent -path $filePath

# Add the new tags
AddTagsToXmp -xmpContent $originalContent -newTags $newTags

}

AddTagsToXmp (LoadXmpContent -Path "P:\Images\mobilBakgrund\f_01b2c0.JFIF.xmp") -newTags $tagsArray