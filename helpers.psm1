function Initialize-Profile                     { . $PROFILE.CurrentUserCurrentHost} #function initialize-profile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { & $profile } #reload-profile is an unapproved verb.
#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}    
#src: https://stackoverflow.com/a/34098997/7595318
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

# Define a function to import modules based on priority
function Import-PriorityModule {
  # Define the parameters for the function
  param (
    # The path to the directory where the modules are located
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ })]
    [Alias("Path")]
    [string] $Directory,

    # The hash table for the priority order of file names
    [Parameter(Mandatory = $true)]
    [ValidateScript({ $_.Count -gt 0 })]
    [Alias("Priority")]
    [hashtable] $PriorityOrder
  )

  # Define the begin block
  begin {
    # Get all .psm1 files in the directory
    $files = Get-ChildItem -Path $Directory\*.psm1

    # Sort the files by their priority values
    $files = $files | Sort-Object -Property {
      if ($PriorityOrder.ContainsKey($_.Name)) {
        $PriorityOrder[$_.Name]
      }
      else {
        # Use a large number for files that are not in the priority hash table
        9999
      }
    }

    # Initialize an empty array to store the imported modules
    $importedModules = @()
  }

  # Define the process block
  process {
    # Loop through each file
    foreach ($file in $files) {
      # Import the module and add it to the array
      $importedModules += Import-Module -Name $file.FullName -PassThru

      # Write a message to the host
      Write-Host "Loaded: $($file.FullName)"
    }
  }

  # Define the end block
  end {
    # Return the array of imported modules
    return $importedModules
  }
}

# Define a function to dot-source all .ps1 files in a directory
function Load-AllChildPs1 {
  # Define the parameters for the function
  param (
    # The path to the directory where the scripts are located
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ })]
    [Alias("Path")]
    [string] $Directory,

    # The name pattern to exclude from dot-sourcing
    [Parameter(Mandatory = $false)]
    [Alias("Exclude")]
    [string[]] $ExcludePattern = @("Microsoft.PowerShell_profile.ps1")
  )

  # Define the begin block
  begin {
    # Get all .ps1 files in the directory that are not in the exclude array
    $files = Get-ChildItem -Path $Directory\*.ps1 | Where-Object { $ExcludePattern -notcontains $_.Name }

    # Initialize an empty array to store the dot-sourced files
    $dotSourcedFiles = @()
  }

  # Define the process block
  process {
    # Loop through each file
    foreach ($file in $files) {
      # Dot-source the file and add it to the array
      $dotSourcedFiles += . $file.FullName

      # Write a message to the host
      Write-Host "Loaded: $($file.FullName)"
    }
  }

  # Define the end block
  end {
    # Return the array of dot-sourced files
    return $dotSourcedFiles
  }
}


function Download-Latest-Profile {
    New-Item $( Split-Path $($PROFILE.CurrentUserCurrentHost) ) -ItemType Directory -ea 0
    if ( $(Get-Content "$($PROFILE.CurrentUserCurrentHost)" | Select-String "62a71500a0f044477698da71634ab87b" | Out-String) -eq "" ) {
        Move-Item -Path "$($PROFILE.CurrentUserCurrentHost)" -Destination "$($PROFILE.CurrentUserCurrentHost).bak"
    }
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/apfelchips/62a71500a0f044477698da71634ab87b/raw/Profile.ps1" -OutFile "$($PROFILE.CurrentUserCurrentHost)"
    Reload-Profile
}


function timer($script,$message){
    $t = [system.diagnostics.stopwatch]::startnew()
    $job = Start-ThreadJob -ScriptBlock $script
    
    while($job.state -ne "Completed"){    
        Write-Output = "$message Elapsed: $($t.elapsed) "                
        start-sleep 1
    }
    $t.stop()
    $job | Receive-Job
}
function Get-HostExecutable {
    if ( $PSVersionTable.PSEdition -eq "Core" ) {
        $ConsoleHostExecutable = (get-command pwsh).Source
    } else {
        $ConsoleHostExecutable = (get-command powershell).Source
    }
    return $ConsoleHostExecutable
}


function Select-Value { # src: https://geekeefy.wordpress.com/2017/06/26/selecting-objects-by-value-in-powershell/
    [Cmdletbinding()]
    param(
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )
    process {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name
        If ( $Property ) {
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

function uptimef
{
	Get-WmiObject win32_operatingsystem | select csname, @{
		LABEL	   = 'LastBootUpTime';
		EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) }
	}
}
function reloadProfile {
	& $profile
}



if ($isWindows) 
{
  $user = [Security.Principal.WindowsIdentity]::GetCurrent(); 
  $q = ($user).groups -match "S-1-5-32-544"

function Test-IsAdmin 
	{
	       if ((id -u) -eq 0) {
	        return $true
         } 
	       else
	       {            
            if($q -eq $null)
            {
              return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
            }
            else { return $q }
	       }
	}
}        
