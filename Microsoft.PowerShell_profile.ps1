<#
    First, PowerShell will load the profile.ps1 file, which is the “Current User, All Hosts” profile.
    This profile applies to all PowerShell hosts for the current user, such as the console host or the ISE host. 
    You can use this file to define settings and commands that you want to use in any PowerShell session, regardless of the host.

    Next, PowerShell will load the Microsoft.PowerShellISE_profile.ps1 file, which is the “Current User, Current Host” 
    profile for the ISE host. This profile applies only to the PowerShell ISE host for the current user. 
    You can use this file to define settings and commands that are specific to the ISE host, 
    such as customizing the ISE editor or adding ISE-specific functions.
#>

#ps setHistorySavePath
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = Join-Path -Path "$HOME" -ChildPath ".local/share" }; $XDG_DATA_HOME = $env:XDG_DATA_HOME
if (-not $env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = Join-Path -Path "$HOME" -ChildPath ".cache" }; $XDG_CACHE_HOME = $env:XDG_CACHE_HOME

if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:CHEATS_DIR) { $env:CHEATS_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "cheatsheets" }; $CHEATS_DIR = $env:CHEATS_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

if (-not $env:DEVEL_DIR) { $env:DEVEL_DIR = Join-Path -Path "$HOME" -ChildPath "devel" }; $DEVEL_DIR = $env:DEVEL_DIR
if (-not $env:PORTS_DIR) { $env:PORTS_DIR = Join-Path -Path "$HOME" -ChildPath "ports" }; $PORTS_DIR = $env:PORTS_DIR

# Load scripts from the following locations   
$profileFolder = (split-path $profile -Parent)



$fileToFind = '\snipps'
$workpath = join-path -Path $home -ChildPath 'Documents\WindowsPowerShell\$fileToFind' ;
$EnvPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
$env:Path += ";$EnvPath"


$fileToFind = 'ConsoleHost_history.txt'
$workpath =  "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\$fileToFind" ; 
set-PSReadlineOption -HistorySavePath (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )

#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path

$fileToFind = 'vscode-portable.exe'
$workpath =  "D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\$fileTofind"  ; 
[Environment]::SetEnvironmentVariable("code", (retrive-FromCache -SearchString $fileToFind -externalPath $workpath ))

#sqlite dll
$fileToFind = 'System.Data.SQLite.dll'
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\$fileTofind"  ; 
Add-Type -Path (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )



### local variables

$whatPulseDbQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"

$fileToFind = 'whatpulse.db'
$whatPulseDbPath = (retrive-FromCache -SearchString $fileToFind)

[Environment]::SetEnvironmentVariable("WHATPULSE_DB", $whatPulseDbPath)
if (-not $env:WHATPULSE_DB) { $env:WHATPULSE_DB = $whatPulseDbPath }; $WHATPULSE_DB = $env:WHATPULSE_DB

[Environment]::SetEnvironmentVariable("WHATPULSE_QUERY", $whatPulseDbQuery)
if (-not $env:WHATPULSE_QUERY) { $env:WHATPULSE_QUERY = $whatPulseDbQuery }; $WHATPULSE_QUERY = $env:WHATPULSE_QUERY

$fileToFind = 'DataGrip2021.1'
$workpath = "$home\appdata\Roaming\JetBrains\$fileTofind"  ; 
$datagripPath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
[Environment]::SetEnvironmentVariable("datagripPath", $datagripPath)


$fileToFind = 'Beyond Compare 4'
$workpath = "D:\PortableApps\2. fileOrganization\PortableApps\$fileTofind"  ; 
$bComparePath = (retrive-FromCache -SearchString $fileToFind -externalPath $workpath )
[Environment]::SetEnvironmentVariable("bComparePath", $bComparePath)

#-------------------------------    Functions END     -------------------------------

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"

