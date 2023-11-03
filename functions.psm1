

# Helper Functions
#######################################################       

# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue
# define these environment variables if not set already and also provide them as PSVariables


#------------------------------- prompt beguin -------------------------------
#src: https://stackoverflow.com/a/34098997/7595318
	function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}


	function Test-IsAdmin { $user = [Security.Principal.WindowsIdentity]::GetCurrent(); return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); }

	function Reopen-here { Get-Process explorer | Stop-Process Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"}
	function Test-Administrator                     { $user = [Security.Principal.WindowsIdentity]::GetCurrent() ; (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) } # https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
	function Get-DefaultAliases                     { Get-Alias | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_.Options -match "ReadOnly" }}
	function get-envVar                             { Get-Childitem -Path Env:*}
	function get-historyPath                        { (Get-PSReadlineOption).HistorySavePath }
	function get-parameters                         { Get-Member -Parameter *}
	function Initialize-Profile 			        {. $PROFILE.CurrentUserCurrentHost} #function initialize-profile { & $profile } #reload-profile is an unapproved verb.
	function man                                    { Get-Help $args[0] | out-host -paging }
	function My-Scripts                             { Get-Command -CommandType externalscript }
	function open-ProfileFolder                     { explorer (split-path -path $profile -parent)}
	function read-aliases 				            { Get-Alias | Where-Object { $_.Options -notmatch "ReadOnly" }}
	function read-EnvPaths	 			            { ($Env:Path).Split(";") }
	function sort-PathByLvl                         { param( $inputList) $inputList                                                                                                                                                                                                                                          | Sort                                                                                                                                                                                                                                                                                                                                                                                   {($_ -split '\\').Count},                                                                                                                                                                                                                                                                                            {$_} -Descending                                       | select -object -first 2                                          | %                                                                                                                                                                                                                                                                                                                                                           { $error.clear()                                            ; try                                                                                                                                                                                                { out -null -input (test -ModuleManifest $_ > '&2>&1' ) } catch                                                                               { "Error" } ; if (!$error) { $_ } }}
	function which($name) 				            { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more

function sanitize-clipboard { $regex = "[^a-zA-Z0-9"+ "\$\#^\\|&.~<>@:+*_\(\)\[\]\{\}?!\t\s\['" + '=åäöÅÄÖ"-]'  ; $original = Get-clipboard ; $sanitized = $original -replace $regex,'' ; $sanitized | set-clipboard }

function Translate-Path {
  [CmdletBinding()]
  param (
    # The relative path
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $RelativePath,

    # The base directory`
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [string]
    $BaseDirectory
  )

  # Split the relative path by the "/" character`
  $PathSegments = $RelativePath.Split("/")

  # Set the current directory to the base directory`
  $CurrentDirectory = $BaseDirectory

  # Loop through each path segment`
  foreach ($Segment in $PathSegments) {
    # If the segment is "..", go up one level in the directory hierarchy`
    if ($Segment -eq "..") {
      $CurrentDirectory = Split-Path -Path $CurrentDirectory -Parent
    }
    # If the segment is ".git", stop the loop and append the rest of the path`
    elseif ($Segment -eq ".git") {
      break
    }
    # Otherwise, ignore the segment`
    else {
      continue
    }
  }

  # Get the index of the ".git" segment in the path segments`
  $GitIndex = [array]::IndexOf($PathSegments, ".git")

  # Get the rest of the path segments after the ".git" segment`
  $RestOfPath = $PathSegments[($GitIndex)..$PathSegments.Length]

  # Join the rest of the path segments by the "/" character`
  $RestOfPath = $RestOfPath -join "/"

  # Append the rest of the path to the current directory`
  $AbsolutePath = Join-Path -Path $CurrentDirectory -ChildPath $RestOfPath

  # Return the absolute path as a string`
  return "$AbsolutePath"
}
}
function Set-ErrorView {
    # Use the parameter attribute to make it mandatory and validate the input
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("NormalView", "CategoryView", "ConciseView")]
        [string]$ErrorView
    )

    # Set the ErrorView variable to the specified value
    $global:ErrorView = $ErrorView
}
function read-EnvPaths                          { ($Env:Path).Split(";") }
function read-uptime                            { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION=                                                                                                                                                                                                                                                                                 {$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?

function Invoke-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [string]$ArgumentList,
        [string]$WorkingDirectory
    )

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $FilePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $ArgumentList
    $pinfo.WorkingDirectory = $WorkingDirectory
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    # [pscustomobject]@{
    #     stdout = $p.StandardOutput.ReadToEnd()
    #     stderr = $p.StandardError.ReadToEnd()
    #     ExitCode = $p.ExitCode
    # }
}

