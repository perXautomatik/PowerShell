

# Helper Functions
#######################################################

# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue
# define these environment variables if not set already and also provide them as PSVariables




function retrive-FromCache {
    param(
	[Parameter(Mandatory=$true)]
	[string]$SearchString,

	[Parameter(Mandatory=$false)]
	[string]$externalPath
    )

	$cache = ( get-content "$env:appdata\Everything\Run History.csv" | ConvertFrom-Csv ) |
	% { [system.io.fileinfo] $_.filename } ; if($externalPath ) {$cache += [system.io.fileinfo] $externalPath } ;
	$cacheFullName = ($cache  | ? { ([system.io.fileinfo]$_ | Test-Path) } | ? {$_.name -eq $SearchString}).fullname ;

	$returnPath = if($cacheFullName) { $cacheFullName } else {if($(Test-CommandExists 'everything' )) { $searchRessults = (everything "wfn:$SearchString !\#"); if($searchRessults) {$searchRessults[0]}}}

	if( $returnPath) { if( Test-Path $returnPath[0] )  { return [string]$returnPath[0] } else  { return [string]"unable to set path to $searchString" } }
}






function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if($args.Count -eq 0){
	Get-Childitem env:
    }
    elseif($args.Count -eq 1) {
	Start-Process (Get-Command $args[0]).Source
    }
    else {
	Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
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

#if ( Test-IsInteractive )  { 	(preferably use -noLogo) } # Clear-Host # remove advertisements







#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}







function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($null -eq $k.VirtualKeyCode -or $i -Contains $k.VirtualKeyCode){
	$k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}

# native touch implementation
# src: https://ss64.com/ps/syntax-touch.html
function Set-FileTime {
    param(
	[string[]]$paths,
	[bool]$only_modification = $false,
	[bool]$only_access = $false
    )

    begin {
	function touchNewFile([string]$path) {
	    Set-Content -Path $path -value $null;
	}
	function updateFileSystemInfo([System.IO.FileSystemInfo]$fsInfo) {
	    $datetime = Get-Date
	    if ( $only_access ) {
		$fsInfo.LastAccessTime = $datetime
	    } elseif ( $only_modification ) {
		$fsInfo.LastWriteTime = $datetime
	    } else {
		$fsInfo.CreationTime = $datetime
		$fsInfo.LastWriteTime = $datetime
		$fsInfo.LastAccessTime = $datetime
	    }
	}

	function touchExistingFile($arg) {
	    if ( $arg -is [System.IO.FileSystemInfo] ) {
		    updateFileSystemInfo($arg)
		} else {
		$resolvedPaths = Resolve-Path $arg
		foreach ($rpath in $resolvedPaths) {
		    if ( Test-Path -type Container $rpath ) {
			$fsInfo = New-Object System.IO.DirectoryInfo($rpath)
		    } else {
			$fsInfo = New-Object System.IO.FileInfo($rpath)
		    }
		    updateFileSystemInfo($fsInfo)
		}
	    }
	}

	    #$null > $path
    }

    process {
	if ( $_ ) {
	    if ( Test-Path $_ ) {
		touchExistingFile($_)
	    } else {
		touchNewFile($_)
	    }
	}
    }

    end {
	if ( $paths ) {
	    foreach ( $path in $paths ) {
		if ( Test-Path $path ) {
		    touchExistingFile($path)
		} else {
		    touchNewFile($path)
		}
	    }
	}
    }
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






function unzipf ($path) {
	$dirname = (Get-Item $path).Basename
	echo("Extracting", $path, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $path -OutputPath $dirname -ShowProgress
}





function split-fileByLineNr { param( $pathName = '.\gron.csv',$OutputFilenamePattern = 'output_done_' , $LineLimit = 60) ;
$ext = $pathName | split-path -Extension
 $inputx = Get-Content ;
 $line = 0 ;
 $i = 0 ;
 $path = 0 ;
 $start = 0 ;
 while ($line -le $inputx.Length) {
      if ($i -eq $LineLimit -Or $line -eq $inputx.Length) {
    $path++ ;
    $pathname = "$OutputFilenamePattern$path$ext" ;
    $inputx[$start..($line - 1)] | Out -File $pathname -Force ;
    $start = $line ;

    $i = 0 ;
    Write-Host "$pathname" ;
    } ;
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

if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin { if ($isWindows)
    {
	 $user = [Security.Principal.WindowsIdentity]::GetCurrent();
	return ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) ??  $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } }


    function start-bc ($REMOTE,$LOCAL,$BASE,$MERGED) { cmd /c "${Env:ProgramFiles}\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED" } #todo: replace hardcode with global variable pointing to path
    function new-SymbolicLink { param ( $where = 'H:\mina grejer\Till Github' ,$from = 'H:\mina grejer\Project shelf\Till Github' ) New-Item -Path $where -ItemType SymbolicLink -Value $from }

}

    if (Test-CommandExists 'git')
    { #todo: move to git aliases
	Function invoke-GitLazy($path,$message) { cd $path ; git lazy $message } ;
	Function invoke-GitLazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout
function git-root {
    $gitrootdir = (git rev-parse --show-toplevel)
    if ($gitrootdir) {
	Set-Location $gitrootdir
    }
}

}

    }

    if ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue)) {
	function find-historyAppendClipboard($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard
	function find-historyInvoke($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.
    }

#function aliasCode { & $env:code }

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
function Get-HostExecutable {
    if ( $PSVersionTable.PSEdition -eq "Core" ) {
	$ConsoleHostExecutable = (get-command pwsh).Source
    } else {
	$ConsoleHostExecutable = (get-command powershell).Source
    }
    return $ConsoleHostExecutable
}
return $ConsoleHostExecutable
}
function Get-ExitBoolean($command) { & $command | Out-Null; $?} ; Set-Alias geb   Get-ExitBoolean # fixed: https://github.com/PowerShell/PowerShell/pull/9849
function printpath {
	($Env:Path).Split(";")
}
# Runs all .ps1 files in this module's directory
function LoadAllChildPs1 {Get-ChildItem -Path $PSScriptRoot\*.ps1 | ? name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }}
function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}
function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}
function ConvertFrom-Bytes                      { param( [string]$bytes, [string]$savepath ) $dir = Split-Path $savepath if (!(Test-Path $dir))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { md $dir | Out-Null } [convert]::FromBase64String($bytes) | Set-Content $savepath -Encoding Byte }
function ConvertTo-Bytes ( [string]$path )      { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } [convert]::ToBase64String((Get-Content $path -Encoding Byte)) }

function get-historyPath                        { (Get-PSReadlineOption).HistorySavePath }
function get-isFolder                           {$PSBoundParameters -is [system.in.folder]}
function get-parameters                         { Get-Member -Parameter *}
function Initialize-Profile                     { . $PROFILE.CurrentUserCurrentHost} #function initialize-profile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { & $profile } #reload-profile is an unapproved verb.
function invoke-Nmake                           { nmake.exe $args -nologo }; # 1. 编译函数 make
function md                                     { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function mkdir                                  { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function My-Scripts                             { Get-Command -CommandType externalscript }
function open-ProfileFolder                     { explorer (split-path -path $profile -parent)}
function pkill($name)                           { Get-Process $name -ErrorAction SilentlyContinue | kill }
#-------------------------------    Functions END     -------------------------------