echo "paths set"
echo "XDG_CONFIG_HOME $env:XDG_CONFIG_HOME"
echo "XDG_DATA_HOME $env:XDG_DATA_HOME"
echo "XDG_CACHE_HOME $env:XDG_CACHE_HOME"
echo "DESKTOP_DIR $env:DESKTOP_DIR"
echo "NOTES_DIR $env:NOTES_DIR"
echo "CHEATS_DIR $env:CHEATS_DIR"
echo "TODO_DIR $env:TODO_DIR"
echo "DEVEL_DIR $env:DEVEL_DIR"
echo "PORTS_DIR $env:PORTS_DIR"
echo "WHATPULSE_DB $env:WHATPULSE_DB"
echo "WHATPULSE_QUERY $env:WHATPULSE_QUERY"
echo "datagripPath $env:datagripPath"
echo "bComparePath $env:bComparePath"
echo "snipps $EnvPath"
$historyPath =  (get-PSReadlineOption).HistorySavePath;
echo "historyPath: $historyPath"
echo "VscodePath $env:code"
$isAdmin = ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }
# Alias File
# Computer : 5CG84229D5
# Date/Time : 28 June 2022 13:24:18
# Exported by : crbk01
#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)
if (test-path alias:\cd)              { remove-item -force alias:\cd }                 # We override with cd.ps1
if (test-path alias:\chdir)           { remove-item -force alias:\chdir }              # We override with an alias to cd.ps1

set-alias -Name:"accelerators" -Value:"[accelerators]::Get" -Description:"" -Option:"None"
set-alias -Name:"basename" -Value:"Split-Path" -Description:"" -Option:"AllScope"
set-alias -Name:"bcompare" -Value:"start-bc" -Description:"" -Option:"AllScope"
set-alias -Name:"browserflags" -Value:"start-BrowserFlags" -Description:"" -Option:"AllScope"
set-alias -Name:"cat" -Value:"Get-Content" -Description:"" -Option:"AllScope"
set-alias -Name:"cd" -Value:"Set-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"chdir" -Value:"Set-Location" -Description:"" -Option:"AllScope"
                Set-Alias history           	Get-History                           	-Option AllScope
                Set-Alias kill              	killx                          			-Option AllScope
                Set-Alias mv                	Move-Item                             	-Option AllScope
                Set-Alias pwd               	Get-Location                          	-Option AllScope
                Set-Alias rm                	Remove-Item                           	-Option AllScope
                Set-Alias echo              	Write-Output                          	-Option AllScope
set-alias -Name:"clear" -Value:"Clear-Host" -Description:"" -Option:"AllScope"
set-alias -Name:"cls" -Value:"Clear-Host" -Description:"" -Option:"AllScope"
set-alias -Name:"copy" -Value:"Copy-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"cp" -Value:"Copy-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"del" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"df" -Value:"get-volume" -Description:"" -Option:"AllScope"
set-alias -Name:"dir" -Value:"Get-Childitem" -Description:"" -Option:"AllScope"
set-alias -Name:"echo" -Value:"Write-Output" -Description:"" -Option:"AllScope"
set-alias -Name:"edprofile" -Value:"start-Notepad-Profile" -Description:"" -Option:"None"
set-alias -Name:"env" -Value:"Get-Environment" -Description:"      custom   aliases" -Option:"AllScope"
set-alias -Name:"erase" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
                Set-Alias type              	Get-Content                           	-Option AllScope
                Set-Alias sudo                  Elevate-Process           	            -Option AllScope
                set-alias pastDoEdit        	find-historyAppendClipboard           	-Option AllScope
                set-alias pastDo            	find-historyInvoke                    	-Option AllScope
