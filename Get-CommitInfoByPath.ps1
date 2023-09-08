function Get-CommitInfoByPath ($path) {

<#can you also write a function that uses the get-commitsByPath to return a custom object with the properties "path",date and sha1#>
can you modify this function to only include the oldest commit from get-commitsbypath#>

# Define a function that takes a relative path as a parameter
    # Call the Get-CommitsByPath function and store the result in a variable
    $commits = Get-CommitsByPath $path
    # Sort the commits by date in ascending order and select the first one
    $oldest = $commits | Sort-Object -Property "commit date" | Select-Object -First 1
    # Create a custom object with properties "path", "date" and "sha1"
    $obj = [pscustomobject]@{
        "path" = $path
        "date" = $oldest."commit date"
        "sha1" = $oldest."sha1"
    }
    # Return the object
    return $obj
}
