function Get-Commits {
    param (
        # The date parameter specifies the cut-off date for the commits
        [Parameter(Mandatory=$true)]
        [string]$Date
    )
    # Use git log to get all commit hashes before the date in a table format
    $commits = git log --all --before="$Date" --pretty=format:"%H"
    # Return the table of commits
    return $commits
}
