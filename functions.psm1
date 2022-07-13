<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

#loadMessage
echo "Microsoft.PowerShell_profile.ps1"

# Increase history
$MaximumHistoryCount = 10000

#------------------------------- Import Modules BEGIN -------------------------------

Install-Module -Name PowerShellGet -Scope CurrentUser -AllowClobber -AllowPrerelease   -AcceptLicense -force -Name   -SkipPublisherCheck
$profileFolder = (split-path $profile -Parent)
$pos = join-path -Path $profileFolder -ChildPath 'importModules.ps1'
 Import-Module $pos
$pos = join-path -Path $profileFolder -ChildPath 'sqlite.ps1' 
 Import-Module $pos
#------------------------------- Import Modules END   -------------------------------


# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

#ps ExecutionPolicy;
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#https://stackoverflow.com/questions/47356782/powershell-capture-git-output
#Then stderr should be redirected to stdout.
#set GIT_REDIRECT_STDERR=2>&1

#------------------------------- Set Paths           -------------------------------

$pos = join-path -Path (split-path $profile -Parent)  -ChildPath 'setPaths.ps1'

Import-Module  $pos

# Load scripts from the following locations
$env:Path += ";D:\SysAdmin\scripts\PowerShellBasics"
$env:Path += ";D:\SysAdmin\scripts\Connectors"
$env:Path += ";D:\SysAdmin\scripts\Office365"
$historyPath = 'C:\Users\Användaren\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt'
set-PSReadlineOption -HistorySavePath $historyPath
echo "historyPath: $historyPath"

# vscode Portable Path
#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
$newpath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable('code', $newpath)

#------------------------------- Set Paths  end       -------------------------------

#------------------------------- overloading begin

#https://www.sapien.com/blog/2014/10/21/a-better-tostring-method-for-hash-tables/			      
#better hashtable ToString method			      
  Update-TypeData -TypeName System.Collections.HashTable `
    -MemberType ScriptMethod `
    -MemberName ToString `
    -Value { $hashstr = "@{"; $keys = $this.keys; foreach ($key in $keys) { $v = $this[$key]; 
             if ($key -match "\s") { $hashstr += "`"$key`"" + "=" + "`"$v`"" + ";" }
             else { $hashstr += $key + "=" + "`"$v`"" + ";" } }; $hashstr += "}";
             return $hashstr }
#-------------------------------  overloading end


#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# 设置预测文本来源为历史记录
#Set-PSReadLineOption -PredictionSource History

# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
# 设置向下键为前向搜索历史纪录
# Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------
# Helper Functions
#######################################################

function uptimef {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reloadProfile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}

function printpath {
	($Env:Path).Split(";")
}


function unzipf ($file) {
	$dirname = (Get-Item $file).Basename
	echo("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}
#------------------------------- SystemMigration      -------------------------------

#choco check if installed
#path to list of aps to install
#choco ask to install if not present

#list of portable apps,download source
#path
#download and extract if not present, ask to confirm

#path to portable apps
#path to standard download location


#git Repos paths and origions,
#git systemwide profile folder
#git global path

#everything data folder
#autohotkey script to run on startup

#startup programs

#reg to add if not present

#------------------------------- SystemMigration end  -------------------------------
					      
#------------------------------- Styling begin --------------------------------------					      
#change selection to neongreen
#https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
$colors = @{
   'Selection' = '$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m'
}
Set-PSReadLineOption -Colors $colors

# Style default PowerShell Console
$shell = $Host.UI.RawUI

$shell.WindowTitle= "PS"

$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "White"

# Load custom theme for Windows Terminal
#Set-Theme LazyAdmin