set-alias everything         invoke-Everything                      -Option AllScope
set-alias -Name:"etsn" -Value:"Enter-PSSession" -Description:"" -Option:"None"
set-alias -Name:"exp-pro" -Value:"open-ProfileFolder" -Description:"" -Option:"None"
set-alias -Name:"exsn" -Value:"Exit-PSSession" -Description:"" -Option:"None"
set-alias executeThis        invoke-FuzzyWithEverything             -Option AllScope
set-alias exp-pro            open-ProfileFolder
set-alias -Name:"fhx" -Value:"Format-Hex" -Description:"" -Option:"None"
set-alias -Name:"filesinfolasstream" -Value:"read-pathsAsStream" -Description:"" -Option:"AllScope"
set-alias -Name:"flush-dns" -Value:"Clear-DnsClientCache" -Description:"" -Option:"AllScope"
set-alias -Name:"gcb" -Value:"Get-Clipboard" -Description:"" -Option:"None"
set-alias -Name:"getip" -Value:"Get-IPv4Routes" -Description:"" -Option:"AllScope"
set-alias -Name:"getip6" -Value:"Get-IPv6Routes" -Description:"" -Option:"AllScope"
set-alias getnic             get-mac                                -Option AllScope   #       1.       获取所有      Network Interface   set-alias ll       Get-ChildItem -Option AllScope
set-alias GitAdEPathAsSNB    invoke-GitSubmoduleAdd                 -Option AllScope
set-alias gitSilently        invoke-GitLazySilently                 -Option AllScope
set-alias gitSingleRemote    invoke-gitFetchOrig                    -Option AllScope
set-alias gitsplit           subtree-split-rm-commit                -Option AllScope
set-alias GitUp              invoke-GitLazy                         -Option AllScope
set-alias -Name:"getnic" -Value:"get-mac" -Description:"" -Option:"AllScope"
set-alias -Name:"gin" -Value:"Get-ComputerInfo" -Description:"" -Option:"None"
set-alias -Name:"gjb" -Value:"Get-Job" -Description:"" -Option:"None"
set-alias -Name:"gsn" -Value:"Get-PSSession" -Description:"" -Option:"None"
set-alias -Name:"gtz" -Value:"Get-TimeZone" -Description:"" -Option:"None"
set-alias -Name:"h" -Value:"Get-History" -Description:"" -Option:"None"
set-alias -Name:"history" -Value:"Get-History" -Description:"" -Option:"AllScope"
set-alias -Name:"HistoryPath" -Value:"(Get-PSReadlineOption).HistorySavePath" -Description:"" -Option:"AllScope"
set-alias -Name:"home" -Value:"open-here" -Description:"" -Option:"AllScope"
set-alias -Name:"icm" -Value:"Invoke-Command" -Description:"" -Option:"None"
set-alias -Name:"isFolder" -Value:"get-isFolder" -Description:"" -Option:"AllScope"
set-alias kidStream          get-childitem                          |       out-string -stream
set-alias -Name:"kill" -Value:"Stop-Process" -Description:"" -Option:"AllScope"
set-alias -Name:"lp" -Value:"Out-Printer" -Description:"" -Option:"AllScope"
set-alias -Name:"ls" -Value:"Get-ChildItem" -Description:"" -Option:"None"
set-alias -Name:"lsx" -Value:"get-Childnames" -Description:"" -Option:"AllScope"
set-alias -Name:"make" -Value:"invoke-Nmake" -Description:"" -Option:"AllScope"
set-alias -Name:"man" -Value:"help" -Description:"" -Option:"None"
set-alias -Name:"md" -Value:"mkdir" -Description:"" -Option:"AllScope"
set-alias -Name:"mount" -Value:"New-PSDrive" -Description:"" -Option:"None"
set-alias -Name:"move" -Value:"Move-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"mv" -Value:"Move-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"MyAliases" -Value:"read-aliases" -Description:"" -Option:"AllScope"
set-alias -Name:"nsn" -Value:"New-PSSession" -Description:"" -Option:"None"
set-alias -Name:"open" -Value:"Invoke-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"OpenAsADmin" -Value:"invoke-powershellAsAdmin" -Description:"" -Option:"AllScope"
set-alias -Name:"os-update" -Value:"Update-Packages" -Description:"" -Option:"AllScope"
set-alias -Name:"parameters" -Value:"get-parameters" -Description:"" -Option:"None"
set-alias -Name:"pastDo" -Value:"find-historyInvoke" -Description:"" -Option:"AllScope"
set-alias -Name:"pastDoEdit" -Value:"find-historyAppendClipboard" -Description:"" -Option:"AllScope"
set-alias -Name:"popd" -Value:"Pop-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"printpaths" -Value:"read-EnvPaths" -Description:"" -Option:"AllScope"
set-alias -Name:"ps" -Value:"Get-Process" -Description:"" -Option:"AllScope"
set-alias -Name:"psVersion" -Value:"$PSVersionTable.PSVersion.Major " -Description:"" -Option:"AllScope"
set-alias -Name:"pushd" -Value:"Push-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"pwd" -Value:"Get-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"r" -Value:"Invoke-History" -Description:"" -Option:"None"
set-alias -Name:"rcjb" -Value:"Receive-Job" -Description:"" -Option:"None"
set-alias -Name:"rd" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"realpath" -Value:"Resolve-Path" -Description:"cmd-like" -Option:"AllScope"
set-alias -Name:"reboot" -Value:"exit-Nrenter" -Description:"" -Option:"AllScope"
set-alias -Name:"refreshenv" -Value:"Update-SessionEnvironment" -Description:"" -Option:"None"
set-alias -Name:"reload" -Value:"initialize-profile" -Description:"" -Option:"AllScope"
set-alias remote             invoke-gitRemote                       -Option AllScope
set-alias -Name:"ren" -Value:"Rename-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"rjb" -Value:"Remove-Job" -Description:"" -Option:"None"
set-alias -Name:"rm" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"rmdir" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"rsn" -Value:"Remove-PSSession" -Description:"" -Option:"None"
set-alias -Name:"sajb" -Value:"Start-Job" -Description:"" -Option:"None"
set-alias -Name:"scb" -Value:"Set-Clipboard" -Description:"" -Option:"None"
set-alias -Name:"set" -Value:"Set-Variable" -Description:"" -Option:"AllScope"
set-alias -Name:"sls" -Value:"Select-String" -Description:"" -Option:"None"
set-alias -Name:"spjb" -Value:"Stop-Job" -Description:"" -Option:"None"
set-alias -Name:"start-powershellAsAdmin" -Value:"invoke-powershellAsAdmin" -Description:"" -Option:"AllScope"
set-alias -Name:"start-su" -Value:"start-powershellAsAdmin" -Description:"" -Option:"None"
set-alias -Name:"stz" -Value:"Set-TimeZone" -Description:"" -Option:"None"
set-alias -Name:"touch" -Value:"Set-FileTime" -Description:"" -Option:"AllScope"
set-alias -Name:"type" -Value:"Get-Content" -Description:"" -Option:"AllScope"
set-alias -Name:"uptime" -Value:"read-uptime" -Description:"" -Option:"AllScope"
set-alias -Name:"version" -Value:"System.Management.Automation.PSVersionHashTable" -Description:"bash-like" -Option:"None"
set-alias -Name:"which" -Value:"Get-Command" -Description:"" -Option:"AllScope"
set-alias -Name:"wjb" -Value:"Wait-Job" -Description:"" -Option:"None"
                set-alias MyAliases         	read-aliases                          	-Option AllScope                
                set-alias printpaths        	read-EnvPaths                         	-Option AllScope
                set-alias uptime            	read-uptime                           	-Option AllScope
                set-alias parameters        	get-parameters                        	-Option AllScope
                set-alias accelerators      	([accelerators]::Get)                 	-Option AllScope
                set-alias reboot            	exit-Nrenter                          	-Option AllScope
                set-alias reload            	initialize-profile                    	-Option AllScope
