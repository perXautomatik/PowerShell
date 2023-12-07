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

function split-fileByMatch($pathName , $regex) { #param( $pathName = 'C:\Users\crbk01\Documents\WindowsPowerShell\snipps\Modules\Todo SplitUp.psm1' , $regex = '(?<=function\s)[^\s\(]*') ;
 $ext = ($pathName | split-path -Extension)
 $parent = ($pathName | split-path -Parent)
 $OriginalName = ($pathName | split-path -LeafBase)
 $inputx = Get-Content $pathName; $line = 0 ; $i = 0 ; $start = @(select-string -path $pathName -pattern $regex ) | select linenumber ; $LineLimit = $start | select -Skip 1 ; $names = @() ; [regex]::matches($inputx,$regex).groups.value | %{$names+= $_ }
 $occurence = 0 ;
 

 while ($line -le $inputx.Length) {
    if ($i -eq ([int]$LineLimit[$occurence].linenumber -1) -Or $line -eq $inputx.Length) 
    {    
        $currentName = $names[$occurence];
        $pathname = Join-Path -path $parent -childPath "$OriginalName-$currentName$ext" ;
        $u = ([int]$start[$occurence].linenumber -1)
    
        $inputx[$u..($line - 1)] > $pathname
    
        $occurence++ ; 
        Write-Host "$u..($line - 1)$pathname" ;
    };
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

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ( $gitrootdir ) {
            Set-Location $gitrootdir
        }
    }
