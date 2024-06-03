
    [CmdletBinding()]
    param (
        [string]$filePath = "P:\Images\mobilBakgrund\f_01b2c0.JFIF.xmp",
        [string[]]$newTags
    )
    
    
    begin {
        
function Get-tags {
    param (
        $xmp
    )
    
    $imageName = [System.IO.Path]::GetFileNameWithoutExtension($xmp)
    $directoryPath = ($xmp | Split-Path -Parent)
    $txtFilePath = "$directoryPath\$imageName.txt"
    
    # Check if .txt file exists
    if (Test-Path $txtFilePath) {
        $tags = Get-Content $txtFilePath -Raw
        return ($tags -split ",") | % { $_.trim()}
    }    
}

# Function to load the XMP content and return as XML
function LoadXmpContent {
    param ([string]$path)
    [xml]$xmpContent = Get-Content -Path $path -Encoding UTF8
    return $xmpContent
}

# Function to save the modified XML back to the XMP file
function SaveXmpContent {
    # Save the modified XMP content
    param ([xml]$xmpContent, [string]$path)
<#
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
#>
    $xmpContent.Save($path)
}

# Function to add new tags to the digiKam:TagsList
function AddTagsToXmp {
    param ([xml]$xmpContent, [string[]]$tagsToAdd)

    $xml = $xmpContent

    # Find all significant namespace declarations from the XML file
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
    if ($tagsList -eq $null -or $tagsList.ChildNodes.Count -eq 0) {
        $desc = $xmpContent.SelectSingleNode("/x:xmpmeta/rdf:RDF/rdf:Description", $nsmgr)
        if ($desc -eq $null ) {
            $desc = $xml.CreateElement("rdf", "Description", $nsmgr.LookupNamespace("rdf"))
            $rdfRDF = $xml.SelectSingleNode("/x:xmpmeta/rdf:RDF", $nsmgr)
            $rdfRDF.AppendChild($desc)
        }
        $tagsList = $xml.CreateElement("rdf", "Seq", $nsmgr.LookupNamespace("rdf"))
        $desc.AppendChild($tagsList)
    } else {
        # Load existing tags into the set
        $tagsList.ChildNodes | %{ 
            $u = $_.InnerText
            $uniqueTags.Add($u) 
        }
    }

    # Add new tags to the TagsList
    foreach ($tag in $tagsToAdd) {
        # Skip adding if the tag already exists
        if (!$uniqueTags.Add($tag)) {
            continue
        }

        # Create a new 'rdf:li' element for the tag
        $newTag = $xml.CreateElement("rdf", "li", $nsmgr.LookupNamespace("rdf"))
        $newTag.InnerText = $tag

        # Append the new tag to the TagsList
        $xml.SelectSingleNode($xpath, $nsmgr).AppendChild($newTag)
    }
    $uio = [string]$xml.OuterXml
    

    return $uio.trim('"');
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


    }
    
    process {
        $xmpPath = $filePath;

        if ($newTags.Count -gt 0) {
            
        }
        else {
            $newTags = (Get-tags -xmp $filePath)
        }
        $qq = $newTags;
    }
    
    end {
                
        $iox = $(AddTagsToXmp -xmpContent (LoadXmpContent -Path $xmpPath) -tagsToAdd $qq) | select -last 1


        SaveXmpContent -path $xmpPath -xmpContent ($iox)

    }
