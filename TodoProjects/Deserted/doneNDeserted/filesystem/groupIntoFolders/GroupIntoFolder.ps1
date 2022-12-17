#https://stackoverflow.com/questions/41467996/powershell-create-a-folder-from-a-file-name-then-place-that-file-in-the-folde

$path = 'C:\Users\crbk01\OneDrive - Region Gotland\Till Github\PowerShell and bash'

 dir $path\*.* | Group-Object -Property extension -AsHashTable 

   # Get files
 # Group-Object {$_.fullname} |  # Group by part before first underscore
Get-ChildItem -File |  # Get files
  Group-Object { $_.Name -replace '^[^.]*[.]' } |  # Group by part before first underscore
  ForEach-Object {
    # Create directory
    $dir = New-Item -Type Directory -Name $_.Name
    # Move files there
    $_.Group | Move-Item -Destination $dir
  }