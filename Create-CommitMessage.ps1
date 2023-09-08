function Create-CommitMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match '^[0-9a-f]{40}$'})]
        [string]$TreeHash,

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match '^.+ <.+@.+>$'})]
        [string]$Author = "John Doe <johndoe@example.com>",

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match '^.+ <.+@.+>$'})]
        [string]$Committer = "John Doe <johndoe@example.com>",

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match '^\d+ \+\d{4}$'})]
        [string]$Date = (Get-Date -UFormat "%s %z"),

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -ne ''})]
        [string]$Message = "Add file x"
    )
    try {
        # Create a temporary file
        $temp_file = New-TemporaryFile

        # Write the commit message to the temporary file
        echo "tree $TreeHash`nauthor $Author`ncommitter $Committer`ndate $Date`n`n$Message" > $temp_file

        # Return the path to the temporary file
        Write-Output $temp_file
    }
    catch {
        Write-Error "Failed to create commit message file: $_"
    }
}
