
#------------------------------Credit to: Kreloc ---------------------------------------------------------

# Version: 1.3.3

### Region Profile Internal Functions
function Export-ISEState {
<#
.SYNOPSIS
    Stores the opened files in a serialized xml so that later the same set can be opened
 
.DESCRIPTION
    Creates an xml file with all PowerShell tabs and file information
   
.PARAMETER fileName
    The name of the project to create a new version from. This will also be the name of the new project, but with a different version
 
.EXAMPLE
    Stores current state into c:\temp\files.isexml
    Export-ISEState c:\temp\files.isexml
#>
 
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$fileName
    )
   
    # We are exporting a "tree" worth of information like this:
    #
    #  SelectedTabDisplayName: PowerShellTab 1
    #  SelectedFilePath: c:\temp\a.ps1
    #  TabInformation:
    #      PowerShellTab 1:
    #           File 1:
    #                FullPath:     c:\temp\a.ps1
    #                FileContents: $null
    #           File 2:
    #                FullPath:     Untitled.ps1
    #                FileContents: $a=0...
    #       PowerShellTab 2:
    #       ...
    #  Hashtables and arraylists serialize rather well with export-clixml
    #  We will keep the list of PowerShellTabs in one ArrayList and the list of files
    #  and contents(for untitled files) inside each tab in a couple of ArrayList.
    #  We will use Hashtables to group the information.
    $tabs=new-object collections.arraylist
   
    # before getting file information, save all untitled files to make sure their latest
    # text is on disk
    Save-AllISEFiles
 
    foreach ($tab in $psISE.PowerShellTabs)
    {
        $files=new-object collections.arraylist
        $filesContents=new-object collections.arraylist
        foreach($file in $tab.Files)
        {
            # $null = will avoid $files.Add from showing in the output
            $null = $files.Add($file.FullPath)
           
            if($file.IsUntitled)
            {
                # untitled files are not yet on disk so we will save the file contents inside the xml
                # export-clixml performs the appropriate escaping for the contents to be inside the xml
                $null = $filesContents.Add($file.Editor.Text)
            }
            else
            {
                # titled files get their content from disk
                $null = $filesContents.Add($null)  
            }
        }
        $simpleTab=new-object collections.hashtable
       
        # The DisplayName of a PowerShellTab can only be change with scripting
        # we want to maintain the chosen name       
        $simpleTab["DisplayName"]=$tab.DisplayName
       
        # $files and $filesContents is the information gathered in the foreach $file above
        $simpleTab["Files"]=$files
        $simpleTab["FilesContents"]=$filesContents
       
        # add to the list of tabs
        $null = $tabs.Add($simpleTab)
       
    }
   
    # tabsToSerialize will be a hashtable with all the information we want
    # it is the "root" of the information to be serialized in the hashtable we store...
    $tabToSerialize=new-object collections.hashtable
   
    # the $tabs information gathered in the foreach $tab above...
    $tabToSerialize["TabInformation"] = $tabs
   
    # ...and the selected tab and file.
    $tabToSerialize["SelectedTabDisplayName"] = $CurrentPowershellTab.DisplayName
    $tabToSerialize["SelectedFilePath"] = $psISE.CurrentFile.FullPath
   
    # now we just export it to $fileName
    $tabToSerialize | export-clixml -path $fileName
}
 
