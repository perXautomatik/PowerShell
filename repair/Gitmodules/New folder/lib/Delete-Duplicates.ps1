function Delete-Duplicates
{  

# This function deletes the chosen duplicate hashes using git rm command 
 [cmdletbinding()]
    param(                 
        [parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] 
        [object[]] $input
    )
    if($input -ne $null)
    {

       # Split the input array into smaller chunks using Split-Array function 
       $toDelete = $input | %{$_.relativepath} | Split-Array 
       
       # For each chunk, use git rm to delete the files 
       $toDelete | % { git rm $_ } 

       # Wait for 2 seconds before proceeding 
       sleep 2
    }
}
