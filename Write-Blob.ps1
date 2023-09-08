function Write-Blob {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )
    try {
        $file_hash = Git hash-object -w $Path
        Write-Output $file_hash
    }
    catch {
        Write-Error "Failed to write file as blob object: $_"
    }
}
