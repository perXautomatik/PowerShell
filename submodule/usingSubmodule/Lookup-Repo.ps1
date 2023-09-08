function Lookup-Repo {

# Create a lookup table based on the hash of each file in a repository
    param (
	# The repository to create the lookup table from
	[Parameter(Mandatory=$true)]
	[psobject[]]$Repo
    )

    # Define the hash delegate to use the hash as the key
    $HashDelegate = [system.Func[Object,String]] { $args[0].hash }
    # Define the element delegate to use the whole object as the value
    $ElementDelegate = [system.Func[Object]] { $args[0] }
    # Create and return the lookup table using Linq
    $lookup = [system.Linq.Enumerable]::ToLookup($Repo, $HashDelegate,$ElementDelegate)
    [Linq.Enumerable]::ToArray($lookup)
}
