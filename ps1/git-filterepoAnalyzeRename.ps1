<#
.SYNOPSIS
This script processes a 'renames.txt' file to create a mapping of renamed files.

.DESCRIPTION
The script reads a 'renames.txt' file that contains old and new file names. It creates a hashtable where each key is an original file name and the associated value is a list of new file names. It then filters this map to include only files present in the current Git tree, formats them for git-filter-repo, and copies the result to the clipboard.

.PARAMETER renamesFilePath
The path to the 'renames.txt' file containing the rename mappings.

.PARAMETER currentTree
A string array containing the list of files in the current Git tree.

.EXAMPLE
# Define the path to the renames.txt file and execute the script
$renamesFilePath = 'B:\PF\Archive\ps2\ps1\.git\filter-repo\analysis\renames.txt'
.\YourScriptName.ps1

.NOTES
This script assumes that the 'renames.txt' file is in a specific format, with each rename entry separated by '->' and each group of renames for a file separated by indentation.

.LINK
Documentation for git-filter-repo: https://github.com/newren/git-filter-repo

#>

# Define the path to the renames.txt file
[CmdletBinding()]
param (
    [Parameter()]
    [TypeName]
    $repoDir = "B:\PF\Archive\ps2\ps1\"
)

$renamesFilePath = join-path $repoDir '.git\filter-repo\analysis\renames.txt'
cd $repoDir
$currentTree = git ls-tree -r --full-name --name-only HEAD

# Initialize an empty hashtable
$renamesMap = @{}

# Read the contents of the renames.txt file
$renamesContent = Get-Content -Path $renamesFilePath

# Temporary variables to hold the current key and values
$currentKey = $null
$currentValues = @()

foreach ($line in $renamesContent) {
    if ($line -match '->') {
        # If there's a current key, add it to the hashtable before starting a new one
        if ($currentKey) {
            $renamesMap[$currentKey] = $currentValues
        }

        # Split the line at '->' to get the key
        $currentKey = ($line -split '->' )[0].Trim()
        # Reset the current values array
        $currentValues = @()
    } elseif ($line.StartsWith("    ")) {
        # If the line starts with a tab, it's a value for the current key
        $currentValues += $line.Trim()
    }
}

# Add the last key-value pair to the hashtable
if ($currentKey -and $currentValues) {
    $renamesMap[$currentKey] = $currentValues
}

# Output the hashtable
$regex = "[^a-zA-Z0-9]"
$u = $renamesMap.GetEnumerator() | ? { $_.Key -in $currentTree } | Sort-Object -Property Key | % { $x = $_.Key; $_.Value | %{ "regex:$($x -replace $regex,".")==>$($_)" } }
$u | Set-Clipboard