#-------------------------------    Set alias END     -------------------------------
$profileFolder = (split-path $profile -Parent)
Update-TypeData (join-path $profileFolder "My.Types.ps1xml")


# Sometimes home doesn't get properly set for pre-Vista LUA-style elevated admins
 if ($home -eq "") { remove-item -force variable:\home $home = (get-content env:\USERPROFILE) (get-psprovider 'FileSystem').Home = $home } set-content env:\HOME $home


#loadMessage
echo (Split-Path -leaf $MyInvocation.MyCommand.Definition)

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host ("Profile:   " + (Split-Path -leaf $MyInvocation.MyCommand.Definition))

Write-Host "This script was invoked by: "+$($MyInvocation.Line)


#------------------------------- Styling begin --------------------------------------	

if ( (($error.length | group).name -eq $null ) -and  (Test-IsInteractive)   ) { 
    Clear-Host # remove advertisements (preferably use -noLogo)
}
	# Keep the existing window title
#change selection to neongreen
#https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
$colors = @{
   "Selection" = "$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m"
}
#Set-PSReadLineOption -Colors $colors

# Style default PowerShell Console
$shell = $Host.UI.RawUI

$shell.WindowTitle= "PS"

$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "White"

# Load custom theme for Windows Terminal
#Set-Theme LazyAdmin

