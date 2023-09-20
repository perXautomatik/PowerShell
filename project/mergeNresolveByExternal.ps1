function mergeNresolveByExternal()
{
<#
    #----------------------------------------------------------
    powershell script that takes two branches, and a file as argument,

    checking out a new third branch,

    merge into third branch branch 1 and branch 2

    resolve this merge automatically by union
    commit
    then replace the files in the third branches content by the provided file from argument,
    commit with ammend.
#>
    # Get the arguments
    param (
      [string]$branch1,
      [string]$branch2,
      [string]$file
    )
    
    # Check if the arguments are valid
    if (-not $branch1 -or -not $branch2 -or -not $file) {
      Write-Error "Please provide two branches and a file as arguments"
      exit 1
    }
    
    if (-not (Test-Path $file)) {
      Write-Error "The file $file does not exist"
      exit 2
    }
    
    # Create a new branch from the current one
    git checkout -b merged-branch
    
    # Merge the two branches into the new branch using union merge strategy
    git merge -s recursive -X union $branch1 $branch2
    
    # Replace the content of the new branch with the file content
    Copy-Item $file -Destination . -Force
    
    # Amend the last commit with the new content
    git commit --amend --all --no-edit
}
