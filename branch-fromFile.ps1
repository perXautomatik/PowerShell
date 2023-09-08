function branch-fromFile ($pathx)
{
    # Write the file at path x as a blob object and get its hash
    $file_hash = Write-Blob -Path $pathx
    $fileName = (resolve-path $pathx).name

    # Create a tree object from the tree description file and get its hash
    $tree_hash = Create-Tree -DummyContent "100644 blob $file_hash $fileName"

    # Create a commit object from the tree object and the commit message file and get its hash
    $commit_hash = Create-Commit -TreeHash $tree_hash -CommitFile (Create-CommitMessage -TreeHash $tree_hash )

    # Create a new branch named new_branch that points to the commit object
    Create-Branch -BranchName new_branch -CommitHash $commit_hash
}
