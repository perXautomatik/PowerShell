<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.208
	 Created on:   	2022-08-04 18:23
	 Created by:   	Användaren
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


Content                                                                    Type
-------                                                                    ----
choco                                                                   Command
install                                                         CommandArgument
dotnet-6.0-runtime                                              CommandArgument


$param1 = content[1] -eq 'choco'
$param2 = content[2] -eq 'install'
$param3 = content[3] -ne $null
$ressult = content[2..3]

switch ($true)
{
	$param
	{
		'Do-Action'
		$isVisible = $true
	}
	$isVisible
	{
		'Show-Animation'
	}
	$isAdmin
	{
		'Enable-AdminMenu'
	}
}