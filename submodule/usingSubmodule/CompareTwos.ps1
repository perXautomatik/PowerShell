
. .\Consume-LsTree.ps1

. .\Get-RepoInfo.ps1

. .\Join-Repos.ps1

. .\Lookup-Repo.ps1

# Main script

# Get the paths of the two repositories to compare
$repoPath1 = 'D:\Project Shelf\PowerShellProjectFolder\scripts'
$repoPath2 = 'D:\Project Shelf\PowerShellProjectFolder'

# Get the info of each repository using Get-RepoInfo function
$repo1 = Get-RepoInfo -RepoPath $repoPath1
$repo2 = Get-RepoInfo -RepoPath $repoPath2

# Define the result delegate to format the output of Join-Repos function
$resultDelegate = [System.Func[Object,Object,string]] { '{0} x_x {1}' -f $args[0].absolute, $args[1].absolute }

# Join the two repositories using Join-Repos function and store the output in an array
$OutputArray = Join-Repos -Repo1 $repo1 -Repo2 $repo2 -ResultDelegate $resultDelegate

# Create a lookup table for each repository using Lookup-Repo function
$lookup1 = Lookup-Repo -Repo $repo1
$lookup2 = Lookup-Repo -Repo $repo2

# Display the results
Write-Output "Output array:"
$OutputArray

Write-Output "Lookup table 1:"
$lookup1

Write-Output "Lookup table 2:"
$lookup2

