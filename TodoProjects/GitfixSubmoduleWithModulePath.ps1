[CmdletBinding()]
param (

    [Parameter(Mandatory=$true,
                HelpMessage=".git")] 
    [string]$errorus,

    [Parameter(Mandatory=$true,
                HelpMessage="subModuleDirInsideGit")] 
    [int]$toReplaceWith
)

 #can be done with everything and menu

function git-root {
    $gitrootdir = (git rev-parse --show-toplevel)
    if ($gitrootdir) {
	Set-Location $gitrootdir
    }
}

#---- move

#([System.IO.FileInfo]$errorus) | get-member
$asFile = ([System.IO.FileInfo]$errorus)

$targetFolder = ($asFile | select Directory).Directory
$target = $targetFolder | Join-Path -ChildPath 'x.git'
$asFile.MoveTo($target)

$asFile = ([System.IO.FileInfo]$toReplaceWith)
$target = $targetFolder | Join-Path -ChildPath '.git'
$asFile.MoveTo($target)


#--- remove worktree line

$path = $errorus + '\config'
    # putting get-content in paranteses makes it run as a separate thread and doesn't lock the file further down the pipe
    (Get-Content -Path $path | ? { ! ($_ -match 'worktree') }) | Set-Content -Path $path

# --- forget about files in path

Push-Location
    cd $targetFolder
    $ref = (git remote get-url origin)
    $ref


$name = $targetFolder.Name
$path = $targetFolder.Parent.FullName

    cd $path

        git rm -r --cached $name 
        git commit -m "forgot about $name"

# --- Read submodule

cd $path
Git-root # (outside of ref)

$relative = ((Resolve-Path -Path $targetFolder.FullName -Relative) -replace([regex]::Escape('\'),'/')).Substring(2)

Git submodule add $ref $relative
git commit -m "as submodule $relative"

Git submodule absorbgitdirs $relative

Pop-Location