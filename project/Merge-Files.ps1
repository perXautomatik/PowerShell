function Merge-Files {
    <#
    .Synopsis
    This function processes a list of files and merges them into a new folder with the same name as the target file
    .Parameter Files
    An array of file paths to process. If not specified, it will use the current directory
    .Parameter Target
    The path of the target file to use as the base name for the merged files. If not specified, it will use the first file in the list
    .Example
    Merge-Files -Files ".\foo\bar.txt", ".\foo\baz.txt" -Target ".\foo\bar.txt"
    #>
    [CmdletBinding()]
    param (
      # The list of files to process
      [Parameter(Mandatory=$false)]
      [ValidateScript({Test-Path $_})]
      [string[]]$Files,

      # The target file to use as the base name
      [Parameter(Mandatory=$false)]
      [ValidateScript({Test-Path $_})]
      [string]$Target
    )

    # Get the files to process from the parameter or use the current directory
    if ($Files -eq $null) {
      $Files = Get-ChildItem -Path . -Recurse -File
    }

    # Get the target file from the parameter or use the first file
    if ($Target -eq $null) {
      $Target = $Files[0]
    }

    # Get the name of the target file without the extension
    $targetName = [System.IO.Path]::GetFileNameWithoutExtension($Target)

    # Create a new folder called merged if it does not exist
    $mergedFolder = "merged"
    if (-not (Test-Path $mergedFolder)) {
      New-Item -ItemType Directory -Path $mergedFolder
    }

    # Create a tag with "before merge" message using the function defined above
    New-GitTag -TagName "before merge" -TagMessage "Before merge"

    # Loop through the files and move them to the merged folder with the target name using functions defined above
    foreach ($file in $Files) {

      # Get the relative path of the file in the repo using function defined above
      $relativePath = Get-GitRelativePath -FilePath $file

      # Move the file to the merged folder with the target name and extension
      $newFile = Join-Path $mergedFolder "$targetName$([System.IO.Path]::GetExtension($file))"

       Move-Item -Path $file -Destination $newFile

       # Commit the change with the relative path as the message
       git add $newFile
       git commit -m $relativePath

       # Create a tag with the index of the file as the message using function defined above
       New-GitTag -TagName $Files.IndexOf($file) -TagMessage  $Files.IndexOf($file)

       # Reset the repo hard to the before merge tag using function defined above
       Reset-GitHard -TagName "before merge"
    }

    # Loop through the tags created with index and merge them to the repo using function defined above
    $tags = git tag -l | Where-Object {$_ -match "\d+"}
    foreach ($tag in $tags) {
      # Merge the tag to the repo and resolve conflicts by unioning files using function defined above
      Merge-GitTag -TagName $tag
    }
  }
