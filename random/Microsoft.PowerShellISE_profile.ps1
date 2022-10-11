

#Module Browser Begin
#Version: 1.0.0
<<<<<<< HEAD
Add-Type -Path 'E:\Program Files (x86)\Microsoft Module Browser\ModuleBrowser.dll'
=======
Add-Type -Path 'C:\Program Files (x86)\Microsoft Module Browser\ModuleBrowser.dll'
>>>>>>> 6e627396db00db8e49ff224ee404bee634c268fb
$moduleBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Module Browser', [ModuleBrowser.Views.MainView], $true)
$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $moduleBrowser
#Module Browser End
# Start AzureAutomationISEAddOn snippet
Import-Module AzureAutomationAuthoringToolkit
# End AzureAutomationISEAddOn snippet