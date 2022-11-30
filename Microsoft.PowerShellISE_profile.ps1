

#Module Browser Begin
#Version: 1.0.0
Add-Type -Path 'E:\Program Files (x86)\Microsoft Module Browser\ModuleBrowser.dll'
$moduleBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Module Browser', [ModuleBrowser.Views.MainView], $true)
$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $moduleBrowser
#Module Browser End
<<<<<<< HEAD
# Start AzureAutomationISEAddOn snippet
Import-Module AzureAutomationAuthoringToolkit
# End AzureAutomationISEAddOn snippet
=======
>>>>>>> a3de7a5 (Merge remote-tracking branch 'remotes/origin/ProjectFolderWithScriptsFolder' into ProjectFolderWithScriptsFolder)
