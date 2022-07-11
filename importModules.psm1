$profileFolder  = $home+'\Documents\Powershell\'
$a = get-content "$profileFolder.\modulesToImport.txt" | select-string -Pattern '^[^#]{1,}' ; 
$modules = @($a.Matches.value | %{$_.trim().toLower()} | select -Unique)

#------------------------------- Credit to : apfelchips -------------------------------

    # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
    if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
    function Install-PowerShellGet { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command Install-PackageProvider -Name NuGet -Force; Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb "RunAs"}
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

function TryImport-Module {
    param (
[Parameter(Mandatory=$true,Position=0)] [String] $nameX
)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    $vn = "$nameX.error.load.log"
    $errorPath = join-path -Path (split-path $profile -Parent) -ChildPath $vn

    try { 
        Import-Module $nameX 
        ; $messageX = "i $nameX"
    }
    catch { $messageX = "er.loading $nameX" ;
            "xxxxxxxxxx $nameX xxxxxxxxxxxxx $error" > $errorPath ; 
    }
    finally { 
            $ErrorActionPreference=$oldErrorActionPreference;
            $error = $null 
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
    $modules | %{ Invoke-Command "Tryinstall-Module $_"}
}

Import-Module -Name (join-path -Path $profileFolder -ChildPath "sqlite.psm1")

function Import-MyModules {

    if (!( ""-eq "${env:ChocolateyInstall}"  ))  {     
    TryImport-Module "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1" 
    }

    # does not load but test if avialable to speed up load time # ForEach-Object { TryImport-Module -name $_ } #-parralel for ps 7 does not work currently
    
    $modules | ForEach-Object { try{ if(!(Test-ModuleExists $_)) {TryImport-Module $_} } catch {"test failed $_"} } # || 

	# 引入 posh-git
	if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name posh-git)) )
     { TryImport-Module posh-git}   

	# 引入 oh-my-posh
    TryImport-Module oh-my-posh
	if ( (Test-ModuleExists 'oh-my-posh' )) {    
        Set-PoshPrompt ys
        Set-PoshPrompt paradox 
    }
    
    
    if ( $null -ne $(Get-Module PSFzf)  ) {
        #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        #$FZF_COMPLETION_TRIGGER='...'
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}
