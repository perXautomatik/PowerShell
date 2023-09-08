function Validate-Path {
# A function to validate a path argument
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    if (-not (Test-Path $Path)) {
        Write-Error "Invalid $Name path: $Path"
        exit 1
    }
}