if ( $(Test-CommandExists 'get-title') )
{

	$windowTitle = (get-title).Trim()

	if ($windowTitle.StartsWith("Administrator:")) {
	    $windowTitle = $windowTitle.Substring(14).Trim()
	}
}
    $nextId = (get-history -count 1).Id + 1;
    # KevMar logging
    $LastCmd = Get-History -Count 1
    if ($LastCmd) {
        $lastId = $LastCmd.Id
        Add-Content -Value "# $($LastCmd.StartExecutionTime)" -Path $PSLogPath
        Add-Content -Value "$($LastCmd.CommandLine)" -Path $PSLogPath
        Add-Content -Value '' -Path $PSLogPath
        $howlongwasthat = $LastCmd.EndExecutionTime.Subtract($LastCmd.StartExecutionTime).TotalSeconds
    }
	$currentPath = (get-location).Path.replace($home, "~")
	$idx = $currentPath.IndexOf("::")
	if ($idx -gt -1) { $currentPath = $currentPath.Substring($idx + 2) }

	$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity

    # Kerazy_POSH propmt
    # Get Powershell version information
    $MajorVersion = $PSVersionTable.PSVersion.Major
    $MinorVersion = $PSVersionTable.PSVersion.Minor

    # Detect if the Shell is 32- or 64-bit host
    if ([System.IntPtr]::Size -eq 8) {
        $ShellBits = 'x64 (64-bit)'
    } elseif ([System.IntPtr]::Size -eq 4) {
        $ShellBits = 'x86 (32-bit)'
    }

    # Set Window Title to display Powershell version info, Shell bits, username and computername
    $host.UI.RawUI.WindowTitle = "PowerShell v$MajorVersion.$MinorVersion $ShellBits | $env:USERNAME@$env:USERDNSDOMAIN | $env:COMPUTERNAME | $env:LOGONSERVER"

    # Set Prompt Line 1 - include Date, file path location
    Write-Host(Get-Date -UFormat "%Y/%m/%d %H:%M:%S ($howlongwasthat) | ") -NoNewline -ForegroundColor DarkGreen
    Write-Host(Get-Location) -ForegroundColor DarkGreen

    # Set Prompt Line 2
    # Check for Administrator elevation
    if (Test-IsAdmin) {
        Write-Host '# ADMIN # ' -NoNewline -ForegroundColor Cyan
    } else {        
        Write-Host '# User # ' -NoNewline -ForegroundColor DarkCyan
    }

    if ($psISE) { $color = "Black"; }
    elseif ($windowsPrincipal.IsInRole("Administrators") -eq 1)
    { $color = "Yellow";}
    else{ $color = "Green";}

if ( $(Test-CommandExists 'Write-HgStatus') )
{
	Write-HgStatus (Get-HgStatus)
	Write-GitStatus (Get-GitStatus)
}
	write-host (" [" + $nextId + "]") -NoNewLine -ForegroundColor $color
	if ((get-location -stack).Count -gt 0) { write-host ("+" * ((get-location -stack).Count)) -NoNewLine -ForegroundColor Cyan }


