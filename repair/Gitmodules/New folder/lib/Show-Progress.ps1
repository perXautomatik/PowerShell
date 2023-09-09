function Show-Progress {

# Define a function to display a progress bar while processing a table of commits
    param (
        [Parameter(Mandatory=$true)]
        [array]$Commits,
        # The activity parameter specifies the activity name for the progress bar (default is "Searching Events")
        [Parameter(Mandatory=$false)]
        [string]$Activity = "Searching Events",
        # The status parameter specifies the status name for the progress bar (default is "Progress:")
        [Parameter(Mandatory=$false)]
        [string]$Status = "Progress:"
    )
    # Set the counter variable to zero
    $i = 0
    # Loop through each commit in the table of commits
    foreach ($commit in $commits) {
        # Increment the counter variable
        $i = $i + 1
        # Determine the completion percentage
        $Completed = ($i / $commits.count * 100)
        # Use Write-Progress to output a progress bar with the activity and status parameters
        Write-Progress -Activity $Activity -Status $Status -PercentComplete $Completed
    }
}
