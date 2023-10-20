# Get the name of the currently checked out branch and assign it to a variable
$initialBranch = git branch --show-current

# Get the names of the subfolders (depth 1) in the current directory and assign them to an array
$subfolders = Get-ChildItem -Directory -Depth 1 | Select-Object -ExpandProperty Name

# Loop through each subfolder in the array
foreach ($subfolder in $subfolders) {
    # Change the current directory to the subfolder
    Set-Location $subfolder

    # Try to add, commit and push the changes in the subfolder
    try {
        # Invoke git add . and capture the output
        $addOutput = Invoke-Git "add ."

        # Invoke git commit -m "auto" and capture the output
        $commitOutput = Invoke-Git "commit -m 'auto'"

        # Invoke git push and capture the output
        $pushOutput = Invoke-Git "push"

        # Check if any of the outputs contain a warning or an error
        if ($addOutput -match "warning|error" -or $commitOutput -match "warning|error" -or $pushOutput -match "warning|error") {
            # Throw an error and stop
            throw "Failed to add, commit or push changes in subfolder $subfolder"
        }
    }
    catch {
        # Write the error message and stop
        Write-Error $_.Exception.Message
        break
    }

    # Create a new branch with the name of the subfolder
    try {
        # Invoke git branch $subfolder and capture the output
        $branchOutput = Invoke-Git "branch $subfolder"

        # Check if the output contains a warning or an error
        if ($branchOutput -match "warning|error") {
            # Throw an error and continue to next folder
            throw "Failed to create branch $subfolder"
        }
    }
    catch {
        # Write the error message and continue to next folder
        Write-Error $_.Exception.Message
        continue
    }

    # Change the current directory back to the parent directory
    Set-Location ..

}

# Get the names of the branches that point to the head state of $initialBranch (except $initialBranch itself) and assign them to an array
$branches = git branch --points-at $initialBranch | Where-Object { $_ -ne "* $initialBranch" } | ForEach-Object { $_.Trim() }

# Loop through each branch in the array
foreach ($branch in $branches) {
    # Use git filter-repo with --refs flag and --path flag to filter the branch to only contain what is in that folder and set the root of the filtered branch to the root of path
    git filter-repo --refs $branch --path $branch --path-rename "$branch/":/
}

