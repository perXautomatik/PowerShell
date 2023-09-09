function Add-MorePropertiesToGitLsTreeOutput
{

# A function that takes a collection of parsed git ls-tree output objects and adds more properties to them such as absolute path, file name and parent folder
    param(
        [Parameter(Mandatory)]
        [psobject[]]$GitLsTreeOutputObjects
    )
    # For each object in the collection, add more properties using calculated expressions
    $GitLsTreeOutputObjects | Select-Object -Property *,@{Name = 'absolute'; Expression = {Resolve-AbsolutePath $_.relativePath}},@{Name = 'FileName'; Expression = {$path = $_.absolute;$filename = [System.IO.Path]::GetFileNameWithoutExtension("$path");if(!($filename)) { $filename = [System.IO.Path]::GetFileName("$path") };$filename}},@{Name = 'Parent'; Expression = {Split-Path -Path $_.relativePath}}
}
