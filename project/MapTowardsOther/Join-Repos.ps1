function Join-Repos {
    param (
        # The first repository to join
        [Parameter(Mandatory=$true)]
        [psobject[]]$Repo1,
        # The second repository to join
        [Parameter(Mandatory=$true)]
        [psobject[]]$Repo2,
        # The result delegate to define the output format
        [Parameter(Mandatory=$true)]
        [System.Func[Object,Object,Object]]$ResultDelegate
    )
    
    # Define the key delegate to use the file name as the join condition
    $KeyDelegate = [System.Func[Object,string]] {$args[0].FileName}
    
    # Join the two repositories using Linq and return the output as an array
    $linqJoinedDataset = [System.Linq.Enumerable]::Join( $Repo1, $Repo2, #tableReference
        
                                                     $KeyDelegate,$KeyDelegate, #onClause
                
                                                     $ResultDelegate
    )
    [System.Linq.Enumerable]::ToArray($linqJoinedDataset)

}