if ( $(Test-CommandExists 'set-title') )
{    $title = $currentPath  
    if ($windowTitle -ne $null) { $title = ($title + "  »  " + $windowTitle) }
	set-title $title
}

	return " "

    Write-Host '»' -NoNewLine -ForeGroundColor Green
    ' ' # need this space to avoid the default white PS>  



# Style default PowerShell Console
$shell = $Host.UI.RawUI

$shell.WindowTitle= "PS"

$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "White"

$colors = $host.PrivateData
$colors.verbosebackgroundcolor = "Magenta"
$colors.verboseforegroundcolor = "Green"
$colors.warningbackgroundcolor = "Red"
$colors.warningforegroundcolor = "white"
$colors.ErrorBackgroundColor = "DarkCyan"
$colors.ErrorForegroundColor = "Yellow"

# Load custom theme for Windows Terminal
#Set-Theme LazyAdmin
Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"
Write-Host "admin: $isAdmin"
<#
    # 设置 PowerShell 主题
 * Author: 刘 鹏
 * Email: littleNewton6@outlook.com
 * Date: 2021, Aug. 21
   # 引入 ps-read-line # useful history related actions      
   # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
#>
   if (Test-ModuleExists 'PSReadLine')
    {
# 引入 ps-read-line
 	    if(!(TryImport-Module PSReadLine)) #null if fail to load
        {        
         
            #-------------------------------  Set Hot-keys BEGIN  -------------------------------
        
            $PSReadLineOptions = @{
                HistorySavePath = $global:historyPath
# 设置预测文本来源为历史记录
                PredictionSource = "HistoryAndPlugin"
# 每次回溯输入历史，光标定位于输入内容末尾
                HistorySearchCursorMovesToEnd = $true                        
            }
            
            Set-PSReadLineOption @PSReadLineOptions
            
            echo ($host.Name -eq 'ConsoleHost')
            # Set-PSReadLineOption -EditMode Emac
            
            # 每次回溯输入历史，光标定位于输入内容末尾    
            # 设置 Tab 为菜单补全和 Intellisense    
            # 设置 Ctrl+d 为退出 PowerShell
            # 设置 Ctrl+z 为撤销
            # 设置向上键为后向搜索历史记录 # Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
                Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete       
            # 设置 Ctrl+d 为退出 PowerShell
            Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
                Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
            # 设置 Ctrl+z 为撤销
                Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

            # 设置向上键为后向搜索历史记录 # Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
            Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# 设置向下键为前向搜索历史纪录


            if ( $null -ne $(Get-Module PSFzf)  ) {
                #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
                #$FZF_COMPLETION_TRIGGER='...'
                Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
            }
                Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

                #-------------------------------  Set Hot-keys END    -------------------------------

                if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
                    # 设置预测文本来源为历史记录
                    Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
                }


                if ( $(Test-CommandExists 'Set-PSReadLineOption') )
                {
                    #------------------------------- Styling begin --------------------------------------					      
                    #change selection to neongreen
                    #https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
                    $colors = @{
                    "Selection" = "$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m"
                    }
                    Set-PSReadLineOption -Colors $colors
                }
                echo "historyPath: $global:historyPath"
        }
        else
        {
            Write-Verbose "psReadLineNotimported"
        }
    }
    else
    {
        Write-Verbose "psReadLineNotpresent"
    }
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

function repairHead {param($from="refs/heads/master",$to="origin/master"); $expr = "git update-ref "+$from+" "+ $to; invoke-expression $expr }

function filter-repo($from,$to,$ref) { $expr = "git filter-repo --path-rename "+$from+":"+$to +" --refs '" + $ref + "'" ; invoke-expression $expr }

function to-Subdirectory($to,$ref) { git filter-repo --to-subdirectory-filter $to --refs $ref }

