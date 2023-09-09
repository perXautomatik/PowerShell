Function Git-InitializeSubmodules {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
       Param(
        # File to Create
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string]
        $RepoPath
    )
    begin{            
        # Validate the parameter
        # Set the execution policy to bypass for the current process
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

    	Write-Verbose "[Add Git Submodule from .gitmodules]"    
    }
    process{    
        # Filter out the custom objects that have a path property and loop through them
        Get-SubmoduleDeep | Where-Object {($_.path)} | 
         %{ 
            $url = $_.url
            $path = $_.path
            try {
                if( New-Item -ItemType dir -Name $path -WhatIf -ErrorAction SilentlyContinue)
                {
                    if($PSCmdlet.ShouldProcess($path,"clone $url -->")){                                                   
                    
                    }
                    else
                    {
                        invoke-git "submodule add $url $path"
                    }
                }
                else
                {
                    if($PSCmdlet.ShouldProcess($path,"folder already exsists, will trye to clone $url --> "))
                    {   
                        
                    }
                    else
                    {
                        Invoke-Git "submodule add -f $url $path"                        
                    }
                }
                    # Try to add a git submodule using the path and url properties
        
        }
        catch {
            Write-Error "Could not add git submodule: $_"
        }
        }
    }
}
