function Extract-Submodules {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$Paths
    )

    begin {
        # initialize an empty array to store the paths
        $SubmodulePaths = @()
        
        # get the paths of all submodules if not specified, at current path
        if (-not $SubmodulePaths) {
            $SubmodulePaths = Get-SubmodulePaths
        }
        # add the pipeline input to the array
        $SubmodulePaths += $Paths
    }

    process {
       
        # loop through each submodule path
        foreach ($Path in $SubmodulePaths) {
            # check if the path ends with /.git and append it if not
            if (-not $Path.EndsWith("/.git")) {
                $orgPath = $path
                $Path = Test-Path -Path "$Path/.git" -PassThru
                if(!($Path))
                {
                    $path = $orgPath
                }

            }

        # check if the submodule has a .git file
        if (Test-Path -Path "$Path/.git" -PathType Leaf) {
            # get the absolute path of the .git directory
            $GitDir = Get-GitDir -Path $Path

            # check if the .git directory exists
            if (Test-Path -Path $GitDir -PathType Container) {
                # display the .git directory and the .git file
                Write-Host "$GitDir`t$Path/.git"

                # move the .git directory to the submodule path
                Move-Item -Path $GitDir -Destination "$Path/.git" -Force -Backup

                # unset the core.worktree config for the submodule
                Unset-CoreWorktree -Path $Path

                # remove the backup file if any
                Remove-Item -Path "$Path/.git~" -Force -ErrorAction SilentlyContinue

                # hide the .git directory on Windows
                Hide-GitDir -Path $Path
                }
            }
            else {
                # throw an error if the .git file is not present
                throw "Could not find $Path"
            }
        }
    }

    end {

    }
}
