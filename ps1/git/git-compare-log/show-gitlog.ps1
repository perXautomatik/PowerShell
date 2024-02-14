# Define a function with a parameter for the file name
function Show-GitLog {
    # Add a comment based help block to describe the function and the parameter
    <#
    .SYNOPSIS
    Shows the git log and file content for a given file name.
    .DESCRIPTION
    This function uses the git log and git show commands to display the list of commits and the file content for a specified file name.
    .PARAMETER FileName
    The name of the file to check the git log and file content for.
    .EXAMPLE
    Show-GitLog -FileName CollectionHolder.cs
    #>
    
    # Use the Param block to declare the parameter
    Param (
        # Use the ValidateNotNullOrEmpty attribute to ensure the parameter is not null or empty
        [ValidateNotNullOrEmpty()]
        # Use the string type to specify the parameter type
        [string]$FileName
    )

    # Use the Begin block to initialize variables and perform one-time tasks
    Begin {
        # Get the list of commits that changed the file
        $commitList = $(git log --pretty=format:"%h %s" --name-only --follow $FileName).Split("`n")
        # Initialize the commit index
        $commitIndex = 0
        # Initialize an empty array to store the output objects
        $output = @()
    }

    # Use the Process block to perform actions on each input object
    Process {
        # Loop through the commit list
        for ($i = 0; $i -lt $commitList.Length; $i++) {
            # Skip empty lines
            if ($commitList[$i] -ne "") {
                # Check if the line is a commit hash or a file name
                if ($commitList[$i] -match "^[0-9a-f]{7} ") {
                    # Store the commit hash and message in variables
                    $hash = $commitList[$i].Split(" ")[0]
                    $message = $commitList[$i].Split(" ", 2)[1]
                }
                else {
                    # Store the file name in a variable
                    $file = $commitList[$i]
                    # Get the file content at that commit
                    $content = git show $hash:$file
                    # Create a custom object with the fields
                    $object = [PSCustomObject]@{
                        Hash = $hash
                        Message = $message
                        File = $file
                        Content = $content
                    }
                    # Add the object to the output array
                    $output += $object
                }
            }
        }
    }

    # Use the End block to perform final actions and clean up resources
    End {
        # Return the output array
        return $output
    }
}

