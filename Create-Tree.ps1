function Create-Tree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match '^\d{6} blob [0-9a-f]{40} \w+$'})]
        [string]$DummyContent
    )
    try {
        # Write the dummy file content to a temporary file
        $temp_file = New-TemporaryFile
        Set-Content -Path $temp_file -Value $DummyContent

        # Create a tree object from the temporary file and get its hash
        $tree_hash = Git mktree $temp_file 

        # Remove the temporary file
        Remove-Item -Path $temp_file

        # Return the tree hash
        Write-Output $tree_hash
    }
    catch {
        Write-Error "Failed to create tree object from dummy file content: $_"
    }
}
