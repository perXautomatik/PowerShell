function Join-GitLsTreeOutputCollectionsByFileName
{
# A function that joins two collections of parsed git ls-tree output objects based on their file names and returns a custom object with properties for hash and absolute paths of both collections

    param(
        [Parameter(Mandatory)]
        [psobject[]]$Collection1,
        [Parameter(Mandatory)]
        [psobject[]]$Collection2
    )
    # Define a delegate function that returns the file name of an object as the join key
    $KeyDelegate = [System.Func[Object,string]] {$args[0].FileName}
    # Define a delegate function that returns a custom object with properties for hash and absolute paths of both collections as the join result
    $resultDelegate = [System.Func[Object,Object,Object]]{ 
                    param ($x,$y);
                    
                    New-Object -TypeName PSObject -Property @{
                    Hash = $x.hash;
                    AbsoluteX = $x.absolute;
                    AbsoluteY = $y.absolute
                    }
                }
    
    # Use LINQ Join method to join the two collections by file name and return an array of custom objects as the result
    $joinedDataset = [System.Linq.Enumerable]::Join( $Collection1, $Collection2, #tableReference
        
                                                     $KeyDelegate,$KeyDelegate, #onClause
                
                                                     $resultDelegate
    )
    $OutputArray = [System.Linq.Enumerable]::ToArray($joinedDataset)

    return $OutputArray
}