function Get-Process-Command {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    Get-WmiObject Win32_Process -Filter "name = '$Name.exe'" -ErrorAction SilentlyContinue | Select-Object CommandLine,ProcessId
}

function Wait-For-Process {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Switch]$IgnoreExistingProcesses
    )

    if ($IgnoreExistingProcesses) {
        $NumberOfProcesses = (Get-Process -Name $Name -ErrorAction SilentlyContinue).Count
    } else {
        $NumberOfProcesses = 0
    }

    while ( (Get-Process -Name $Name -ErrorAction SilentlyContinue).Count -eq $NumberOfProcesses ) {
        Start-Sleep -Milliseconds 400
    }
}


Function im-pg {
	Import-Module posh-git
}



function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}
function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}



Function IIf($If, $IfTrue, $IfFalse) {
    If ($If) {If ($IfTrue -is "ScriptBlock") {&$IfTrue} Else {$IfTrue}}
    Else {If ($IfFalse -is "ScriptBlock") {&$IfFalse} Else {$IfFalse}}
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if ( $args.Count -eq 0 ) {
        Get-Childitem env:
    } elseif( $args.Count -eq 1 ) {
        Start-Process (Get-Command $args[0]).Source
    } else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}
function getProcess {
  Get-Process | Group-Object -Property ProcessName |
  Select-Object Count, Name,
  @{
    Name       = 'Memory usage(Total in MB)';
    Expression = { '{0:N2}' -f (($_.Group |
          Measure-Object WorkingSet -Sum).Sum / 1MB) }
  }
}

function Link-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }

    foreach ($type in @("Container", "Leaf")) {
        if (Test-Path -Path $target -PathType $type) {

            switch ($type) {
                "Container" {
                    try {

                        Write-Host "Linking folder ($( $path )) to ($( $target ))..."
                        New-Item -ItemType Junction -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "Error occurred while Linking folder '$( $target )':"
                        Write-Error "--- | $( $_ )"
                    }

                }
                "Leaf" {
                    try {
                        Write-Host "Linking file ($( $path )) to ($( $target ))..."
                        New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "Error occurred while Linking file '$( $target )':"
                        Write-Error "--- | $( $_ )"
                    }
                }
            }

            break
        }
    }

    Start-Sleep -Seconds 2
}

Function Create-Shortcut {
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$ShortcutPath,
		[Parameter(Mandatory = $true, Position = 1)]
		[string]$Target,
		[Parameter(Mandatory = $false, Position = 2)]
		[string]$Args
	)

    if (!(Test-Path -Path $Target)) {
		throw "The target file doesn't exist."
	}

	try {
		Write-Host "Creating shortcut for $( (Split-Path $Target -Leaf) )..."
		$shortcut_path = "$( $Path )"
		if (Test-Path -Path $shortcut_path) {
			Remove-Item -Path $shortcut_path -Recurse -Force -ErrorAction SilentlyContinue
		}

		$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut_path)
		$shortcut.TargetPath = $Target
		if ($ArgumentList) {
			$shortcut.Arguments = $ArgumentList
		}
		$shortcut.Save()

	}
	catch {
		Write-Warning "Error occurred while creating shortcut '$( $Path )':"
		Write-Error "--- | $( $_ )" -ForegroundColor Red
	}

}

