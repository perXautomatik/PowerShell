
$profileFolder  = $home+'\Documents\Powershell\'

if(test-path $profileFolder)
{                          
$g = "$profileFolder\modulesToImport.txt"

if(test-path $g)
{                          
	$a = get-content $g | select-string -Pattern '^[^#]{1,}' ; $modules = @($a.Matches.value | %{ if($_ -notmatch '\s-') { $_ -replace "'",''} else {$_} } |  %{ $_.trim().toLower()} |  select -Unique)
}
}

#------------------------------- Credit to : apfelchips -------------------------------

# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
    function Install-PowerShellGet { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command Install-PackageProvider -Name NuGet -Force; Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb "RunAs"}
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

function Test-ModuleExists {
        #retuns module version if exsists else false
        Param ($name)
        $x = Get-Module -ListAvailable -Name $name    
        return($null -ne ($x))
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

function Install-MyModules {         
    $modules | %{ Invoke-Expression "Tryinstall-Module $_"}
}

function Import-MyModules {
    
    $modules | ForEach-Object { try{ if(!( Invoke-Expression "Test-ModuleExists $_" )) { Invoke-Expression "TryImport-Module $_" } } catch {"test failed $_"} } # ||      # does not load but test if avialable to speed up load time # ForEach-Object { TryImport-Module -name $_ } #-parralel for ps 7 does not work currently
 	
	#if ( (Test-ModuleExists 'oh-my-posh' )) { Set-PoshPrompt ys; Set-PoshPrompt paradox}
}

# Imports
function Import-Module-Verified ($m) {

    if (!( Test-ModuleExists $m )) {
        if ( Test-ModuleExists $m ) {
            TryImport-Module $m -Verbose
        }
        else {
            if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
                Tryinstall-Module -Name $m -Force -Verbose -Scope CurrentUser
                TryImport-Module $m -Verbose
            }
        }
    }
}
