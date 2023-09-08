function Get-PathsByFile ($filename) {

<#can you write me a powershell function with a filename as parameter, that uses git log --follow to list each unique path the file has bin at#>

# Define a function that takes a filename as a parameter
    # Use git log --follow to get a list of all commits touching the file, including renames
    $log = git log --follow --name-only --format="" $filename
    # Split the log by newline and store it in an array
    $paths = $log -split "`n"
    # Remove any empty elements from the array
    $paths = $paths | Where-Object {$_}
    # Get the unique elements from the array
    $paths = $paths | Select-Object -Unique
    # Return the array
    return $paths
}
