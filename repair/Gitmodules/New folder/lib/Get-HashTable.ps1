function Get-HashTable {

# Define a function to create a hash table of commits and their frequencies of matching the search string
    param (
        # The commits parameter specifies the table of commits to process
        [Parameter(Mandatory=$true)]
        [array]$Commits,
        # The string parameter specifies the string to search for in each commit
        [Parameter(Mandatory=$true)]
        [string]$String,
        # The regex parameter specifies whether to use regex or not for searching (default is false)
        [Parameter(Mandatory=$false)]
        [bool]$Regex = $false
    )
    # Create an empty hash table to store the results
    $hashTable = @{}
    # Loop through each commit in the table of commits
    foreach ($commit in $commits) {
        # If regex is true, use Search-Commit-Regex function, otherwise use Search-Commit function
        if ($Regex) {
            $match = Search-Commit-Regex -Commit $commit -Regex $String
        }
        else {
            $match = Search-Commit -Commit $commit -String $String
        }
        # If there is a match, increment the frequency of the commit in the hash table, otherwise set it to zero
        if ($match) {
            $hashTable[$commit]++
        }
        else {
            $hashTable[$commit] = 0
        }
    }
    # Return the hash table of commits and frequencies
    return $hashTable
}
