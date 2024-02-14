# Get the file name from the user input
$fileName = Read-Host "Enter the file name"

# Get the list of commits that changed the file
$commitList = $(git log --pretty=format:"%h %s" --name-only --follow $fileName).Split("`n")

# Loop through the commit list
for ($i = 0; $i -lt $commitList.Length; $i++) {
    # Skip empty lines
    if ($commitList[$i] -ne "") {
        # Check if the line is a commit hash or a file name
        if ($commitList[$i] -match "^[0-9a-f]{7} ") {
            # Print the commit hash and message
            Write-Host $commitList[$i]
        }
        else {
            # Print the file name
            Write-Host "File: " $commitList[$i]
            # Print the file content at that commit
            git show $($commitList[$i-1].Split(" ")[0]):$commitList[$i]
        }
    }
}

