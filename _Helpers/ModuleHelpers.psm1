	function Test-ModuleExists {
	        #retuns module version if exsists else false
	        Param ($name)
	        $x = Get-Module -ListAvailable -Name $name    
	        return($null -ne ($x))
	}    
	
	#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
	function Test-CommandExists {
	    Param ($command)
	    $oldErrorActionPreference = $ErrorActionPreference
	    $ErrorActionPreference = 'stop'
	    try { Get-Command $command; return $true }
	    catch {return $false}
	    finally { $ErrorActionPreference=$oldErrorActionPreference }
	}

	function Get-ModulesAvailable {
	    if ( $args.Count -eq 0 ) {
		Get-Module -ListAvailable
	    } else {
		Get-Module -ListAvailable $args
	    }
	}

	function Get-ModulesLoaded {
	    if ( $args.Count -eq 0 ) {
		Get-Module -All
	    } else {
		Get-Module -All $args
	    }
	}

function Tryinstall-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'    
    $errorPath = join-path -Path $profileFolder -ChildPath "$name.error.install.log"
    
    try {
    if ( $args.Count -eq 1 ) {
        Invoke-Expression "PowerShellGet\Install-Module -Name $args[1] -Scope CurrentUser -Force -AllowClobber"    
    }
    elseif ( $args.Count -eq 2 ) {    
        Invoke-Expression "PowerShellGet\Install-Module -Name $args[1] -Scope CurrentUser -Force -AllowClobber $args[2]"    
    }
    elseif ($args.count -ne 0) 
    {
        Invoke-Expression "PowerShellGet\Install-Module $args"    
    }

    echo "i $name"
    }

    catch { "er.installing $name" ; $error > $errorPath }
    finally { $ErrorActionPreference=$oldErrorActionPreference }

}             

function TryImport-Module {
    param (
[Parameter(Mandatory=$true,Position=0)] [ValidateNotNullorEmpty()] [String] $nameX
)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    $vn = "$nameX.error.load.log"
    $errorPath = join-path -Path (split-path $profile -Parent) -ChildPath $vn

    try { 
        Import-Module $nameX 
        ; $messageX = "i $nameX"    
        return $messageX        
    }
    catch { $messageX = "er.loading $nameX" ;
            "xxxxxxxxxx $nameX xxxxxxxxxxxxx $error" > $errorPath ; 
    }
    finally { 
            $ErrorActionPreference=$oldErrorActionPreference;
            $error.clear()        
     }   
     return $messageX 
}
