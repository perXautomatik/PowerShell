<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Copyright: No copyright. You can use this code for anything with no warranty.
    First, PowerShell will load the profile.ps1 file, which is the “Current User, All Hosts” profile.
    This profile applies to all PowerShell hosts for the current user, such as the console host or the ISE host.
    You can use this file to define settings and commands that you want to use in any PowerShell session, regardless of the host.

    Next, PowerShell will load the Microsoft.PowerShellISE_profile.ps1 file, which is the “Current User, Current Host”
    profile for the ISE host. This profile applies only to the PowerShell ISE host for the current user.
    You can use this file to define settings and commands that are specific to the ISE host,
    such as customizing the ISE editor or adding ISE-specific functions.
#>
# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget

	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}

#function setEnviroment

# Sometimes home doesn't get properly set for pre-Vista LUA-style elevated admins
if ($home -eq "") {
    remove-item -force variable:\home
    $home = (get-content env:\USERPROFILE)
    (get-psprovider 'FileSystem').Home = $home
}

if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path $home -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME

. $env:XDG_CONFIG_HOME\WindowsPowerShell\profile.ps1

    $profileFolder = (split-path $profile -Parent)
    $profilex = (Split-Path -leaf $MyInvocation.MyCommand.Definition);
    # Use a subexpression operator
    $inv = $($MyInvocation.Line)



    if ($env:Snipps -eq "" -or (-not ($env:Snipps))) {
        $env:Snipps = join-path -Path $profileFolder -ChildPath 'snipps'
     
        if ($snipps -eq "") {
            remove-item -force variable:\snipps
            $snipps = (get-content env:Snipps)
            (get-psprovider 'FileSystem').Snipps = $snipps
        }

        if(Test-Path $env:Snipps)
        {
            $envPath = $env:Snipps
            $env:Path += ";$envPath"
        }

    }


    $historyPath = "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt" 

    if(test-path $historyPath)
    {
       set-PSReadlineOption -HistorySavePath $historyPath 
    }
 
    if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path $home -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR



function loadMessage
{
   
    #Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
    Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
    if(($inv -split "\'")[1] -ne (Join-Path -path "$profileFolder" -ChildPath "$profilex" ))
    {
        Write-Host "This script was invoked by: $inv"
    }
    else
    {
      Write-Host "This script was invoked by:"
    }

    Write-Host ("Profile:   " + $profilex)
    write-host ("Profile folder:  " + $profileFolder)
    Write-Host ("Snipps:   " + (Get-ChildItem $env:snipps | Measure-Object).Count + "     @:   " + $env:Snipps)

    Write-Host ("historyPath: " + (Get-PSReadLineOption -OutVariable HistorySavePath).HistorySavePath);
}

