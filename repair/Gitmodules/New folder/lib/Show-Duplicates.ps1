function Show-Duplicates
{    

# This function displays the indexed groups of duplicate hashes in a clear format 
    [cmdletbinding()]
    param(                 
        [parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] 
        [object[]] $input
    )

     Clear-Host
     Write-Host "================ k for keep all ================"
                 

    # Add an index property to each group using Add-Index function 
    $indexed = ( $input |  %{$_.group} | Add-Index )
            
    # Display the index and relative path of each group and store the output in a variable 
    $indexed | Tee-Object -variable re |  
    % {
        $index = $_.index
        $relativePath = $_.relativePath 
        Write-Host "$index $relativePath"
    }

    # Return the output variable 
    $re
}
