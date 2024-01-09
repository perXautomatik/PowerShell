. $env:USERPROFILE\.config\WindowsPowerShell\profile.ps1
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
