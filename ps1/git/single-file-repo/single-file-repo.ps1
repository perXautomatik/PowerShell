# Define the function name and alias
function single-file-repo {
    [Alias('sfrepo')]
    # Define the parameters and their attributes
    param(
        # The file parameter is mandatory and accepts pipeline input
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$file,
        # The message parameter is optional and has a default value
        [string]$message = "Updated file"
    )
    # Begin block runs once before processing any input
    begin {
        # Check if the current folder is a git repo
        if (-not (Test-Path .git)) {
            # If not, initialize a git repo and commit any existing files
            git init
            git add .
            git commit -m "Initial commit"
        }
    }
    # Process block runs for each input object
    process {
        # Check if the file parameter is a valid path
        if (Test-Path $file) {
            # If yes, use the file path as the designated path
            $path = $file
        }
        else {
            # If no, create a new file with a random name and set its content to the file parameter
            $path = "$((Get-Date).ToString('yyyyMMddHHmmss'))_$(Get-Random).txt"
            Set-Content -Path $path -Value $file
        }
        # Add and commit the designated file with the message parameter
        git add $path
        git commit -m $message
    }
}

