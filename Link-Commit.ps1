function Link-Commit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match '^[0-9a-f]{40}$'})]
        [string]$CommitSHA
    )
    try {
        # Link the commit SHA on top of the current head
        Git cherry-pick -X theirs $CommitSHA
    }
    catch {
        Write-Error "Failed to link commit SHA on top of the current head: $_"
    }
}
