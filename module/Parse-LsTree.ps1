function Parse-LsTree
{
# This function parses the output of git ls-tree and converts it into a custom object with properties

    [CmdletBinding()]
       param(
            # The script or file path to parse
            [Parameter(Mandatory, ValueFromPipeline)]                        
            [string[]]$LsTree
        )
        process {
            # Extract the blob type from the input string
            $blobType = $_.substring(7,4)
            # Set the starting positions of the hash and relative path based on the blob type
            $hashStartPos = 12
            $relativePathStartPos = 53

            if ($blobType -ne 'blob')
                {
                $hashStartPos+=2
                $relativePathStartPos+=2
                } 

            # Create a custom object with properties for unknown, blob, hash and relative path
            [pscustomobject]@{unkown=$_.substring(0,6);blob=$blobType; hash=$_.substring($hashStartPos,40);relativePath=$_.substring($relativePathStartPos)} 
     
     } 
}
