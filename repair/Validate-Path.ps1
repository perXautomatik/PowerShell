function Validate-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    if (-not (Test-Path $Path)) {
        Write-Error "Invalid path: $Path"
        exit 1
    }
}