loadMessage






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
      [alias("goto-history")]
      [CmdletBinding()]
      param(
        [Parameter(Mandatory=$false)]
        $ignore
      )
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
function ListGitVarDupes { $q = @(git var -l) ;$u = 0; $q | %{ $u = $u +1 ; [PSCustomObject]@{
    counter = $u
    FirstName = ($_ -split "=",2)[0]
    LastName = ($_ -split "=",2)[1]
}} | group-object -Property firstname | ?{ $_.count -gt 1 } | % { $_.group | select-object -property * } | Sort-Object -Property firstname, counter }
function git-ListConfigFilesNValues { $q = @(git config --list --show-origin); $u = 0; $q | %{ $u = $u +1 ; [PSCustomObject]@{
    counter = $u
    path = (($_ -split ":",2)[1] -split "\t",2)[0]
    key = ((($_ -split ":",2)[1] -split "\t",2)[1] -split "=",2)[0]
    value = ((($_ -split ":",2)[1] -split "\t",2)[1] -split "=",2)[1]
}} }
function Invoke-OperaLauncher {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $q,
    [Parameter(Position = 1)]
    [string]
    $DriveLetter = 'F:'
  )

  Write-Verbose "Invoking OperaLauncher with parameter $q on drive $DriveLetter"

  if ($PSCmdlet.ShouldProcess("OperaLauncher", "Invoke")) {
    Invoke-Expression "$DriveLetter; Set-Location $DriveLetter\; .\OperaLauncher\opera.ps1 -a $q; & setFileExtension"
  }
}
# Define the folder name and the path file as parameters
function git-filter-path {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]$foldername,
    [string]$pathfile,
    [switch]$dry
  )

  # Get the current working directory
  $workdir = Get-Location

  # Check if the folder exists in the current working directory
  if ($pathfile -or (Test-Path -Path "$workdir\$foldername")) {
    # The folder exists, so use git to check if a branch with the name "foldername"+B exists
    $reg = "[^a-zA-Z]"
    $branchname = ("$foldername" -replace $reg , '_')
    $branchname = $branchname + "B"
    $branchexists = git branch --list $branchname

    if ($branchexists) {
      # The branch exists, so do nothing
      Write-Host "The branch $branchname already exists."
    }
    else {
      # The branch does not exist, so create a branch from the current branch with that name
      $reply = invoke-expression "git branch $branchname 2>&1"

      if($reply -match 'fatal') { continue }
      else {
	Write-Host "The branch $branchname was created from the current branch."
	# Use the path file instead of the parameter string

	$commandPart = "git filter-repo --refs $branchname --force"
	$commandPart3 = "git filter-repo --refs (git branch --show-current) --invert-paths --force"

	if ($PSBoundParameters.ContainsKey("pathfile")) {
		$commandPart2 = "--paths-from-file $pathfile"
		$commandPart4 = $commandPart2
	}
	else
	{
		$commandPart2 = "--subdirectory-filter $foldername" ;
		$commandPart4 = "--path $foldername"
	}

	if($dry)
	{
		Write-Host "$commandPart $commandPart2"
		Write-Host "$commandPart3 $commandPart4"
		 $PSBoundParameters
	}
	else
	{
		invoke-expression "$commandPart $commandPart2"
		invoke-expression  "$commandPart3 $commandPart4"
	}
      }
    }
  }
  else {
    # The folder does not exist, so do nothing
    Write-Host "The folder $foldername does not exist in the current working directory."
  }
}
function Get-dotnet { param ([string]$name) if ($name -match "\.") { $namespace = $name.Split(".") | select -SkipLast 1; $name = $name.Split(".")[-1] } ; Get-Member -Static -InputObject ( [AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | ? {$_.Name -eq $name} | ? { if($namespace){$_.Namespace -eq $namespace -join('.')} else {$true} }) }
function Filter-Repo-Current {
  $branch = git branch --show-current;
  git filter-repo --refs $branch $args
}
function Filter-Repo-Current {
  $branch = git branch --show-current;
  git filter-repo --refs $branch $args
}
function central-gitdir { cd 'B:\ProgramData\scoop\persist\.config' }
function git-Worktrees {

	$gitWorktreeOutput = @(git worktree list --porcelain) ; 
	
	$worktreeHeads = @{};                                   
	# itterate over the raw ressult 
	$worktreeLines = ($gitWorktreeOutput -split '\r?\n')
	foreach ($line in $worktreeLines) {
		if ($line -match '^worktree (.+)$') {
		 <# if the line starts with worktree, assume the line right below it is the head reference#>

	        $worktreeHeads[$matches[1]] = $worktreeLines[$worktreeLines.IndexOf($line) + 1] 		<# look up the lines in there parrent collection by reference + 1#>
		<# the matches variable is reset each line comparision and only asigned if a match occurs#>
		}
	}
		
	git-root # navigates to root of repo
								
	Get-ChildItem -path "$pwd\.git\worktrees" | 
		% {
			$fn = $_.fullname                  
			$git = Get-Content "$fn\gitdir" -erroraction silentlycontinue
			$ref = Get-Content "$fn\HEAD" -erroraction silentlycontinue
			$head = if($git) { $worktreeHeads[$git.trim('/.git')] }
			[pscustomobject]@{
				dir = $_.name    
				git = $git
				ref = $ref
				head= $head 
			}
		}
}

