
#------------------------------Credit to: Kreloc ---------------------------------------------------------

Import-Module (Join-Path ($profile | Split-Path -Parent) "\Microsoft.PowerShellISE_profile.psm1")
# Version: 1.3.3
$SystemWindowsInteractivityDll = '\\PuffinNas\NetBackup\Windows.old\Users\chris\AppData\Local\JetBrains\Installations\dotPeek223\System.Windows.Interactivity.dll'

# Script Browser Begin

    $ScriptBrowserDll = '.\Modules\ScriptBrowser\1.3.1.0\bin\ScriptBrowser.dll'
    $BestPracticesDll = '.\Modules\ScriptBrowser\1.3.1.0\bin\BestPractices.dll'

    $CurrentPowershellTab = $psISE.CurrentPowerShellTab
    $vertAdd = $CurrentPowershellTab.VerticalAddOnTools



    $SystemWindowsInteractivityDll, $ScriptBrowserDll, $BestPracticesDll | % { if(Test-Path -Path $_) { $toLoad += $_ }}

    #todo: Use every-load (cb find paths with everything)
    $toLoad | % { Add-Type -Path $_ }


    if((Test-Path -Path $ScriptBrowserDll)-and (Test-Path -Path $ScriptBrowserDll))
    {
        $scriptBrowser = $vertAdd.Add('Script Browser', [ScriptExplorer.Views.MainView], $true)
        $scriptAnalyzer = $vertAdd.Add('Script Analyzer', [BestPractices.Views.BestPracticesView], $true)
        $CurrentPowershellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $scriptBrowser

    }
# Script Browser End

# Save state file path
$ISE_STATE_FILE_PATH = Join-Path (Split-Path $profile -Parent) "IseState.xml"

## Region running scripts

if (($psISE.PowerShellTabs.Count -eq 1) -and ($CurrentPowershellTab.Files.Count -eq 1) -and ($CurrentPowershellTab.Files[0].IsUntitled) -and (Test-Path $ISE_STATE_FILE_PATH))
{
    # Remove the default "Untitled1.ps1" file and then load the session.
    if (!$CurrentPowershellTab.Files[0].IsRecovered) { $CurrentPowershellTab.Files.RemoveAt(0) }
    Import-ISEState $ISE_STATE_FILE_PATH
}

# Add own SubMenu
$MyMenu = $CurrentPowershellTab.AddOnsMenu.Submenus.Add("MyTools", $null, $null)

$AdvancedFunctionTemplate = @'
 Function [function]
 {
	<#	
		.SYNOPSIS
			A brief description of the [function] function.
		
		.DESCRIPTION
			A detailed description of the [function] function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			[function] <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | [function]
		
			Explanation of this example.

        .INPUTS
            Input a string or an array of strings.

        .OUTPUTS
            Produces a DateTime object
            
        .NOTES
            Advanced function template

        .LINK
            https://github.com/Kreloc
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName	
	)
    #Instruction for supporting WhatIf
    #Change to [CmdletBinding(SupportsShouldProcess=$true)]
    #Add this If statement block around each piece of code that would change something or produce output
    #unless it is using Cmdlets that already support WhatIf, those will inherit it down when -WhatIf is used in the function.
    <#
    If($PSCmdlet.ShouldProcess("$ComputerName","Attempting to do stuff"))
    {
        "Do Stuff"
    }
    #>
    Begin{}
    Process{}
    End{}
}
'@
<#
Microsoft.PowerShell.Host.ISE.ISEMenuItem Add(
string displayName, 
scriptblock action,                               
System.Windows.Input.KeyGesture shortcut
)           
#>
# Add function help and Cmdlet Binding
# add the action to the Add-Ons menu

