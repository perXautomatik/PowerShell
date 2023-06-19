<#
.SYNOPSIS
Split a folder from a parent repository into a new repository using git subtree.

.DESCRIPTION
This script takes three parameters: the path to the new repository, the path to the parent repository, and the folder name of the node to split. It then performs the following steps:

- Change directory to the new repository and add a remote origin for the node.
- Change directory to the parent repository and use the subtree split command to put the node folder in a separate branch.
- Push the contents of the split branch to the new repository using the file path.
- Remove the node folder from the parent repository and add it back as a subtree from the new repository.

.PARAMETER NewRepoPath
The path to the new repository where the node folder will be split into.

.PARAMETER ParentRepoPath
The path to the parent repository where the node folder resides.

.PARAMETER NodeFolderName
The folder name of the node to split into a new repository.

.EXAMPLE
PS C:\> Split-Folder -NewRepoPath "C:\Users\crbk01\Desktop\lib-repo" -ParentRepoPath "C:\Users\crbk01\Desktop\parent-repo" -NodeFolderName "lib"

This example splits the "lib" folder from the "C:\Users\crbk01\Desktop\parent-repo" into a new repository at "C:\Users\crbk01\Desktop\lib-repo".
#>

function Split-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$NewRepoPath,
        [Parameter(Mandatory=$true)]
        [string]$ParentRepoPath,
        [Parameter(Mandatory=$true)]
        [string]$NodeFolderName
    )

    # Change directory to the new repository and add a remote origin for the node
    cd $NewRepoPath
    $node = Read-Host -Prompt "Node Origin Path/url"
    git remote add node $node

    # Change directory to the parent repository and use the subtree split command to put the node folder in a separate branch
    cd $ParentRepoPath
    git subtree split --prefix=$NodeFolderName -b split

    # Push the contents of the split branch to the new repository using the file path
    git push $NewRepoPath split:master

    # Remove the node folder from the parent repository and add it back as a subtree from the new repository
    git remote add $NodeFolderName <url_to_lib_remote>
    git rm -r $NodeFolderName
    git add -A
    git commit -am "removing $NodeFolderName folder"
    git subtree add --prefix=$NodeFolderName $NodeFolderName master
}
