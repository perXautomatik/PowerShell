<#
    First, PowerShell will load the profile.ps1 file, which is the “Current User, All Hosts” profile.
    This profile applies to all PowerShell hosts for the current user, such as the console host or the ISE host. 
    You can use this file to define settings and commands that you want to use in any PowerShell session, regardless of the host.

    Next, PowerShell will load the Microsoft.PowerShellISE_profile.ps1 file, which is the “Current User, Current Host” 
    profile for the ISE host. This profile applies only to the PowerShell ISE host for the current user. 
    You can use this file to define settings and commands that are specific to the ISE host, 
    such as customizing the ISE editor or adding ISE-specific functions.
#>

#-------------------------------    Functions END     -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)
if (test-path alias:\cd)              { remove-item -force alias:\cd }                 # We override with cd.ps1
if (test-path alias:\chdir)           { remove-item -force alias:\chdir }              # We override with an alias to cd.ps1
if (test-path function:\prompt)       { remove-item -force function:\prompt }          # We override with prompt.ps1
                Set-Alias history           	Get-History                           	-Option AllScope
                Set-Alias kill              	killx                          			-Option AllScope
                Set-Alias mv                	Move-Item                             	-Option AllScope
                Set-Alias pwd               	Get-Location                          	-Option AllScope
                Set-Alias rm                	Remove-Item                           	-Option AllScope
                Set-Alias echo              	Write-Output                          	-Option AllScope
                Set-Alias cls               	Clear-Host                            	-Option AllScope
                Set-Alias copy              	Copy-Item                             	-Option AllScope
                Set-Alias del               	Remove-Item                           	-Option AllScope
                Set-Alias dir               	Get-Childitem                         	-Option AllScope
                Set-Alias type              	Get-Content                           	-Option AllScope
                Set-Alias sudo                  Elevate-Process           	            -Option AllScope
                set-alias pastDoEdit        	find-historyAppendClipboard           	-Option AllScope
                set-alias pastDo            	find-historyInvoke                    	-Option AllScope
                set-alias everything        	invoke-Everything                     	-Option AllScope
                set-alias executeThis       	invoke-FuzzyWithEverything            	-Option AllScope
                set-alias exp-pro           	open-ProfileFolder                    	-Option AllScope
                set-alias MyAliases         	read-aliases                          	-Option AllScope                
                set-alias printpaths        	read-EnvPaths                         	-Option AllScope
                set-alias uptime            	read-uptime                           	-Option AllScope
                set-alias parameters        	get-parameters                        	-Option AllScope
                set-alias accelerators      	([accelerators]::Get)                 	-Option AllScope
                set-alias reboot            	exit-Nrenter                          	-Option AllScope
                set-alias reload            	initialize-profile                    	-Option AllScope
$profileFolder = (split-path $profile -Parent)
. $env:USERPROFILE\.config\WindowsPowerShell\profile.ps1


# Sometimes home doesn't get properly set for pre-Vista LUA-style elevated admins
 if ($home -eq "") { remove-item -force variable:\home $home = (get-content env:\USERPROFILE) (get-psprovider 'FileSystem').Home = $home } set-content env:\HOME $home


#loadMessage
echo (Split-Path -leaf $MyInvocation.MyCommand.Definition)

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host ("Profile:   " + (Split-Path -leaf $MyInvocation.MyCommand.Definition))

Write-Host "This script was invoked by: "+$($MyInvocation.Line)


#------------------------------- Styling begin --------------------------------------					      
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
