[system.Diagnostics.Process]::Start("msedge","")

Sleep 3 
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('Bing') 
Sleep 3 
$wshell.SendKeys('edge://extensions-internals/')
$wshell.SendKeys('{ENTER}')
Sleep 3 
$wshell.SendKeys('^a')
$wshell.SendKeys('^c')