function remove-directory($rel) { git filter-repo --path $rel --invert-path --force}

function subdir-ToRoot($rel) { git filter-repo --subdirectory-filter $rel --force}

function subdir-ToRoot($rel,$ref) { git filter-repo --subdirectory-filter $rel --force --refs $ref }

function merge-ours($branch) { git merge $branch --strategy ours --allow-unrelated-histories }

function newFeatureBranch { param( [Parameter(Mandatory=$true)][string]$path) ; $branchName = get-item -Path $path -baseName ; git branch -t $branchName $path ; $originalBranchName = (git symbolic-ref HEAD) ; git switch --detach $branchName ; git add $path ; git commit -m "Added file $path" ; git switch --detach $originalBranchName ; rm $path }

function CheckoutNotTree() { param([Parameter(Mandatory=$true)][string]$branchName) ; return (git symbolic-ref HEAD) ; git switch --detach $branchName }

function Invoke-GitTemp {
  param(
      # Validate that the Script parameter is not null or empty and is a script block
      [Parameter(Mandatory = $false)]
      [ValidateNotNullOrEmpty()]
      [ValidateScript({$_ -is [scriptblock]})]
      [scriptblock]
      $Script,

      # Validate that the RemoveAfter parameter is a switch
      [Parameter(Mandatory = $false)]
      [ValidateScript({$_ -is [switch]})]
      [switch]
      $RemoveAfter
  )

  # Create a temporary file and get its directory name
  $tempFile = New-TemporaryFile

    #Use the Split-Path cmdlet to get the directory name of the temporary file. For example:

  $tempDir = Split-Path -Parent $tempFile

  # Create a subdirectory under the temporary directory with a unique name
    #Use the New-Item cmdlet to create a subdirectory under the temporary directory. You can use any name you want for the subdirectory. For example:
  $prefix = (New-Guid).Guid
  $gitDir = New-Item -Path $tempDir -Name "$prefix.gitrepo" -ItemType Directory

  # Change the current location to the subdirectory
  Push-Location -Path $gitDir -ErrorAction Stop

  # Initialize an empty git repository in the subdirectory
  $q = invoke-git("init")
  Write-Verbose $q

  # Check if a script block is specified
  if ($Script) {
      # Execute the script block and store the result
      $result = Invoke-Command -ScriptBlock $Script
  }
  else {
      # Return the path of the subdirectory as output
      $result = $gitDir
  }

  # Return to the previous location
  Pop-Location -ErrorAction Stop

  # Check if the flag is set to true
  if ($RemoveAfter) {
      # Delete the subdirectory and its contents
      Remove-Item -Path $gitDir -Recurse -Force
  }

  # Return the result as output
  return $result
}

function Git-disable-OwnershipCheck { git config --global core.ignoreStat all }

