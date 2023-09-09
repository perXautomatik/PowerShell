function Get-RepoInfo {

# Get the absolute path and file name of each file in a repository
    param (
        # The repository path to scan
        [Parameter(Mandatory=$true)]
        [string]$RepoPath
    )
    # Validate the repo path parameter
    if (-not (Test-Path $RepoPath)) {
        throw "Invalid repository path: $RepoPath"
    }
    # Change the current location to the repo path
    Push-Location $RepoPath

    # Run the code block to get the output of git ls-tree command and parse it with Consume-LsTree function
    $codeBlock = {  (git ls-tree -r HEAD  | Consume-LsTree  | Select-Object -Property *,@{Name = 'absolute'; Expression = {
               $agressor = [regex]::escape('\')
               $replacement = $agressor+'\d{3}'+$agressor+'\d{3}'
       
       
                    $rp =  $_.relativePath.Trim('"')
                
                    $q = Resolve-Path $rp -ErrorAction SilentlyContinue  ; 
                 
                    if(!($q) -and $rp -match ($replacement ))
                    { 
                       $q = Resolve-Path  (($rp -split($replacement) ) -join('*')) 
                    }

                    return $q     
     } } | Select-Object -Property *,@{Name = 'FileName'; Expression = {$path = $_.absolute;$filename = [System.IO.Path]::GetFileNameWithoutExtension("$path");if(!($filename)) { $filename = [System.IO.Path]::GetFileName("$path") };$filename}},@{Name = 'Parent'; Expression = {Split-Path -Path $_.relativePath}}
) }

    # Return the output of the code block as an array
    [Linq.Enumerable]::ToArray(&$codeBlock
