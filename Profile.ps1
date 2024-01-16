function ImportWithPriority { 
    param ( 
    # A hash table for the priority order of file names 
    [hashtable]$Prioritize, 
    # A default value for the lowest priority 
    [int] $PriorityMinimum = 10,
    [string] $pathx = $PSScriptRoot,
    [string[]]$exc = @('Scripts','Snipps') 
     )

	    # Get all .psm1 files in the current script root
	    $d = Get-ChildItem -Path $pathx\*.psm1 -Recurse -Exclude $exc

	    # Sort the files by their priority values
	    $d = $d | Sort-Object -Property { if ($Prioritize.ContainsKey($_.Name)) { $Prioritize[$_.Name] } else { $PriorityMinimum } }

	    # Import each module and write a message
	    $d | Foreach-Object {
	        import-module -name $_.FullName 
	        Write-Host "loaded:" + $_.FullName 
	    }

}

$priority = @{ “functions.psm1” = 1; "ModuleHelpers.psm1" = 2  ; “prompt.psm1” = 3 };
$excc = @("prompt.psm1")

ImportWithPriority -pathx "$PSScriptRoot\_Helpers" -prioritize $priority
ImportWithPriority -pathx "$PSScriptRoot\_Modules" -prioritize $priority
ImportWithPriority -pathx "$PSScriptRoot\_Configurators" -prioritize $priority -exc $excc
ImportWithPriority -pathx "$PSScriptRoot\_Overriding" -prioritize $priority


function dotSource {
 param ( # An optional list of file names to filter 
 [string[]]$List)

	# Get all the .ps1 files in the current script root
	$u = Get-ChildItem -Path $PSScriptRoot\*.ps1

	# Filter the files by the list parameter
	$u = $u | Where-Object { $List -contains $_.Name }

	# Sort the files by their priority values
	$u = $u | Sort-Object -Property { if ($Priority.ContainsKey($_.Name)) { $Priority[$_.Name] } else { $lastPriortity } }

	# Dot-source each file and write a message
	$u | Foreach-Object {
	    & $_.FullName
	    Write-Host "executed:" + $_ 
	}

}

dotsource -list @(‘PsReadLineInitial.ps1’)

<#import Aliases#>
#Import-Alias -Path profileAliases.txt

