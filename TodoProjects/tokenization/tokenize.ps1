<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.208
	 Created on:   	2022-08-04 17:30
	 Created by:   	Användaren
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

. '\\100.84.7.151\NetBackup\Project Shelf\ToGit\PowerShellProjectFolder\scripts\TodoProjects\Tokenization.ps1'

$fileLines = get-content 'C:\Users\crbk01\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt'
$line = ''; $fileLines | select -last 2 | %{ $line = $_ ; $i = 0; $tokenz = @($line | %{TokenizeCode $_ } ) ; $tokenz }

TokenizeHistory2 