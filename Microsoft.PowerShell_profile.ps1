. $env:USERPROFILE\.config\WindowsPowerShell\profile.ps1

function Ensure-Path {
    param (
        [string]$Path
    )
    # Validate the parameter
    if (-not $Path) {
        Write-Error "Path parameter is required"
        return
    }
    # Check if the path is valid
    if (-not [System.IO.Path]::IsPathRooted($Path)) {
        # The path is relative, resolve it to an absolute path
        $Path = Join-Path -Path (Get-Location) -ChildPath $Path
    }
    # Check if the path contains invalid characters
    if ([System.IO.Path]::GetInvalidPathChars() -join '' -match [regex]::Escape($Path)) {
        # The path contains invalid characters, throw an error
        throw "The path '$Path' contains invalid characters."
    }
    # Check if the path exists
    if (Test-Path -Path $Path) {
        # The path exists, return it
        return $Path
    }
    else {
        # The path does not exist, try to create it
        try {
            $item = New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
            # Return the full path of the created directory
            return $item.FullName
        }
        catch {
            # An error occurred while creating the path, throw an error
            throw "Failed to create the path '$Path': $($_.Exception.Message)"
        }
    }
}
function Invoke-Git {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Command = "status" # The git command to run
    )

    if ($Command -eq "") {
        $Command = "status"
    } elseif ($Command.StartsWith("git ")) {
        $Command = $Command.Substring(4)
    }

    # Run the command and capture the output
    $output = Invoke-Expression -Command "git $Command 2>&1" -ErrorAction Stop 

    # Check the exit code and throw an exception if not zero
    if ($LASTEXITCODE -ne 0) {
        $errorMessage = $Error[0].Exception.Message
        throw "Git command failed: git $Command. Error message: $errorMessage"
    }

    # return the output to the host
    $output
}
function Spotify-UrlToPlaylist { $original = get-clipboard ; $transformed = $original.replace(“https://open.spotify.com/playlist/”, “spotify:user:spotify:playlist:”).replace(“?si=”, “=”) ; ($transformed -split '=')[0] | set-clipboard ; "done" }
function git-filter-folder
   {
      param(
      $namex
      )
      $current = git branch --show-current;
      $branchName = ('b'+$namex);
      
      git checkout -b $branchName
      
      git filter-repo --force --refs $branchName --subdirectory-filter $namex
      
      git checkout $current
      
      git filter-repo --force --refs $current --path $namex --invert-paths      
   }
function explore-to-history {
    # Get the history file path from PSReadline module
    $historyPath = (Get-PSReadlineOption).HistorySavePath

    # Get the parent folder of the history file
    $parentFolder = Split-Path -Path $historyPath -Parent

    # Open a new explorer instance at the parent folder location
    explorer.exe $parentFolder
}
function replace-delimiter {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$delimiter,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string]$replacement
    )

    # Get the clipboard content as a string
    $content = Get-Clipboard -TextFormatType Text

    # Replace each occurrence of the delimiter with the replacement
    $newContent = $content -replace [regex]::Escape($delimiter), $replacement
    echo $newContent
    # Set the clipboard to the new content if no error occurred
    
        Set-Clipboard -Value $newContent
    
}
