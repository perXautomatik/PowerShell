function Get-SubmoduleUrl {
  
# Define a function to get the URL of a submodule

  param(
    [string]$Path # The path of the submodule directory
  )
  # Change the current location to the submodule directory
  Push-Location -Path $Path -ErrorAction Stop
  # Get the URL of the origin remote
  $url = git config remote.origin.url -ErrorAction Stop
  # Write the URL to the host
  Write-Host $url
  # Parse the URL to get the part after the colon
  $parsedUrl = ($url -split ':')[1]
  # Write the parsed URL to the host
  Write-Host $parsedUrl
  # Return to the previous location
  Pop-Location -ErrorAction Stop
}
