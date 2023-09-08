function Create-Branch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -notmatch '\s'})]
        [string]$BranchName,

        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match '^[0-9a-f]{40}$'})]
        [string]$CommitHash
    )
    try {
        Git update-ref refs/heads/$BranchName $CommitHash
    }
    catch {
        Write-Error "Failed to create new branch: $_"
    }
}
