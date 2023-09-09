function Search-Commit-Regex {

# Define a function to search for a string in a commit using git log and regex

    param (
        # The commit parameter specifies the commit hash to search in
        [Parameter(Mandatory=$true)]
        [string]$Commit,
        # The regex parameter specifies the regex pattern to search for
        [Parameter(Mandatory=$true)]
        [string]$Regex
    )
    # Use git log to search for the regex pattern in the commit and return a boolean value
    $result = git log -G $Regex -- $Commit
    return $result
}