function Import-ISEState {
<#
.SYNOPSIS
    Reads a file with ISE state information about which files to open and opens them
 
.DESCRIPTION
    Reads a file created by Export-ISEState with the PowerShell tabs and files to open
   
.PARAMETER fileName
    The name of the file created with Export-ISEState
 
.EXAMPLE
    Restores current state from c:\temp\files.isexml
    Import-ISEState c:\temp\files.isexml
#>
 
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$fileName
    )
   
   
    # currentTabs is used to keep track of the tabs currently opened.
    # If "PowerShellTab 1" is opened and $fileName contains files for it, we
    # want to open them in "PowerShellTab 1"
    $currentTabs=new-object collections.hashtable
    foreach ($tab in $psISE.PowerShellTabs)
    {
        $currentTabs[$tab.DisplayName]=$tab
    }
   
    $tabs=import-cliXml -path $fileName
 
    # those will keep track of selected tab and files   
    $selectedTab=$null
    $selectedFile=$null
 
    foreach ($tab in $tabs.TabInformation)
    {
        $newTab=$currentTabs[$tab.DisplayName]
        if($newTab -eq $null)
        {
            $newTab=$psISE.PowerShellTabs.Add()
            $newTab.DisplayName=$tab.DisplayName
        }
        #newTab now has a brand new or a previouslly existing PowerShell tab with the same name as the one in the file
       
        # if the tab is the selected tab save it for later selection
        if($newTab.DisplayName -eq $tabs.SelectedTabDisplayName)
        {
            $selectedTab=$newTab
        }
       
        # currentUntitledFileContents keeps track of the contents for untitled files
        # if you already have the content in one of your untitled files
        # there is no reason to add the same content again
        # this will make sure calling import-ISEState multiple times
        # does not keep on adding untitled files
        $currentUntitledFileContents=new-object collections.hashtable
        foreach ($newTabFile in $newTab.Files)
        {
            if($newTabFile.IsUntitled)
            {
                $currentUntitledFileContents[$newTabFile.Editor.Text]=$newTabFile
            }
        }
       
        # since we will want both file and fileContents we need to use a for instead of a foreach
        for($i=0;$i -lt $tab.Files.Count;$i++)
        {
            $file = $tab.Files[$i]
            $fileContents = $tab.FilesContents[$i]
 
            #fileContents will be $null for titled files
            if($fileContents -eq $null)
            {
                # the overload of Add taking one string opens the file identified by the string
                $newFile = $newTab.Files.Add($file)
            }
            else # the file is untitled
            {
                #see if the content is already present in $newTab
                $newFile=$currentUntitledFileContents[$fileContents]
               
                if($newFile -eq $null)
                {
                    # the overload of Add taking no arguments creates a new untitled file
                    # The number for untitled files is determined by the application so we
                    # don't try to keep the untitled number, we just create a new untitled.
                    $newFile = $newTab.Files.Add()
               
                    # and here we restore the contents
                    $newFile.Editor.Text=$fileContents
                }
            }
       
            # if the file is the selected file in the selected tab save it for later selection   
            if(($selectedTab -eq $newTab) -and ($tabs.SelectedFilePath -eq $file))
            {
                $selectedFile = $newFile
            }
        }
    }
   
    #finally we selected the PowerShellTab that was selected and the file that was selected on it.
    $psISE.PowerShellTabs.SetSelectedPowerShellTab($selectedTab)
    if($selectedFile -ne $null)
    {
        $selectedTab.Files.SetSelectedFile($selectedFile)
    }
}

function Clear-SavedHistory { # src: https://stackoverflow.com/a/38807689
[CmdletBinding(ConfirmImpact='High', SupportsShouldProcess)]
param()
$havePSReadline = ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue) )
$target = if ( $havePSReadline ) { "entire command history, including from previous sessions" } else { "command history" }
if ( -not $pscmdlet.ShouldProcess($target) ) { return }
if ( $havePSReadline ) {
    Clear-Host
    # Remove PSReadline's saved-history file.
    if ( Test-Path (Get-PSReadlineOption).HistorySavePath ) {
        # Abort, if the file for some reason cannot be removed.
        Remove-Item -ea Stop (Get-PSReadlineOption).HistorySavePath
        # To be safe, we recreate the file (empty).
        $null = New-Item -Type File -Path (Get-PSReadlineOption).HistorySavePath
    }
    # Clear PowerShell's own history
    Clear-History
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
} else { # Without PSReadline, we only have a *session* history.
    Clear-Host
    Clear-History
}
}
       
### End Region Profile Functions
