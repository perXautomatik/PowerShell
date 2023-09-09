function byPath-RepoUrl {

# Define a function to get the URL of a submodule
    param(
        [string]$Path # The path of the submodule directory
    )
    # Change the current location to the submodule directory
    Push-Location -Path $Path -ErrorAction Stop
    # Get the URL of the origin remote
    $url = invoke-git "config remote.origin.url" -ErrorAction Stop
    # Parse the URL to get the part after the colon
    $parsedUrl = ($url -split ':')[1]
    # Return to the previous location
    Pop-Location -ErrorAction Stop
    # Return the parsed URL as output
    return $parsedUrl
}
