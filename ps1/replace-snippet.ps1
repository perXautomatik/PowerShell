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
        if (-not (Test-Path -Path $Path)) {
            Write-Error "The path '$Path' does not exist."
            return
        }

        if ([string]::IsNullOrWhiteSpace($Replace)) {
            Write-Error "The -Replace parameter cannot be empty or null."
            return
        }

        # If -With is not specified or is null/empty, set it to an empty string
        if ([string]::IsNullOrWhiteSpace($With)) {
            $With = ""
        }

        # Perform the string replacement
        $NewPath = $Path -replace [regex]::Escape($Replace), $With

        # Output the new path
        Write-Output $NewPath
    }
}
