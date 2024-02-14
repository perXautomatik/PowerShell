# Define a function with parameters for the file name and the commit sha
function Compare-GitLog {
    # Add a comment based help block to describe the function and the parameters
    <#
    .SYNOPSIS
    Compares the file content at a given commit to all results in show-gitlog.
    .DESCRIPTION
    This function uses the show-gitlog function to get the list of commits and file contents for a specified file name. It then uses the git diff-tree command to compare the file content at a given commit sha to each of the results, and returns the "removed-add-modified" statistics of each comparison.
    .PARAMETER FileName
    The name of the file to compare the file content for.
    .PARAMETER CommitSha
    The commit sha to compare the file content at.
    .EXAMPLE
    Compare-GitLog -FileName CollectionHolder.cs -CommitSha 3a5b6c7
    #>

    # Use the Param block to declare the parameters
    Param (
        # Use the ValidateNotNullOrEmpty attribute to ensure the parameters are not null or empty
        [ValidateNotNullOrEmpty()]
        # Use the string type to specify the parameter types
        [string]$FileName,
        [string]$CommitSha
    )

    # Use the Begin block to initialize variables and perform one-time tasks
    Begin {
        # Get the list of commits and file contents from the show-gitlog function
        $gitLog = Show-GitLog -FileName $FileName
        # Initialize an empty array to store the output objects
        $output = @()
    }

    # Use the Process block to perform actions on each input object
    Process {
        # Loop through the git log results
        foreach ($result in $gitLog) {
            # Use the git diff-tree command to compare the file content at the given commit sha to the file content at the current result
            # Use the --numstat option to show the number of lines added, removed, and modified
            # Use the --no-commit-id option to suppress the commit id output
            # Use the -- $FileName option to limit the comparison to the specified file name
            $comparison = git diff-tree --numstat --no-commit-id $CommitSha $result.Hash -- $FileName
            # Split the comparison output by whitespace
            $comparison = $comparison.Split()
            # Assign the output values to variables
            $added = $comparison[0]
            $removed = $comparison[1]
            $file = $comparison[2]
            $modified = $added + $removed
            # Create a custom object with the fields
            $object = [PSCustomObject]@{
                Hash = $result.Hash
                Message = $result.Message
                Removed = $removed
                Added = $added
                Modified = $modified
            }
            # Add the object to the output array
            $output += $object
        }
    }

    # Use the End block to perform final actions and clean up resources
    End {
        # Return the output array
        return $output
    }
}

