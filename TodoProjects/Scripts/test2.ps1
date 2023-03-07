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


. 'C:\Users\Användaren\Documents\WindowsPowerShell\Snipps\fasterDirSearch.ps1'

$remote = 'C:\Program Files (x86)\Diablo II Resurrected\mods\cbVanillaMerged\cbVanillaMerged.mpq\data\.git'

DirManual -path "H:\Vortex Mods\diablo2resurrected\mods" -depth 4 -find '.git' -maxDur 10 | % { $_.fullname -replace ('\\.git', '') } | % { cd $_; $branchName = ($_ -split ('\\'))[-2] -replace ('.mpq', '') -replace ('[^a-z]', '_'); echo $branchName; git checkout master; git branch -m $branchName; git push $remote $branchName --force }





#$initial = (Get-ChildItem -Directory -Exclude '.git' | Get-ChildItem -Directory -Exclude '.git' | Get-ChildItem -Directory -Exclude '.git' | ? { $_.Name -eq 'data' }) | select fullname


#$progress = @($initial | ? { !((Get-ChildItem -Path $_.fullname -Directory) -match '.git') })


#[float]$progress.length / [float]$initial.length

#$progress | % { cd $_.fullname; git init; git add -A; git commit -m 'initial' }
