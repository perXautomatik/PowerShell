function Choose-Duplicates
{

# This function allows the user to choose which duplicate hashes to keep or delete  
 [cmdletbinding()]
    param(                 
        [parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] 
        [object[]] $input
    )
       # Split the input array into smaller chunks using Split-Array function 
       $options = $input | %{$_.index} | Split-Array 
       # Prompt the user to choose from the alternatives and store the input in a variable 
       $selection = Read-Host "choose from the alternativs " ($input | measure-object).count
       # If the user chooses to keep all, return nothing 
       if ($selection -eq 'k' ) {
            return
        } 
        else {
            # Otherwise, filter out the objects that have the same index as the selection and store them in a variable 
            $q = $input | ?{ $_.index -ne $selection }
        } 
    
       # Return the filtered variable 
       $q
}
