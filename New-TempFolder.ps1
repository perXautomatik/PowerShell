function New-TempFolder {
  # Define a function to create a temporary folder and return its path
  $tempPath = [System.IO.Path]::GetTempPath()
  $tempName = [System.IO.Path]::GetRandomFileName()
  $tempFolder = Join-Path $tempPath $tempName
  New-Item -ItemType Directory -Path $tempFolder | Out-Null
  return $tempFolder
}
