# Define a hash table for the priority order of file names
$Priority = @{
    "functions.psm1" = 1
    "prompt.psm1" = 2
}
$lastPriortity = 10
# Get all .ps1 files in the current directory except profile and importModules
$d = Get-ChildItem -Path $PSScriptRoot\*.psm1

# Sort the files by their priority values
$d = $d | Sort-Object -Property { if ($Priority.ContainsKey($_.Name)) { $Priority[$_.Name] } else { $lastPriortity } }

# Dot-source each file and write a message
$d | Foreach-Object {
     import-module -name $_.FullName 
     Write-Host "loaded:" + $_.FullName 
}

