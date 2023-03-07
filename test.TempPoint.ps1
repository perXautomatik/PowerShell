<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.208
	 Created on:   	2022-08-02 17:22
	 Created by:   	Användaren
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>



. 'C:\Users\Användaren\Documents\WindowsPowerShell\Snipps\initiateFolders.ps1'

DirManual -path "H:\Vortex Mods\diablo2resurrected\mods" -depth 3 -find 'data' -dontParse '.git' -maxDur 10