function test {

    param(
        [string]$source,
        [string]$regex,
        [string]$new,
        [switch]$whatif
    )

    function Initialize-GitRepository {
        param([string]$path)
        # Initialize a new git repository
        Set-Location $path
        git init
        git checkout -b "new"
    }

    function Mirror-GitRepository {
        param([string]$source, [string]$destination)
        # Perform a mirror push from source to destination
        cd $source
        git push --mirror $destination
    }

    function Filter-GitRefs {
        param([string]$repositoryPath, [string]$regex, [switch]$inverse)
        # Filter refs based on regex and delete them
        Set-Location $repositoryPath
        $refs = git show-ref  
        
        if ($inverse) {
            $toUpdate = $refs | ?{$_ -notmatch $regex }
        } else {
            $toUpdate = $refs | ?{!($_ -notmatch $regex)}
        }
            return $toUpdate
    }

    function Delete-Refs {
        param (
            $path,
            [array]$refs
        )
        cd $path;

        foreach ($ref in $refs) {
            git update-ref -d ($ref -split ' ')[1].trim()
        }
        
    }

    # Verify if $source is a git repository
    if (-not (Test-Path "$source/.git")) {
        Write-Error "Source is not a valid git repository."
        return
    }

    # Verify if $new is empty
    if ((Get-ChildItem $new).Count -ne 0) {
        Write-Error "New path is not empty."
        return
    }

    # Initialize the empty path as a new git repository
    Initialize-GitRepository -path $new

    # Perform a mirror push from $source to $new
    Mirror-GitRepository -source $source -destination $new

    # Delete refs from $source that match the provided regex
    $keep = Filter-GitRefs -repositoryPath $source -regex $regex

    # Delete the other refs in the $new repository
    $toMove = Filter-GitRefs -repositoryPath $new -regex $regex -inverse

    # If -whatif switch is provided, show what would happen without actually performing the operations
    if ($whatif) {
        echo "keep" ;
        $keep;
        echo "toMove" ;
         $toMove;
    }
    else {
        Delete-Refs -path $source -refs $toMove
        Delete-Refs -path $new -refs  $keep
    }

}

test -source 'C:\ProgramData\Scoop\buckets\nirsoft' -regex 'revert' -new 'C:\ProgramData\Scoop\xapps'