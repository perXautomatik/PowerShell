# source https://blogs.msmvps.com/kenlin/2021/04/01/2888/

#Create empty arrays
$datasetA = @()
$datasetB = @()
#Initialize "status" arrays to pull random values from
$genderArray = @('Male','Female','Decline to Answer')
#Loop 10 times to populate our separate datasets
1..10 | Foreach-Object {
    #Set the name with the current iteration attached
    $thisName = "Person_$_" 
    #Create an object with the name property and a random gender
    $rowA = @{
        Name = $thisName
        Gender = $genderArray[(Get-Random -Minimum 0 -Maximum 3)]
    }
    $datasetA += New-Object -Type PSObject -Property $rowA
    #Create a second object with the same name and a random age
    $rowB = @{
        Name = $thisName
        Age = Get-Random -Minimum 1 -Maximum 120
    }
    $datasetB += New-Object -Type PSObject -Property $rowB
}

$OnClause = [System.Func[Object,string]] {param ($x);$x.Name}

$outPutDefenition = [System.Func[Object,Object,Object]]{ #outPutDefenition
                    param ($x,$y);
                    
                    New-Object -TypeName PSObject -Property @{
                    Name = $x.Name;
                    Gender = $x.Gender;
                    Age = $y.Age
                    }
                }

$linqJoinedDataset = [System.Linq.Enumerable]::Join( $datasetA, $datasetB, #tableReference
        
                                                     $OnClause,$OnClause, #onClause, notice that they're just a wrapper describing how to retrive the relevant information from each object, can be identical in this example
                                
                                                     $outPutDefenition
)

$OutputArray = [System.Linq.Enumerable]::ToArray($linqJoinedDataset)
$OutputArray


