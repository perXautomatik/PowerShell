


#------------------------------- Credit to : apfelchips -------------------------------

    # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
    if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
    function Install-PowerShellGet { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command Install-PackageProvider -Name NuGet -Force; Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb "RunAs"}
    }

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

function import-customModules {

        #$script:MyInvocation.MyCommand.Path
        $moduleDir = ($profile | split-path -Parent ) | join-path -ChildPath 'modules\personal' | get-childitem -dir
        $moduleDir | % {import-module -name $_ ; echo "custom module $_ loaded"}
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


function Tryinstall-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'    
    $errorPath = join-path -Path (split-path $profile -Parent) -ChildPath "$name.error.install.log"
    
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
    Tryinstall-Module 'EZOut'  #  help take the pain out of writing format and types XML
    Tryinstall-Module 'PSReadLine' -AllowPrerelease
    Tryinstall-Module 'posh-git' 
    Tryinstall-Module 'PSFzf' 
    Tryinstall-Module 'PSEverything'

    Tryinstall-Module 'PSProfiler'  # --> Measure-Script

    # serialization tools: eg. ConvertTo-HashString / ConvertTo-HashTable https://github.com/torgro/HashData
    Tryinstall-Module 'hashdata' 

    # useful Tools eg. ConvertTo-FlatObject, Join-Object... https://github.com/RamblingCookieMonster/PowerShell
    Tryinstall-Module 'WFTools' 

    # https://old.reddit.com/r/AZURE/comments/fh0ycv/azuread_vs_azurerm_vs_az/
    # https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell
    Tryinstall-Module 'AzureAD' 

    Tryinstall-Module 'Pscx' 
    Tryinstall-Module 'SqlServer' 

    if ( $IsWindows ){
        # Windows Update CLI tool http://woshub.com/pswindowsupdate-module/#h2_2
        # Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        # native alternative: WindowsUpdateProvider\Install-WUUpdates >= Windows Server 2019
        Tryinstall-Module 'PSWindowsUpdate' 
    }
}

Import-Module -Name (join-path -Path (split-path $profile -Parent) -ChildPath "sqlite.ps1")

function Import-MyModules {

    if (!( ""-eq "${env:ChocolateyInstall}"  ))  {     
    TryImport-Module "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1" 
    }

    # does not load but test if avialable to speed up load time
    # ForEach-Object { TryImport-Module -name $_ } #-parralel for ps 7 does not work currently
    $modules = @( 'PowerShellGet', 'PSProfiler', 'hashdata','WFTools','AzureAD','SqlServer','PSWindowsUpdate','echoargs','pscx','EZOut','PSEverything' ) 
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
    
    # 设置 PowerShell 主题
   # 引入 ps-read-line # useful history related actions      
   # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
   if ( ($host.Name -eq 'ConsoleHost') -and (Test-ModuleExists 'PSReadLine' )) {
 	    if(!(TryImport-Module PSReadLine)) #null if fail to load
        {
            set-PSReadlineOption -HistorySavePath $global:historyPath 
            echo "historyPath: $historyPath"

            #-------------------------------  Set Hot-keys BEGIN  -------------------------------
        
            # Set-PSReadLineOption -EditMode Emac
        
            # 每次回溯输入历史，光标定位于输入内容末尾
            Set-PSReadLineOption -HistorySearchCursorMovesToEnd

            # 设置 Tab 为菜单补全和 Intellisense
            
            Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
                Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete       
            # 设置 Ctrl+d 为退出 PowerShell
            Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

            # 设置 Ctrl+z 为撤销
            Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

            # 设置向上键为后向搜索历史记录 # Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
            Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
            Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

            #-------------------------------  Set Hot-keys END    -------------------------------

            if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
                # 设置预测文本来源为历史记录
                Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
            }

        }
	    if ( $null -ne $(Get-Module PSFzf)  ) {
	        #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	        #$FZF_COMPLETION_TRIGGER='...'
	        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
	    }
    }


}



Import-MyModules
import-customModules 
; echo "modules imported"