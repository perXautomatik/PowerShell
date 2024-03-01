function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}
set-alias -name uptime -value uptimef

function reload-profile {
	& $profile
}
set-alias -name reload-profile -value reloadProfile

function print-path {
	($Env:Path).Split(";")
}
set-alias -name print-path -value printpath

# filesInFolAsStream ;
function aliasfilesInFolAsStream {
	get-childitem | out-string -stream
}
set-alias -Name filesinfolasstream -Value aliasfilesInFolAsStream

#new ps OpenAsADmin
function aliasopenasadminf {
	Start-Process powershell -Verb runAs
}

set-alias -Name OpenAsADmin -Value aliasopenasadminf

Function aliasEFunc {Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | Where{ $_ -notmatch 'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' }}  ;
set-alias -name EveryGitRepo -Value aliasEFunc

Function aliasEGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ;
set-alias -name gitSilently -Value aliasEGSfunc

Function aliasEGSRfunc
{
	out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ;
	 %{$proc -split '\n'} | %{ $properties = $_ -split '[\t\s]';
	  $remote = try{ New-Object PSObject -Property @{ name = $properties[0].Trim();
	    url = $properties[1].Trim();  type = $properties[2].Trim() } } catch {'noRemote'} ;
	     $remote | select-object -first 1 | select url}
	  } ;
set-alias -name gitSingleRemote -Value aliasEGSRfunc

function aliasFunctionEverything([string]$filter)
	{Search-Everything -filter $filter -global}

set-alias -name code -value '& $env:code'

set-alias -name everything -value aliasFunctionEverything

function aliasPshellHistoryPath {
	(Get-PSReadlineOption).HistorySavePath
}
set-alias -name pshelHistorypath -value aliasPshellHistoryPath

function aliasPastDo($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ }
}

set-alias -name pastDo -value aliasPastDo

function aliasPastDoEdit($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }
}

set-alias -name pastDoEdit -value aliasPastDoEdit

function aliasExecuteThis($searchstring) {
menu @(everything "ext:exe $searchString") | %{& $_ }
}

set-alias -name executeThis -value aliasExecuteThis


function aliasMyAliases {
Get-Alias -Definition alias* | select name
}

set-alias -name MyAliases -value aliasMyAliases

#Git Ad $leaf as submodule from $remote and branch $branch
Function aliasEFuncGT([string]$leaf,[string]$remote,[string]$branch)
{
 git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch
 } ;
set-alias -name GitAdEPathAsSNB -value aliasEFuncGT

Function aliasEGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ;
set-alias -name GitUp -value aliasEGLp
function aliasrb {
shutdown /r
}
set-alias -Name reboot -Value aliasrb

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}

function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}


function set-x {
    Set-PSDebug -trace 2
}

function set+x {
    Set-PSDebug -trace 0
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
Set-Alias env        Get-Environment -Option AllScope

function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }

if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ( $gitrootdir ) {
            Set-Location $gitrootdir
        }
    }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args
            }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim {
           . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`'
        }

        if ( -Not (Test-CommandExists 'sh') ){
            Set-Alias sh   git-sh -Option AllScope
        }

        if ( -Not (Test-CommandExists 'bash') ){
            Set-Alias bash   git-bash -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vi') ){
            Set-Alias vi   git-vim -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vim') ){
            Set-Alias vim   git-vim -Option AllScope
        }
    }
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

function gj { Get-Job | select id, name, state | ft -a }
function sj ($id = '*') { Get-Job $id | Stop-Job; gj }
function rj { Get-Job | ? state -match 'comp' | Remove-Job }

	function man                                    { Get-Help $args[0] | out-host -paging }

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($k.VirtualKeyCode -eq $null -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}

	function Initialize-Profile 			        {. $PROFILE.CurrentUserCurrentHost} #function initialize-profile { & $profile } #reload-profile is an unapproved verb.

if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }

    function Restart-Explorer {
        Get-Process explorer | Stop-Process
        Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"
    }
}
function Get-HostExecutable {
    if ( $PSVersionTable.PSEdition -eq "Core" ) {
        $ConsoleHostExecutable = (get-command pwsh).Source
    } else {
        $ConsoleHostExecutable = (get-command powershell).Source
    }
    return $ConsoleHostExecutable
}

# https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Start-PsElevatedSession { 
    # Open a new elevated powershell window
    if (!(Test-Administrator)) {
        if ($host.Name -match 'ISE') {
            start PowerShell_ISE.exe -Verb runas
        } else {
            start powershell -Verb runas -ArgumentList $('-noexit ' + ($args | Out-String))
        }
    } else {
        Write-Warning 'Session is already elevated'
    }
} 
Set-Alias -Name su -Value Start-PsElevatedSession

#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

function Get-ModulesAvailable {
    if ( $args.Count -eq 0 ) {
        Get-Module -ListAvailable
    } else {
        Get-Module -ListAvailable $args
    }
}

function Get-ModulesLoaded {
    if ( $args.Count -eq 0 ) {
        Get-Module -All
    } else {
        Get-Module -All $args
    }
}

function TryImport-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Import-Module $args}
    catch { }
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

# don't override chocolatey sudo or unix sudo
if ( -not $(Test-CommandExists 'sudo') ) {
    function sudo() {
		# http://www.lavinski.me/my-powershell-profile/
		function Elevate-Process {
		    $file, [string]$arguments = $args
		    $psi = new-object System.Diagnostics.ProcessStartInfo $file
		    $psi.Arguments = $arguments
		    $psi.Verb = 'runas'

		    $psi.WorkingDirectory = Get-Location
		    [System.Diagnostics.Process]::Start($psi)
		}

        if ( $args.Length -eq 0 ) {
            Elevate-Process $(Get-HostExecutable) 
        } elseif ( $args.Length -eq 1 ) {
            Elevate-Process $args[0] 
        } else {
            Elevate-Process $args[0] -ArgumentList $args[1..$args.Length]
        }
    }
}
	function My-Scripts                             { Get-Command -CommandType externalscript }
	function open-ProfileFolder                     { explorer (split-path -path $profile -parent)}
	
	function get-envVar                             { Get-Childitem -Path Env:*}
	function get-historyPath                        { (Get-PSReadlineOption).HistorySavePath }
	function get-parameters                         { Get-Member -Parameter *}
	function read-EnvPaths	 			            { ($Env:Path).Split(";") }
	function sort-PathByLvl                         { param( $inputList) $inputList                                                                                                                                                                                                                                          | Sort                                                                                                                                                                                                                                                                                                                                                                                   {($_ -split '\\').Count},                                                                                                                                                                                                                                                                                            {$_} -Descending                                       | select -object -first 2                                          | %                                                                                                                                                                                                                                                                                                                                                           { $error.clear()                                            ; try                                                                                                                                                                                                { out -null -input (test -ModuleManifest $_ > '&2>&1' ) } catch                                                                               { "Error" } ; if (!$error) { $_ } }}
	function which($name) 				            { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more

function sanitize-clipboard { $regex = "[^a-zA-Z0-9"+ "\$\#^\\|&.~<>@:+*_\(\)\[\]\{\}?!\t\s\['" + '=åäöÅÄÖ"-]'  ; $original = Get-clipboard ; $sanitized = $original -replace $regex,'' ; $sanitized | set-clipboard }
<# example : 
	Get-Process | Select-Value -Value "explorer.exe"
	#>
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

