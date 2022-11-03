$errorus = 'D:\Project Shelf\PowerShellProjectFolder\scripts\Modules\Personal\migration\Export-Inst-Choco\.git'

$asFile = ([System.IO.FileInfo]$errorus)
$targetFolder = ($asFile | select Directory).Directory

$name = $targetFolder.Name

#'D:\Project Shelf\PowerShellProjectFolder\scripts\Modules\Personal\migration\'
$path = $targetFolder.Parent.FullName



function git-root {
    $gitrootdir = (git rev-parse --show-toplevel)
    if ($gitrootdir) {
	Set-Location $gitrootdir
    }
}


#\Export-Inst-Choco\

Push-Location
cd $errorus

$ref = (git remote get-url origin)


cd $path
Git-root # (outside of ref)

$relative = ((Resolve-Path -Path $targetFolder.FullName -Relative) -replace([regex]::Escape('\'),'/')).Substring(2)

$relative



Git submodule add $ref $relative
git commit -m "as submodule $relative"

Git submodule absorbgitdirs $relative