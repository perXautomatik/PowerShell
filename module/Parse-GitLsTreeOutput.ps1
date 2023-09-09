function Parse-GitLsTreeOutput
{
#Call the Rewrite-History function Rewrite-History

# A function that parses the output of git ls-tree command and returns a custom object with properties
    [CmdletBinding()]
       param(
            # The script or file path to parse
            [Parameter(Mandatory, ValueFromPipeline)]                        
            [string[]]$LsTreeOutput
        )
        process {
            # Extract the blob type from the output line
            $blobType = $_.substring(7,4)
            # Set the hash start position based on the blob type
            $hashStartPos = 12
            if ($blobType -ne 'blob') { $hashStartPos+=2 } 
            # Set the relative path start position based on the blob type
            $relativePathStartPos = 53
            if ($blobType -ne 'blob') { $relativePathStartPos+=2 } 
            # Create a custom object with properties for unknown, blob, hash and relative path
            [pscustomobject]@{unknown=$_.substring(0,6);blob=$blobType; hash=$_.substring($hashStartPos,40);relativePath=$_.substring($relativePathStartPos)} 
     } 
}
