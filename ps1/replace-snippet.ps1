function Replace {
    [CmdletBinding()]
    param (        
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Replace,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$With,
        
        [alias("in")][Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Path
    )

    process {
        try {
            # Check if the file exists
            if (-not (Test-Path -Path $Path -PathType Leaf)) {
                throw "The file '$Path' does not exist."
            }

            # Check if the file is writable
            if (-not (Get-Item $Path).IsReadOnly) {
                # Read the content of the file
                $content = Get-Content -Path $Path -Raw

                # If -With is not specified or is null/empty, set it to an empty string
                if ([string]::IsNullOrWhiteSpace($With)) {
                    $With = ""
                }

                # Perform the string replacement
                $newContent = $content -replace [regex]::Escape($Replace), $With

                # Write the new content back to the file
                Set-Content -Path $Path -Value $newContent
            }
            else {
                throw "The file '$Path' is write-protected."
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}
