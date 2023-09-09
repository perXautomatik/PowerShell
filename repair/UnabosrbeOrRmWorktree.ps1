function UnabosrbeOrRmWorktree {

# A function to repair a fatal git status
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
    # Print a message indicating fatal status
    write-verbos "fatal status for $Path, atempting repair"

    cd $Path
    UnabosrbeOrRmWorktree -folder $Modules
    
}
