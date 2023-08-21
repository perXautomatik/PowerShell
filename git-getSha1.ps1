# A function that takes a path to a local git repo as input
# and returns the list of commits on the current branch
Function Get-Sha1 {
    Param (
        # The path to the local git repo
        [Parameter(Mandatory=$true)]
        [string]$RepoPath
    )

    # Change the current directory to the repo path
    Set-Location $RepoPath

    # Get the current branch name
    $BranchName = git rev-parse --abbrev-ref HEAD

    # Get the list of commits on the current branch
    $Commits = git rev-list $BranchName

    # Return the list of commits
    return $Commits
}

# A function that takes a list of commits as input
# and prints file names, file sizes and checksums of files affected by each commit
Function Get-FilesSha1 {
    Param (
        # The list of commits
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$Commits,

        # The path to the local git repo
        [Parameter(Mandatory=$true)]
        [string]$RepoPath,

        # The flag to suppress errors and continue
        [switch]$Force
    )

    Begin {
        # Create an empty array to store the output
        $Output = @()

        # Check if the path is a valid git repository
        $IsGitRepo = git -C $RepoPath rev-parse 2>/dev/null

        # If not, throw an error or write a warning, depending on the Force flag
        if (-not $IsGitRepo) {
            if ($Force) {
                Write-Warning "The path $RepoPath is not a valid git repository. Skipping..."
                return
            }
            else {
                Throw "The path $RepoPath is not a valid git repository. Use -Force to ignore this error and continue."
            }
        }

        # Change the current directory to the repo path
        Set-Location $RepoPath

        # Get the current branch name
        $BranchName = git rev-parse --abbrev-ref HEAD
    }

    Process {
        
        # Loop through each commit in the input
        foreach ($Commit in $Commits) {
            # Check if the commit exists in the current branch
            $IsCommitValid = git merge-base --is-ancestor $Commit $BranchName 2>/dev/null

            # If not, throw an error or write a warning, depending on the Force flag
            if (-not $IsCommitValid) {
                if ($Force) {
                    Write-Warning "The commit $Commit does not exist in the current branch $BranchName. Skipping..."
                    continue
                }
                else {
                    Throw "The commit $Commit does not exist in the current branch $BranchName. Use -Force to ignore this error and continue."
                }
            }

            # Get the commit hash and message
            $CommitMessage = git log -1 --format=%s $Commit

            # Get the list of files affected by the commit
            $Files = git diff-tree --no-commit-id --name-only -r $Commit

            # Loop through each file in the commit
            foreach ($File in $Files) {
                # Get the file size in bytes
                $FileSize = (Get-Item $File).Length

                # Format the file size to human-readable units
                $FileSizeFormatted = [math]::Round($FileSize / 1KB, 2)
                if ($FileSizeFormatted -ge 1MB) {
                    $FileSizeFormatted = [math]::Round($FileSize / 1MB, 2) + " MB"
                }
                elseif ($FileSizeFormatted -ge 1KB) {
                    $FileSizeFormatted = [math]::Round($FileSize / 1KB, 2) + " KB"
                }
                else {
                    $FileSizeFormatted = $FileSize + " B"
                }

                # Get the file content as it is stored in the commit
                $u = "git show $Commit"+":"+"$File"
                $FileContent = invoke-expression $u

                # Calculate the checksum for the file content using MD5 algorithm
                $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
                $utf8 = New-Object -TypeName System.Text.UTF8Encoding
                $b = $utf8.GetBytes($FileContent)
                $h = $md5.ComputeHash($b)
                $Checksum = [System.BitConverter]::ToString($h)

                # Create a custom object to store the file information
                $FileInfo = [PSCustomObject]@{
                    Commit = $Commit
                    Message = $CommitMessage
                    File = $File
                    Size = $FileSizeFormatted
                    Checksum = $Checksum
                }

                # Add the custom object to the output array
                $Output += $FileInfo
            }
        }
    }

    End {
        # Return the output array
        return $Output
    }
}


cd $localrepopath ; Get-Sha1 | Get-FilesSha1 | Format-Table -AutoSize -Wrap -GroupBy Commit 
