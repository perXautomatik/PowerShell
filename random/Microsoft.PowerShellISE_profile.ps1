

<<<<<<< HEAD
#Module Browser Begin
#Version: 1.0.0
Add-Type -Path 'E:\Program Files (x86)\Microsoft Module Browser\ModuleBrowser.dll'
$moduleBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Module Browser', [ModuleBrowser.Views.MainView], $true)
$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $moduleBrowser
#Module Browser End
=======
# Start AzureAutomationISEAddOn snippet
Import-Module AzureAutomationAuthoringToolkit
# End AzureAutomationISEAddOn snippet
>>>>>>> 4fa94b6 (retored files from f874d40275761cf2039c3e510a299b64012b3609)
