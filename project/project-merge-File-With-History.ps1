<#
   ========================================================================================================================
   Name         : <Name>.ps1
   Description  : This script ............................
   Created Date : %Date%
   Created By   : %UserName%
   Dependencies : 1) Windows PowerShell 5.1
                  2) .................

   Revision History
   Date       Release  Change By      Description
   %Date% 1.0      %UserName%     Initial Release
   ========================================================================================================================
#>
<#can you write me a powershell script that takes a number of files as input, for each file assume each file belonge to the same git repo; begin block; tag with "before merge", select one of the files (arbitarly, if non specified as parameter) as the target file, process block; for each file; move file to a new folder called merged, rename the file to same name as target file, commit this change with message: original relative path in repo, create a tag with index of the for each, reset the repo hard to the before merge tag. end block; for each tag created with index, do merge this tag to repo, resolve the merge by unioning both of the conflicting files#>

. .\New-GitTag.ps1

. .\Get-GitRelativePath.ps1


. .\Reset-GitHard.ps1


. .\Merge-GitTag.ps1

. .\mergeBranchAnResolve.ps1

. .\Rename-File.ps1

. .\prefixCommit.ps1

# Get the files to process from the command line or use the current directory
$files = $args
if ($files -eq $null) {
    $files = Get-ChildItem -Path . -Recurse -File
}

# Get the target file from the command line or use the first file
$target = $args[0]
if ($target -eq $null) {
    $target = $files[0]
}

# Get the name of the target file without the extension
$targetName = [System.IO.Path]::GetFileNameWithoutExtension($target)

# Create a new folder called merged if it does not exist
$mergedFolder = "merged"
if (-not (Test-Path $mergedFolder)) {
    New-Item -ItemType Directory -Path $mergedFolder
}

# Create a tag with "before merge" message using the function defined above
New-GitTag -TagName "before merge" -TagMessage "Before merge"

# Loop through the files and move them to the merged folder with the target name using functions defined above
foreach ($file in $files) {

    # Get the relative path of the file in the repo using function defined above
    $relativePath = Get-GitRelativePath -FilePath $file

    # Move the file to the merged folder with the target name and extension
    $newFile = Join-Path $mergedFolder "$targetName$([System.IO.Path]::GetExtension($file))"

     Move-Item -Path $file -Destination $newFile

     # Commit the change with the relative path as the message
     git add $newFile
     git commit -m $relativePath

     # Create a tag with the index of the file as the message using function defined above
     New-GitTag -TagName $files.IndexOf($file) -TagMessage  $files.IndexOf($file)

     # Reset the repo hard to the before merge tag using function defined above
     Reset-GitHard -TagName "before merge"
}

# Loop through the tags created with index and merge them to the repo using function defined above
$tags = git tag -l | Where-Object {$_ -match "\d+"}
foreach ($tag in $tags) {
    # Merge the tag to the repo and resolve conflicts by unioning files using function defined above
    Merge-GitTag -TagName $tag
}
#using git filter-repo filter a repo into a new branch

# Create a new branch from the current one
git checkout -b $filename
# Filter the new branch to only keep files with filenames name
git filter-repo --path-glob '*$filename*'




# Create a file that contains the replacement rule
echo "refs/heads/master:81a708d refs/heads/project-history/master:c6e1e95" > replacements.txt

# Use git-filter-repo to replace the commit
git filter-repo --replace-refs replacements.txt
