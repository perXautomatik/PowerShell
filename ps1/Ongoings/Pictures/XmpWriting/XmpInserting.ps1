
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
    try {
        $tagsList = $xml.SelectSingleNode($xpath, $nsmgr)
    }
    catch {
        throw "cant find rdf"
    }
    

    # Create a set to store unique tags
    $uniqueTags = New-Object 'System.Collections.Generic.HashSet[string]'

    # Check if the digiKam:TagsList element exists, if not, create it

    # Check if the digiKam:TagsList element exists, if not, create it
    if ($tagsList -eq $null) {

        $xmpmeta = $xml.SelectSingleNode("/x:xmpmeta", $nsmgr)
        if ($xmpmeta -eq $null) {
            $xmpmeta = $xml.CreateElement("x", "xmpmeta", $nsmgr.LookupNamespace("x"))
            $xml.AppendChild($xmpmeta)
        }

        $rdfRDF = $xml.SelectSingleNode("/x:xmpmeta/rdf:RDF", $nsmgr)
        if ($rdfRDF -eq $null) {
            $rdfRDF = $xml.CreateElement("rdf", "RDF", $nsmgr.LookupNamespace("rdf"))
            $xmpmeta.AppendChild($rdfRDF)    
        }

        $descriptionNode = $xml.SelectSingleNode("/x:xmpmeta/rdf:RDF/rdf:Description", $nsmgr)
        if ($descriptionNode -eq $null) {
            $descriptionNode = $xml.CreateElement("rdf", "Description", $nsmgr.LookupNamespace("rdf"))
            $rdfRDF.AppendChild($descriptionNode)
        }
        
        $tagListNode = $xml.SelectSingleNode("/x:xmpmeta/rdf:RDF/rdf:Description/digiKam:TagsList", $nsmgr)
        if ($tagListNode -eq $null) {
            $tagListNode = $xml.CreateElement("digiKam", "TagsList", $nsmgr.LookupNamespace("digiKam"))
            $descriptionNode.AppendChild($tagListNode)
        }

        $tagsList = $xml.CreateElement("rdf", "Seq", $nsmgr.LookupNamespace("rdf"))        
        $xml.SelectSingleNode("/x:xmpmeta/rdf:RDF/rdf:Description/digiKam:TagsList", $nsmgr).AppendChild($tagsList)

    } else {
        # Load existing tags into the set
        $tagsList.ChildNodes | ForEach-Object {
            $uniqueTags.Add($_.InnerText) 
        }
    }
        
    $tagsList = $xml.SelectSingleNode($xpath, $nsmgr)    
    
    if ($tagsList.ChildNodes.Count -gt 0) {
        $filtered = $tagsToAdd | ?{ !  (try { $uniqueTags.Contains($_) } catch { $false } ) }     
    }
    else {
        $filtered = $tagsToAdd;
    }
    
    $filtered | %{
        $tag = $_
        # Skip adding if the tag already exists
        if (!$uniqueTags.Add($tag)) {
            continue
        }

        # Create a new 'rdf:li' element for the tag
        $newTag = $xml.CreateElement("rdf", "li", $nsmgr.LookupNamespace("rdf"))
        $newTag.InnerText = $tag

        # Append the new tag to the TagsList
        $tagsList = $xml.SelectSingleNode($xpath, $nsmgr);
        $tagsList.AppendChild($newTag)
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
        $originalContent = LoadXmpContent -path $filePath

    }
    
    end {
        try {
            $iox = $(AddTagsToXmp -xmpContent $originalContent -tagsToAdd $qq) | select -last 1
            SaveXmpContent -path $xmpPath -xmpContent ($iox)    
        }
        catch {
            throw "xmp incompatible"            
        }
    }
