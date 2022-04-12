# 引入 posh-git
Import-Module posh-git   

# Posh-Git overrides

$GitPromptSettings.AfterBackgroundColor = "DarkRed"
$GitPromptSettings.BeforeBackgroundColor = "DarkRed"
$GitPromptSettings.BeforeIndexBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBackgroundColor = "DarkRed"
$GitPromptSettings.BranchAheadBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBehindBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBehindAndAheadBackgroundColor = "DarkRed"
$GitPromptSettings.DelimBackgroundColor = "DarkRed"
$GitPromptSettings.IndexBackgroundColor = "DarkRed"
$GitPromptSettings.WorkingBackgroundColor = "DarkRed"
$GitPromptSettings.UntrackedBackgroundColor = "DarkRed"

$GitPromptSettings.AfterForegroundColor = $Host.UI.RawUI.ForegroundColor
$GitPromptSettings.BeforeForegroundColor = $Host.UI.RawUI.ForegroundColor
$GitPromptSettings.BeforeIndexForegroundColor = "Green"
$GitPromptSettings.BranchForegroundColor = "White"
$GitPromptSettings.IndexForegroundColor = "Green"
$GitPromptSettings.WorkingForegroundColor = "Cyan"
$GitPromptSettings.UntrackedForegroundColor = "Cyan"

$GitPromptSettings.AfterText = " "
$GitPromptSettings.BeforeText = " "
$GitPromptSettings.ShowStatusWhenZero = $false


# 引入 oh-my-posh
#Import-Module oh-my-posh

# 引入 ps-read-line
Import-Module PSReadLine

# 设置 PowerShell 主题
# Set-PoshPrompt ys
#Set-PoshPrompt paradox
#ps ecoArgs;
#Import-Module echoargs ;
#pscx history;
#Install-Module -Name Pscx
#Import-Module -name pscx   


Add-Type -Path "C:\Users\crbk01\AppData\Local\GMap.NET\DllCache\SQLite_v103_NET4_x64\System.Data.SQLite.DLL"

echo "modules imported"