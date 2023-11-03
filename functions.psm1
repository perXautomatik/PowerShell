

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
