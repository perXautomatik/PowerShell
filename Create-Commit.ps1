function Create-Commit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match '^[0-9a-f]{40}$'})]
        [string]$TreeHash,

        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string]$CommitFile
    )
    try {
        $commit_hash = Git commit-tree $TreeHash
        Write-Output $commit_hash
    }
    catch {
        Write-Error "Failed to create commit object from tree object and commit file: $_"
    }
}
