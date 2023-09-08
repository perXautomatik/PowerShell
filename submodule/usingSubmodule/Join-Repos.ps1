function Join-Repos {

# Join two repositories based on their file names and return a custom object with their hashes and absolute paths
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
$resultDelegate = [System.Func[Object,Object,Object]]{ #outPutDefenition
		    param ($x,$y);

		    New-Object -TypeName PSObject -Property @{
		    Hash = $x.hash;
		    AbsoluteX = $x.absolute;
		    AbsoluteY = $y.absolute
		    }
		}
$resultDelegate = [System.Func[Object,Object,string]] { '{0} x_x {1}' -f $args[0].absolute, $args[1].absolute }

    # Join the two repositories using Linq and return the output as an array
    $linqJoinedDataset = [System.Linq.Enumerable]::Join( $Repo1, $Repo2, #tableReference

						     $KeyDelegate,$KeyDelegate, #onClause

						     $ResultDelegate
    )
    [System.Linq.Enumerable]::ToArray($linqJoinedDataset)

}
