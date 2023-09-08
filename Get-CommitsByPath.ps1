function Get-CommitsByPath ($path) {
# Define a function that takes a relative path as a parameter
    # Use git log --follow to get a list of all commits touching the path, including renames
    $log = git log --follow --format="%ad %H" --date=iso $path
    # Split the log by newline and loop through each line
    foreach ($line in $log -split "`n") {
        # Split the line by space and assign the first part to $date and the second part to $sha1
        $date, $sha1 = $line -split " ", 2
        # Create a custom object with properties "commit date" and "sha1"
        $obj = [pscustomobject]@{
            "commit date" = $date
            "sha1" = $sha1
        }
        # Return the object
        return $obj
    }
}
