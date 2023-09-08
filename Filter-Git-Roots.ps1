function Filter-Git-Roots {
    
<#
.SYNOPSIS
Filters out the objects that have a git root equal to their path and creates an array of roots.

.DESCRIPTION
This function filters out the objects that have a git root equal to their path and creates an array of roots, using a custom class for roots and a Where-Object filter.

.PARAMETER Objects
The array of custom objects to filter.
#>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true)]
	[PSCustomObject[]]
	$Objects
    )

    # Define a class for roots
    class Root {
	[string] $Name;
	[string] $gitRoot;
	Root($name, $gitRoot) {
	    $this.name = $name
	    $this.gitRoot = $gitRoot
	}
    }

    # Filter out the objects that have a git root equal to their path and create an array of roots
[Path[]]$Paths = @($z | ? { $_.gitRoot -ne "fatal: this operation must be run in a work tree" } | % {[Path]::new($_.FolderName, $_.path) })
    [Root[]]$Roots = @($Objects | Where-Object { ($_.gitRoot -replace('/', '\')) -eq $_.path } | ForEach-Object { [Root]::new($_.FolderName, $_.GitRoot) })

$outerKeyDelegate = [Func[Path,String]] { $args[0].Name }
$innerKeyDelegate = [Func[Root,String]] { $args[0].Name }

#In this instance both joins will be using the same property name so only one function is needed
[System.Func[System.Object, string]]$JoinFunction = {
    param ($x)
    $x.Name
}

#This is the delegate needed in GroupJoin() method invocations
[System.Func[System.Object, [Collections.Generic.IEnumerable[System.Object]], System.Object]]$query = {
    param(
	$LeftJoin,
	$RightJoinEnum
    )
    $RightJoin = [System.Linq.Enumerable]::SingleOrDefault($RightJoinEnum)

    New-Object -TypeName PSObject -Property @{
	Name = $RightJoin.Name;
	GitRoot = $RightJoin.GitRoot;
	Path = $LeftJoin.Path
    }
}

#And lastly we call GroupJoin() and enumerate with ToArray()
$q = [System.Linq.Enumerable]::ToArray(
    [System.Linq.Enumerable]::GroupJoin($Paths, $Roots, $JoinFunction, $JoinFunction, $query)
)  | ? { ($_.name -ne "") -and ($null -ne $_.name) }

    $q | Out-GridView
}
