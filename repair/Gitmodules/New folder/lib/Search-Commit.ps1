function Search-Commit {

# Define a function to search for a string in a commit using git grep
    param (
        # The commit parameter specifies the commit hash to search in
        [Parameter(Mandatory=$true)]
        [string]$Commit,
        # The string parameter specifies the string to search for
        [Parameter(Mandatory=$true)]
        [string]$String
    )
    # Use git grep to search for the string in the commit and return a boolean value
    $result = git grep --ignore-case --word-regexp --fixed-strings -o $String -- $Commit
    return $result
}
