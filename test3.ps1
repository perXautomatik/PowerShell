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
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
. '\\100.84.7.151\NetBackup\Project Shelf\ToGit\PowerShellProjectFolder\scripts\TodoProjects\Tokenization.ps1'

$fileLines = get-content "$home\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
$line = ''; $fileLines | select -last 2 | %{ $line = $_ ; $i = 0; $tokenz = @($line | %{TokenizeCode $_ } ) ; $tokenz } | select content,type


<#
* treat each indevidual line as a branch
* use tokenization to identify the commits each branch consists of
* set branch name according to some rule, like if first = command and content = choco and second content = install, then branch name = [2..3] content 
* on branch name conflict, que line for interactive rebase.
* detect branch conflict afterwards, and que for intereactive rebase.
* during rebase, trye to guestimate commits that can be autodiscarded, by simply saying, if commit and commit message and commit sequence is same, discard one branches changes, and start from there, no need to make indevidual changes.
#>

