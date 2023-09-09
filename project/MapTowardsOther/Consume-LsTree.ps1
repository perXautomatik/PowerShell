function Consume-LsTree {
    [CmdletBinding()]
    param(
        # The script or file path to parse
        [Parameter(Mandatory, ValueFromPipeline)]                        
        [string[]]$LsTree
    )
    # Add a synopsis comment
    <#
        .SYNOPSIS
        Parse the output of git ls-tree command and return a custom object.

        .DESCRIPTION
        This function takes the output of git ls-tree command as input and extracts the blob type, hash and relative path of each file. It returns a custom object with these properties.

        .EXAMPLE
        git ls-tree -r HEAD | Consume-LsTree

        This example parses the output of git ls-tree -r HEAD command and returns a custom object with blob type, hash and relative path of each file in the current branch.
    #>
    process {
        # Get the blob type from the input string
        $blobType = $_.substring(7,4)
        # Set the start positions of hash and relative path based on the blob type
        $hashStartPos = 12
        $relativePathStartPos = 53

        if ($blobType -ne 'blob')
            {
            $hashStartPos+=2
            $relativePathStartPos+=2
            } 

        # Create and return a custom object with the extracted properties
        [pscustomobject]@{unkown=$_.substring(0,6);blob=$blobType; hash=$_.substring($hashStartPos,40);relativePath=$_.substring($relativePathStartPos)} 
     
     } 
}
