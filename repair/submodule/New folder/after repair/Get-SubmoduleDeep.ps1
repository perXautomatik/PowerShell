function Get-SubmoduleDeep {

    <#
    .SYNOPSIS
#This script adds git submodules to a working path based on the .gitmodules file


    .PARAMETER WorkPath
    The working path where the .gitmodules file is located.

    .EXAMPLE
    GitInitializeBySubmodule -WorkPath 'B:\ToGit\Projectfolder\NewWindows\scoopbucket-1'

    #>

# requires functional git repo
# A function to get the submodules recursively for a given repo path
# should return the submodules in reverse order, deepest first, when not providing flag?
    param(
        [Parameter(Mandatory=$true)]
        [string]$RepoPath # The path to the repo
    )

    begin {
        # Validate the repo path
        Validate-PathW -Path $RepoPath

        # Change the current directory to the repo path
        Set-Location $RepoPath

        # Initialize an empty array for the result
        $result = @()
    }

    process {
        # Run git submodule foreach and capture the output as an array of lines
        $list = @(Invoke-Git "submodule foreach --recursive 'git rev-parse --git-dir'")

        # Loop through the list and skip the last line (which is "Entering '...'")
        foreach ($i in 0.. ($list.count-2)) { 
        # Check if the index is even, which means it is a relative path line
        if ($i % 2 -eq 0) 
        {
            # Create a custom object with the base, relative and gitDir properties and add it to the result array
            $result += , [PSCustomObject]@{
                base = $RepoPath
                relative = $list[$i]
                gitDir = $list[$i+1]
            }
        }
        }
        
    }

    end {
        # Return the result array
        $result 
    }
}
