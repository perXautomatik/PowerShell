function List-Git-DuplicateHashes
{
# This function lists the duplicate object hashes in a git repository using git ls-tree and Parse-LsTree functions
    param([string]$path)
    # Save the current working directory
    $current = $PWD

    # Change to the given path
    cd $path

    # Use git ls-tree to list all the objects in the HEAD revision
    git ls-tree -r HEAD |
    # Parse the output using Parse-LsTree function
    Parse-LsTree |
            # Group the objects by hash and filter out the ones that have only one occurrence 
            Group-Object -Property hash |
            ? { $_.count -ne 1 } | 
            # Sort the groups by count in descending order
                Sort-Object -Property count -Descending

    # Change back to the original working directory            
    cd $current
 }
