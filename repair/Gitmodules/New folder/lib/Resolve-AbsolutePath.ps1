function Resolve-AbsolutePath
{

# A function that resolves the absolute path of a file from its relative path
    param(
        [Parameter(Mandatory)] [string]$RelativePath
    )
    
    # Escape the backslash character for regex matching
    $backslash = [regex]::escape('\')
    
    # Define a regex pattern for matching octal escape sequences in the relative path
    $octalPattern = $backslash+'\d{3}'+$backslash+'\d{3}'
    
    # Trim the double quotes from the relative path
    $relativePath =  $RelativePath.Trim('"')

    # Try to resolve the relative path to an absolute path
    $absolutePath = Resolve-Path $relativePath -ErrorAction SilentlyContinue  
    
    # If the absolute path is not found and the relative path contains octal escape sequences, try to resolve it with wildcard matching
    if(!$absolutePath -and $relativePath -match ($octalPattern))
    { 
       $absolutePath = Resolve-Path  (($relativePath -split($octalPattern) ) -join('*')) 
    }
    # Return the absolute path or null if not found
    return $absolutePath     
}