function Download-File {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [string]$Destination
    )

	# if (!(Test-NetConnection www.google.com).PingSucceeded) { throw "No Internet Connection" }

    $tempFileName = ([System.IO.Path]::GetFileName($Url))
    $tempFile = Join-Path $ENV:TEMP $tempFileName

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Url -OutFile $tempFile

    if ($Destination) {
        if (!(Test-Path -Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination
        }

        $extension = [System.IO.Path]::GetExtension($tempFile)

        if ($extension -eq ".zip") {
            Expand-Archive -Path $tempFile -DestinationPath $Destination
        } else {
            Copy-Item -Path $tempFile -Destination $Destination -Recurse -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path $tempFile) {
            Remove-Item -Path $tempFile -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
## Which
function Which {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    Get-Command -Name $Command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}


function Set-ItemProperty-Verified {
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $Path,

        [string] $Name,

        [ValidateSet('Binary', 'DWord', 'ExpandString', 'MultiString', 'Qword', 'String', 'Unknown')]
        [string] $Type,

        $Value
    )

    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force >$null
    }

	if ($Name) {
		if ($Type) {
			Set-ItemProperty -Path "$Path" -Name "$Name" -Type $Type -Value $Value
		} else {
			Set-ItemProperty -Path "$Path" -Name "$Name" -Value $Value
		}
	}
}






function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($null -eq $k.VirtualKeyCode -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}   


# don't override chocolatey sudo or unix sudo
if ( -not $(Test-CommandExists 'sudo') ) {
    function sudo() {
        if ( $args.Length -eq 0 ) {
            Start-Process $(Get-HostExecutable) -verb "runAs"
        } elseif ( $args.Length -eq 1 ) {
            Start-Process $args[0] -verb "runAs"
        } else {
            Start-Process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
        }
    }
}

function Reopen-here { Get-Process explorer | Stop-Process Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"}

    if ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue)) {
function find-historyAppendClipboard($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard
function find-historyInvoke($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.
    }

function split-fileByLineNr 
{
 param( $pathName = '.\gron.csv',
 	$OutputFilenamePattern = 'output_done_' , 
	$LineLimit = 60) ;
  $ext = $pathName | split-path -Extension 
   $inputx = Get-Content ;
   $line = 0 ;
   $i = 0 ;
   $path = 0 ;
   $start = 0 ;
   while ($line -le $inputx.Length) {
        if ($i -eq $LineLimit -Or $line -eq $inputx.Length)
         {
        $path++ ;
      $pathname = "$OutputFilenamePattern$path$ext" ;
      $inputx[$start..($line - 1)] | Out -File $pathname -Force ;
      $start = $line ;
      $i = 0 ;
      Write-Host "$pathname" ;
      } 
   $i++ ;
   $line++ 
   }
}

function ConvertFrom-Bytes                      { param( [string]$bytes, [string]$savepath ) $dir = Split-Path $savepath if (!(Test-Path $dir))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { md $dir | Out-Null } [convert]::FromBase64String($bytes) | Set-Content $savepath -Encoding Byte }
function ConvertTo-Bytes ( [string]$path )      { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } [convert]::ToBase64String((Get-Content $path -Encoding Byte)) }

function foldercontain($folder,$name)           { $q = get-childitem $folder; return $q -contains $name }
function Get-DefaultAliases                     { Get-Alias | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_.Options -match "ReadOnly" }}
function get-envVar                             { Get-Childitem -Path Env:*}
function get-historyPath                        { (Get-PSReadlineOption).HistorySavePath }
function get-isFolder                           {$PSBoundParameters -is [system.in.folder]}
function get-parameters                         { read-paramNaliases @args }
function get-whatpulse                          { param( $program,$path) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $query = "select rightstr(path,instr(reverse(path),'/') -1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)" ; $adapter = newSqliteConnection -source (Everything 'whatpulse.db')[0] -query $query   ; $b=@($data.item('exe'))                                          ; $a = @($data.item('path'))                                   ; $i=0                                                                            ; while($i -lt $a.Length)                                                   {$res[$b[$i]]=$a[$i] ; $i++ }                                                                                 ; $res                        | where                                                                                                                                                                  { $_.name -match $program -and $_.path -match $path}}
function man                                    { Get-Help $args[0] | out-host -paging }
function md                                     { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function mkdir                                  { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function My-Scripts                             { Get-Command -CommandType externalscript }
function open-ProfileFolder                     { explorer (split-path -path $profile -parent)}
function pkill($name)                           { Get-Process $name -ErrorAction SilentlyContinue | kill }
function read-headOfFile                        { param( $linr = 10, $path ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" }  gc -Path $path  -TotalCount $linr }
function read-paramNaliases ($command)          { (Get-Command $command).parameters.values | select name, @{n='aliases';e={$_.aliases}} } 
function set-FileEncodingUtf8 ( [string]$path ) { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } sc $path -encoding utf8 -value(gc $path) }
function set-x                                  { Set-PSDebug -trace 2}
function set+x                                  { Set-PSDebug -trace 0}
function sort-PathByLvl                         { param( $inputList) $inputList                                                                                                                                                                                                                                          | Sort                                                                                                                                                                                                                                                                                                                                                                                   {($_ -split '\\').Count},                                                                                                                                                                                                                                                                                            {$_} -Descending                                       | select -object -first 2                                          | %                                                                                                                                                                                                                                                                                                                                                           { $error.clear()                                            ; try                                                                                                                                                                                                { out -null -input (test -ModuleManifest $_ > '&2>&1' ) } catch                                                                               { "Error" } ; if (!$error) { $_ } }}

Function Run-Cpp {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$file
  )

  # Strip extension
  if (($file -match "\.cpp$") -or [System.IO.File]::exists($file)) {
    $file = $file.Substring(0, $file.lastIndexOf('.'))
  }
  elseif (![System.IO.File]::exists((Get-ChildItem "$file").FullName)) {
    Write-Warning "File does not exist!"
    return
  }

  g++ "$file.cpp" -o "$file.exe";
  if ($?) {
    &.\"$file.exe"
  }
}

Function Run-Java {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$file
  )

  if (!($file -match "\.java$") -or ![System.IO.File]::exists((Get-ChildItem "$file").FullName)) {
    Write-Warning "File does not exist! >_< :: $file"
    return
  }
  
  $baseFile = $(Split-Path $file -Leaf)
  $class = $baseFile.Substring(0, $baseFile.lastIndexOf('.'))
  $directory = (Get-Item -Path $(Split-Path $file)).FullName
  
  # Compile
  javac -d "$directory" "$file"
  
  # Run
  java -cp "$directory" "$class"
}
 
<#
	Create shim to an executable. A "shim" acts as a proxy to an executable and works better than symlinks for binaries
	dependant on bundled DLLs for example.
	- Dependency: `scoop-shim` installed with `scoop`
	- Platform: Windows
#>
Function Create-Shim {
  Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$File,
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Alias
  )

   $EXEC_DIR = "${HOME}/bin/shims"
   $SCOOP_SHIM = "${HOME}/scoop/apps/scoop-shim/current/shim.exe"

   $execBase = if ($Alias) {"$Alias.exe"} Else {(Split-Path $File -Leaf)}

   Copy-Item $SCOOP_SHIM "$EXEC_DIR/$execBase"
   Out-File -FilePath "$EXEC_DIR/$($execBase.SubString(0, $execBase.lastIndexOf('.'))).shim" -InputObject "path = $((Get-ChildItem "$file").FullName)" 
}


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
function Spotify-UrlToPlaylist { $original = get-clipboard ; $transformed = $original.replace(“https://open.spotify.com/playlist/”, “spotify:user:spotify:playlist:”).replace(“?si=”, “=”) ; ($transformed -split '=')[0] | set-clipboard ; "done" }

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
function goto-profile { explorer ( $profile | split-path -parent ) }
function goto-history { explorer ( (Get-PSReadlineOption).HistorySavePath | split-path -parent ) }