function SetFileExtension()
{
	set-location (get-clipboard); 
	$location = get-clipboard # Get the list of files in the current directory
	$files = Get-ChildItem -File

	# Get the total number of files
	$total = $files.Count

	# Initialize a counter for the current file
	$current = 0

	$files | % {
	$file = $_
	  $current++

	  # Calculate the percentage of completion
	  $percent = ($current / $total) * 100

	  # Write a progress message with a progress bar
	  Write-Progress -Activity "Setting file extensions in $location" -Status "Processing file $current of $total" -PercentComplete $percent -CurrentOperation "Checking file '$($file.Name)'"

	  # Set the file extension if it does not match the one from trid
	  Set-FileExtensionIfNotMatch($file.Name)
	}
}
function Set-FileExtensionIfNotMatch($fileName) {
  # Get the current file extension
  $currentExtension = [System.IO.Path]::GetExtension($fileName)

  # Get the expected file extension from trid
  $expectedExtension = Get-FileExtensionFromTrid($fileName)

  # Check if the current and expected extensions are different
  if ($currentExtension -ne $expectedExtension) {
    # Rename the file with the expected extension
    Rename-Item -Path $fileName -NewName ("$fileName$expectedExtension")
    # Write a message to the output
    Write-Output "Renamed file '$fileName' to have extension '$expectedExtension'"
  }
}
function Get-FileExtensionFromTrid($fileName) {
  # Invoke trid with the file name and capture the output
  $tridOutput = trid $fileName

  # Check if the output contains any matches
  if ($tridOutput -match "(\d+\.?\d*)%\s+\((\.\S+)\)\s+(.*)") {
    # Get the highest percentage match and its corresponding extension
    $highestMatch = ($tridOutput | Select-String "(\d+\.?\d*)%\s+\((\.\S+)\)\s+(.*)" -AllMatches).Matches | Select-Object -First 1
    $extension = ($highestMatch.Groups[2].Value -split '/')[0]

    # Return the extension
    return $extension
  }
  else {
    # Return an empty string if no matches are found
    return ""
  }
}
function Ensure-Path {
    param (
        [string]$Path
    )
    # Validate the parameter
    if (-not $Path) {
        Write-Error "Path parameter is required"
        return
    }
    # Check if the path is valid
    if (-not [System.IO.Path]::IsPathRooted($Path)) {
        # The path is relative, resolve it to an absolute path
        $Path = Join-Path -Path (Get-Location) -ChildPath $Path
    }
    # Check if the path contains invalid characters
    if ([System.IO.Path]::GetInvalidPathChars() -join '' -match [regex]::Escape($Path)) {
        # The path contains invalid characters, throw an error
        throw "The path '$Path' contains invalid characters."
    }
    # Check if the path exists
    if (Test-Path -Path $Path) {
        # The path exists, return it
        return $Path
    }
    else {
        # The path does not exist, try to create it
        try {
            $item = New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
            # Return the full path of the created directory
            return $item.FullName
        }
        catch {
            # An error occurred while creating the path, throw an error
            throw "Failed to create the path '$Path': $($_.Exception.Message)"
        }
    }
}
function Invoke-Git {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Command = "status" # The git command to run
    )

    if ($Command -eq "") {
        $Command = "status"
    } elseif ($Command.StartsWith("git ")) {
        $Command = $Command.Substring(4)
    }

    # Run the command and capture the output
    $output = Invoke-Expression -Command "git $Command 2>&1" -ErrorAction Stop 

    # Check the exit code and throw an exception if not zero
    if ($LASTEXITCODE -ne 0) {
        $errorMessage = $Error[0].Exception.Message
        throw "Git command failed: git $Command. Error message: $errorMessage"
    }

    # return the output to the host
    $output
}
function Spotify-UrlToPlaylist { $original = get-clipboard ; $transformed = $original.replace(“https://open.spotify.com/playlist/”, “spotify:user:spotify:playlist:”).replace(“?si=”, “=”) ; ($transformed -split '=')[0] | set-clipboard ; "done" }
function git-filter-folder
   {
      param(
      $namex
      )
      $current = git branch --show-current;
      $branchName = ('b'+$namex);
      
      git checkout -b $branchName
      
      git filter-repo --force --refs $branchName --subdirectory-filter $namex
      
      git checkout $current
      
      git filter-repo --force --refs $current --path $namex --invert-paths      
   }
function explore-to-history {
    # Get the history file path from PSReadline module
    $historyPath = (Get-PSReadlineOption).HistorySavePath

    # Get the parent folder of the history file
    $parentFolder = Split-Path -Path $historyPath -Parent

    # Open a new explorer instance at the parent folder location
    explorer.exe $parentFolder
}
function replace-delimiter {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$delimiter,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string]$replacement
    )

    # Get the clipboard content as a string
    $content = Get-Clipboard -TextFormatType Text

    # Replace each occurrence of the delimiter with the replacement
    $newContent = $content -replace [regex]::Escape($delimiter), $replacement
    echo $newContent
    # Set the clipboard to the new content if no error occurred
    
        Set-Clipboard -Value $newContent
    
}
