
$currentLocation = Get-Location

$fileNames = $currentLocation | Get-ChildItem -Path .\ -Filter *.sql -File -Name | ForEach-Object {
  [System.IO.Path]::GetFileNameWithoutExtension($_)
}

$folderName = Split-Path $currentLocation -leaf


$inputFile = 
$outputFile = 
 
$filters = ":"

$lineNames = Get-Contents $inputFile | Select-String -pattern $filters 




In file Look for lines ending with:

for each line with : get line number

#underneth each line insert file with name excluding extension
#into file called same as folder name.
$fileContent = Get-Content $filePath
$fileContent[$lineNumber-1] += $textToAdd
$fileContent | Set-Content $filePath

| Out-File $outputFile


if no file found with name such as folder, prompt error
if no files found with name such as lines with : propmpt for error
if no lines with : exsits in file prompt for error.