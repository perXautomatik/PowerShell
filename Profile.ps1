
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }
if ( -not $IsWindows ) { function Test-IsAdmin { if ( (id -u) -eq 0 ) { return $true } return $false } }  



function Test-CommandExists {
#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
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



if ( $PSVersionTable.PSVersion.Major -lt 7 ) { # hacks for old powerhsell versions
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	function Get-ExitBoolean($command) { & $command | Out-Null; $?} ; Set-Alias geb   Get-ExitBoolean # fixed: https://github.com/PowerShell/PowerShell/pull/9849

	function Use-Default # $var = d $Value : "DefaultValue" eg. ternary # fixed: https://toastit.dev/2019/09/25/ternary-operator-powershell-7/
	{
	    for ($i = 1; $i -lt $args.Count; $i++){
	        if ($args[$i] -eq ":"){
	            $coord = $i; break
	        }
	    }
	    if ($coord -eq 0) {
	        throw new System.Exception "No operator!"
	    }
	    if ($args[$coord - 1] -eq ""){
	        $toReturn = $args[$coord + 1]
	    } else {
	        $toReturn = $args[$coord -1]
	    }
	    return $toReturn
	}
	Set-Alias d    Use-Default
}


if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin { $user = [Security.Principal.WindowsIdentity]::GetCurrent(); return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); }

    function Reopen-here { Get-Process explorer | Stop-Process Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"}

    function Reset-Spooler { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Stop-Service -Name Spooler -Force; Get-Item ${env:SystemRoot}\System32\spool\PRINTERS\* | Remove-Item -Force -Recurse; Start-Service -Name Spooler'" -verb "runAs"    }

    function subl { Start-Process "${Env:ProgramFiles}\Sublime Text\subl.exe" -ArgumentList $args -WindowStyle Hidden # hide subl shim script }

    function get-tempfilesNfolders { foreach ($folder in @('C:\Windows\Temp\*', 'C:\Documents and Settings\*\Local Settings\temp\*', 'C:\Users\*\Appdata\Local\Temp\*', 'C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*', 'C:\Windows\SoftwareDistribution\Download', 'C:\Windows\System32\FNTCACHE.DAT')) {$_}  }
    function Export-Regestrykey { param ( $reg = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\' ,$outFile = 'H:\hkcu-regbackup.txt' ) get-childitem -path $reg | out-file $outFile }

    function start-bc ($REMOTE,$LOCAL,$BASE,$MERGED) { cmd /c "${Env:ProgramFiles}\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED" } #todo: replace hardcode with global variable pointing to path
    function start-cygwin { param ( $cygwinpath = "${Env:ProgramFiles}\cygwin64\" ) ."$cygwinpath\Cygwin.bat" }

    function Compare-ImagesMetadata { param ( $exifToolPath = "${Env:ProgramFiles}\geosetter\tools\" ,$inputA = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front (2).jpg" ,$inputB = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front.jpg" ) ; $set1 = .\exiftool.exe -a -u -g1  $inputA ; $set2 = .\exiftool.exe -a -u -g1  $inputB ; Compare-Object $set1 $set2 | select -ExpandProperty inputobject }
    function new-SymbolicLink { param ( $where = 'H:\mina grejer\Till Github' ,$from = 'H:\mina grejer\Project shelf\Till Github' ) New-Item -Path $where -ItemType SymbolicLink -Value $from }

}

if (Test-CommandExists 'search-Everything')
{ 
    function invoke-Everything([string]$filter) { @(Search-Everything  -filter $filter -global) }
    function invoke-FuzzyWithEverything($searchstring) { menu @(everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution
}

if (Test-CommandExists 'git')
{ #todo: move to git aliases
    function invoke-gitCheckout () { & git checkout $args }
    function invoke-gitFetchOrig { git fetch origin }
    Function invoke-GitLazy($path,$message) { cd $path ; git lazy $message } ; 
    Function invoke-GitLazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout
    function invoke-gitRemote { param ($subCommand = 'get-url',$name = "origin" ) git remote $subCommand $name }
    Function invoke-GitSubmoduleAdd([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch
}

if ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue)) {
    function find-historyAppendClipboard($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard
    function find-historyInvoke($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.
}




function invoke-powershellAsAdmin { Start-Process powershell -Verb runAs } #new ps OpenAsADmin
function ConvertFrom-Bytes { param ( [string]$bytes, [string]$savepath ) $dir = Split-Path $savepath if (!(Test-Path $dir)) { md $dir | Out-Null } [convert]::FromBase64String($bytes) | Set-Content $savepath -Encoding Byte }
function ConvertTo-Bytes ( [string]$file ) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" } [convert]::ToBase64String((Get-Content $file -Encoding Byte)) }
function string { process { $_ | Out-String -Stream } }
function Initialize-Profile {. $PROFILE.CurrentUserCurrentHost} #function initialize-profile { & $profile } #reload-profile is an unapproved verb.
function set-x { Set-PSDebug -trace 2}
function set+x { Set-PSDebug -trace 0}
function exit-Nrenter { shutdown /r } #reboot
function set-FileEncodingUtf8 ( [string]$file ) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" } sc $file -encoding utf8 -value(gc $file) }
function read-pathsAsStream { get-childitem | out-string -stream } # filesInFolAsStream ;
function read-aliases { Get-Alias | Where-Object { $_.Options -notmatch "ReadOnly" }}
function read-childrenAsStream { get-childitem | out-string -stream }
function read-EnvPaths { ($Env:Path).Split(";") }
function read-headOfFile { param ( $linr = 10, $file ) gc -Path $file  -TotalCount $linr }
function read-json { param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $input ) $json = [ordered]@{}; ($input).PSObject.Properties | % { $json[$_.Name] = $_.Value } $json.SyncRoot }
function read-paramNaliases ($command) { (Get-Command $command).parameters.values | select name, @{n='aliases';e={$_.aliases}} }
function measure-ExtOccurenseRecursivly { param ( $path = "D:\Project Shelf\MapBasic" ) Get-ChildItem -Path $path -Recurse -File | group Extension -NoElement  | sort Count -Descending | select -Property name }

#-------------------------------    Functions END     -------------------------------


if ( Test-IsInteractive ) {
# Clear-Host # remove advertisements (preferably use -noLogo)
#-------------------------------   Set alias BEGIN    -------------------------------



# bash-like
Set-Alias cat                                        Get-Content -Option AllScope
Set-Alias cd                                         Set-Location -Option AllScope
Set-Alias clear                                      Clear-Host -Option AllScope
Set-Alias cp                                         Copy-Item -Option AllScope
Set-Alias history                                    Get-History -Option AllScope
Set-Alias kill                                       Stop-Process -Option AllScope
Set-Alias lp                                         Out-Printer -Option AllScope
Set-Alias mv                                         Move-Item -Option AllScope
Set-Alias ps                                         Get-Process -Option AllScope
Set-Alias pwd                                        Get-Location -Option AllScope
Set-Alias which                                      Get-Command -Option AllScope
                        
Set-Alias open                                       Invoke-Item -Option AllScope
Set-Alias basename                                   Split-Path -Option AllScope
Set-Alias realpath                                   Resolve-Path -Option AllScope
                        
# cmd-like                               
Set-Alias rm                                         Remove-Item -Option AllScope
Set-Alias rmdir                                      Remove-Item -Option AllScope
Set-Alias echo                                       Write-Output -Option AllScope
Set-Alias cls                                        Clear-Host -Option AllScope
                        
Set-Alias chdir                                      Set-Location -Option AllScope
Set-Alias copy                                       Copy-Item -Option AllScope
Set-Alias del                                        Remove-Item -Option AllScope
Set-Alias dir                                        Get-Childitem -Option AllScope
Set-Alias erase                                      Remove-Item -Option AllScope
Set-Alias move                                       Move-Item -Option AllScope
Set-Alias rd                                         Remove-Item -Option AllScope
Set-Alias ren                                        Rename-Item -Option AllScope
Set-Alias set                                        Set-Variable -Option AllScope
Set-Alias type                                       Get-Content -Option AllScope
Set-Alias env                                        Get-Environment -Option AllScope

# custom aliases

Set-Alias touch                                      Set-FileTime -Option AllScope

set-alias filesinfolasstream			             read-childrenAsStream  -Option AllScope
set-alias bcompare						             start-bc   -Option AllScope

set-alias GitAdEPathAsSNB			            	 invoke-GitSubmoduleAdd  -Option AllScope
set-alias GitUp						                 invoke-GitLazy  -Option AllScope
set-alias gitSilently				            	 invoke-GitLazySilently  -Option AllScope
set-alias gitSingleRemote			            	 invoke-gitFetchOrig  -Option AllScope
set-alias executeThis				            	 invoke-FuzzyWithEverything  -Option AllScope

set-alias everything				            	 invoke-Everything  -Option AllScope
set-alias MyAliases					                 read-aliases  -Option AllScope
set-alias OpenAsADmin				            	 invoke-powershellAsAdmin  -Option AllScope
set-alias home						             	 open-here  -Option AllScope
set-alias pastDo					            	 find-historyInvoke  -Option AllScope
set-alias pastDoEdit				            	 find-historyAppendClipboard  -Option AllScope
set-alias HistoryPath				            	 (Get-PSReadlineOption).HistorySavePath  -Option AllScope
set-alias reboot					            	 exit-Nrenter  -Option AllScope
set-alias df						             	 get-volume  -Option AllScope
set-alias printpaths				            	 read-EnvPaths  -Option AllScope
set-alias reload					            	 initialize-profile  -Option AllScope
set-alias uptime					            	 read-uptime  -Option AllScope

set-alias gremote 					            	 invoke-gitRemote  -Option AllScope

#-------------------------------    Set alias END     -------------------------------

} # is interactive end
Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"

} # interactive test close
