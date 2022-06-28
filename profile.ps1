# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue
# define these environment variables if not set already and also provide them as PSVariables

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }

if ( -not $IsWindows ) { function Test-IsAdmin { if ( (id -u) -eq 0 ) { return $true } return $false } }
#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}    

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if ( $args.Count -eq 0 ) {
        Get-Childitem env:
    } elseif( $args.Count -eq 1 ) {
        Start-Process (Get-Command $args[0]).Source
    } else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}

function cf {
    if ( $null -ne $(Get-Module PSFzf) ) {
        Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
    } else {
        Write-Error "please install PSFzf"
    }
}

#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)

set-alias accelerators       [accelerators]::Get
set-alias edprofile          start-Notepad-Profile
set-alias exp-pro            open-ProfileFolder
set-alias kidStream          get-childitem                          |       out-string -stream
set-alias history            (Get-PSReadlineOption).HistorySavePath 
set-alias parameters         get-parameters
set-alias start-su           start-powershellAsAdmin
set-alias version            $PSVersionTable                        #       bash-like
Set-Alias cat                Get-Content                            -Option AllScope
Set-Alias cd                 Set-Location                           -Option AllScope
Set-Alias clear              Clear-Host                             -Option AllScope
Set-Alias cp                 Copy-Item                              -Option AllScope
Set-Alias history            Get-History                            -Option AllScope
Set-Alias kill               Stop-Process                           -Option AllScope
Set-Alias lp                 Out-Printer                            -Option AllScope
Set-Alias mv                 Move-Item                              -Option AllScope
Set-Alias ps                 Get-Process                            -Option AllScope
Set-Alias pwd                Get-Location                           -Option AllScope
Set-Alias which              Get-Command                            -Option AllScope   
Set-Alias open               Invoke-Item                            -Option AllScope
Set-Alias basename           Split-Path                             -Option AllScope
Set-Alias realpath           Resolve-Path                           -Option AllScope   #       cmd-like Set-Alias rm      Remove-Item -Option   AllScope
Set-Alias rmdir              Remove-Item                            -Option AllScope
Set-Alias echo               Write-Output                           -Option AllScope
Set-Alias cls                Clear-Host                             -Option AllScope   
Set-Alias chdir              Set-Location                           -Option AllScope
Set-Alias copy               Copy-Item                              -Option AllScope
Set-Alias del                Remove-Item                            -Option AllScope
Set-Alias dir                Get-Childitem                          -Option AllScope
Set-Alias erase              Remove-Item                            -Option AllScope
Set-Alias move               Move-Item                              -Option AllScope
Set-Alias rd                 Remove-Item                            -Option AllScope
Set-Alias ren                Rename-Item                            -Option AllScope
Set-Alias set                Set-Variable                           -Option AllScope
Set-Alias type               Get-Content                            -Option AllScope
Set-Alias env                Get-Environment                        -Option AllScope   #       custom   aliases
Set-Alias flush-dns          Clear-DnsClientCache                   -Option AllScope
Set-Alias touch              Set-FileTime                           -Option AllScope   
set-alias lsx                get-Childnames                         -Option AllScope
set-alias filesinfolasstream read-childrenAsStream                  -Option AllScope
set-alias bcompare           start-bc                               -Option AllScope   
set-alias GitAdEPathAsSNB    invoke-GitSubmoduleAdd                 -Option AllScope
set-alias GitUp              invoke-GitLazy                         -Option AllScope
set-alias gitSilently        invoke-GitLazySilently                 -Option AllScope
set-alias gitSingleRemote    invoke-gitFetchOrig                    -Option AllScope
set-alias executeThis        invoke-FuzzyWithEverything             -Option AllScope   
set-alias filesinfolasstream read-pathsAsStream                     -Option AllScope
set-alias everything         invoke-Everything                      -Option AllScope
set-alias make               invoke-Nmake                           -Option AllScope
set-alias MyAliases          read-aliases                           -Option AllScope
set-alias OpenAsADmin        invoke-powershellAsAdmin               -Option AllScope
set-alias home               open-here                              -Option AllScope
set-alias pastDo             find-historyInvoke                     -Option AllScope
set-alias pastDoEdit         find-historyAppendClipboard            -Option AllScope
set-alias HistoryPath        (Get-PSReadlineOption).HistorySavePath -Option AllScope
set-alias reboot             exit-Nrenter                           -Option AllScope
set-alias browserflags       start-BrowserFlags                     -Option AllScope
set-alias df                 get-volume                             -Option AllScope
set-alias printpaths         read-EnvPaths                          -Option AllScope
set-alias reload             initialize-profile                     -Option AllScope
set-alias uptime             read-uptime                            -Option AllScope   
set-alias getnic             get-mac                                -Option AllScope   #       1.       获取所有      Network Interface   set-alias ll       Get-ChildItem -Option AllScope
set-alias getip              Get-IPv4Routes                         -Option AllScope
set-alias getip6             Get-IPv6Routes                         -Option AllScope
set-alias os-update          Update-Packages                        -Option AllScope
set-alias remote             invoke-gitRemote                       -Option AllScope   
set-alias gitsplit           subtree-split-rm-commit                -Option AllScope
set-alias isFolder           get-isFolder                           -Option AllScope
set-alias start-powershellAsAdmin invoke-powershellAsAdmin          -Option AllScope
set-alias psVersion          $PSVersionTable.PSVersion.Major        -Option AllScope 
#-------------------------------    Set alias END     -------------------------------

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"
