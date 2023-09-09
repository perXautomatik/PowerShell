function Validate-Arguments ($modules, $folder) {

# A function to validate the arguments
  if (-not (Test-Path $modules)) { 
    Write-Error "Invalid modules path: $modules"
    exit 1
  }

  if (-not (Test-Path $folder)) {
    Write-Error "Invalid folder path: $folder"
    exit 1
  }
}
