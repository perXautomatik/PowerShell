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


content[1] = 'choco'
c = $true
$isAdmin = $false

switch ($true)
{
	$isEnabled
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