$commands = @(
    @{
        action = {
            $psise.CurrentFile.Editor.InsertText("$AdvancedFunctionTemplate")
            # jump cursor to the end
            $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine,$psise.CurrentFile.Editor.CaretColumn)
        }
        displayName = "Insert Advanced Function Snippet"
        shortcut = "Alt+N"
        # End Insert Advanced function SubMenu
    }
    @{
        # Begin Save-All function SubMenu
        action = {
        $CurrentPowershellTab.Files.Where({-Not $_.isSaved -AND -Not $_.IsUntitled}).Foreach({$_.save()})
        }
        displayName = "Save all unsaved files"
        shortcut =  "Ctrl+Alt+S"
        # End Save-All function
    }
    @{
        # Begin load PowerShell Console Profile
        action = {
        $path = "$($profile.CurrentUserCurrentHost)" -replace "ISE"
        .$path
        }
        displayName = "Load User PS Profile"
        shortcut = "Alt+P"
        # End load PowerShell console profile    
    }    
    @{
        # Comment out selected text
        action = {
        $text = $psISE.CurrentFile.editor.selectedText
        $psISE.CurrentFile.Editor.InsertText( [regex]::Replace($text, '^', '##', 'Multiline'))
        }
        displayName ="Comment Code"
        shortcut = "Alt+3"
        # End Comment selected text
    }    
    @{
        # Uncomment selected text
        action = {
        $text = $psISE.CurrentFile.editor.selectedText
        $psISE.CurrentFile.Editor.InsertText( [regex]::Replace($text, '^##', '', 'Multiline'))
        }
        displayName ="UnComment Code"
        shortcut = "Alt+4"
        # End uncomment selected text
    }    
    @{
        # Begin move to cursor
        displayName ="Go To _Cursor"
        shortcut = "Alt+C"
        action = {
            $psise.CurrentFile.Editor.EnsureVisible($psise.CurrentFile.Editor.CaretLine)
            $psise.CurrentFile.Editor.Focus()
        }
        # End move to cursor
    }     
    @{
        # Begin export the current ISE state.
        displayName ="Save ISE State"
        shortcut = "Alt+Shift+S"
        action = {Export-ISEState $ISE_STATE_FILE_PATH}
        # End export the current ISE state.
    }   
    @{
        # Begin export the current ISE state and exit.
        displayName ="Save ISE State And Exit"
        shortcut = "Alt+Shift+E"
        action = {Export-ISEState $ISE_STATE_FILE_PATH; exit}
        # End export the current ISE state and exit
    }   
    @{
        # Begin import the ISE state.
        displayName ="Load ISE State"
        shortcut = "Alt+Shift+L"
        action = {Import-ISEState $ISE_STATE_FILE_PATH}
        # End import the ISE state.
    }   
    @{
    #Url: https://blog.ironmansoftware.com/using-powershell-7-in-the-windows-powershell-ise
        displayName ="Switch to PowerShell 7"
        shortcut = "ALT+F5"
        action = { 
        function New-OutOfProcRunspace {
            param($ProcessId)

            $ci = New-Object -TypeName System.Management.Automation.Runspaces.NamedPipeConnectionInfo -ArgumentList @($ProcessId)
            $tt = [System.Management.Automation.Runspaces.TypeTable]::LoadDefaultTypeFiles()

            $Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($ci, $Host, $tt)

            $Runspace.Open()
            $Runspace
        }

        $PowerShell = Start-Process PWSH -ArgumentList @("-NoExit") -PassThru -WindowStyle Hidden
        $Runspace = New-OutOfProcRunspace -ProcessId $PowerShell.Id
        $Host.PushRunspace($Runspace)
        }
    }   
     @{
     #Url: https://blog.ironmansoftware.com/using-powershell-7-in-the-windows-powershell-ise
        displayName ="Switch to Windows PowerShell 5"
        shortcut = "ALT+F6"
        action =  { 
                    $Host.PopRunspace()

                    $Child = Get-CimInstance -ClassName win32_process | where {$_.ParentProcessId -eq $Pid}
                    $Child | ForEach-Object { Stop-Process -Id $_.ProcessId }
                    $PowerShell = Start-Process PWSH -ArgumentList @("-NoExit") -PassThru -WindowStyle Hidden
                    $Runspace = New-OutOfProcRunspace -ProcessId $PowerShell.Id
                    $Host.PushRunspace($Runspace)
                     }
         }   

)
$commands | % {
    $dp = $_.displayName
    if (!($CurrentPowershellTab.AddOnsMenu.Submenus | Where-Object { $_.DisplayName -eq $dp  }))
    {
        $MyMenu.Submenus.Add($_.displayName,$_.action,$_.shortcut) | Out-Null
    }
 
}
## End Region running scripts
#$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Clear()
