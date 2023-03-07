<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.208
	 Created on:   	2022-07-31 18:32
	 Created by:   	Användaren
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

$dx = 'C:\Users\Användaren\Documents\Klei\Diablo II Resurrected\mods\Merged'
cd $dx
. 'D:\ToGit\PowerShell-Scripts\Scripts\TodoProjects\bytes\TodoDiablo2.ps1';
$commitMes = 'movedTosepareFolders'
$q = ''; $first = ''

function falseOnEmpty
{
	param ([ValidateNotNullOrEmpty()]$object)
	if ($object)
	{ return $true }
	else
	{
		return $false
	}
	
}

if ($null -eq $q)
{
	Get-ChildItem -File | %{
		
		$x = $_.basename -replace ('[_\d]', '');
		
		if (!($first -eq $x) -and !($first -eq ''))
		{
			git add -A; git commit -am "$commitMes"
		}
		$first = $x
		
		
		$newFolder = (Join-Path -Path $dx -child $x);
		
		if (!(Test-Path $newFolder))
		{ New-Item -Name $x -ItemType dir -Path $dx };
		
		if ((Test-Path $newFolder))
		{ Move-Item -Path $_.FullName -Destination $newFolder }
		
	}
	
	Get-ChildItem -Directory | %{
		$y = $_.basename
		git subtree split --prefix=$y -b $y; git rm -rf $y; git add -A; git commit -am "removing $y folder"
	}
		
}

$q = @(git branch)
$q | ? { $_ -notmatch '[_//]' } |
%{
	$z = $_.trim();
	;
	$string = ''
	echo "trying to checkout $z"

	Try
	{
		$p = out-null -input (git checkout $z 2>&1 )
		
		echo "checked out: $z"
		
		if (($p.exitcode -ne 0) -and !($p -eq $null))
		{
			Write-Error "exitcode: $p.exitcode"
		}
	}
	
	Catch { Write-Error "oops"; $_.Exception }
	
	$mes = git log -1 --pretty=%B
	
	echo "last message: $mes"; 	if ($mes -eq $commitMes) {[bool]$lastMesRelevant = $true} else {[bool]$lastMesRelevant = $false}
	
	
	if ($lastMesRelevant)
	{
		echo "bout to ammend"
		$m = (Get-ChildItem -Path "$PWD\*" -exclude *.key, *.d2x, *.ma*, .git, *.ctl | read-d2s | group name, lvl, characterclass, itemsSize | sort lcl, name -Descending | select -first 1);
		$m
		if (falseOnEmpty $m.name)
		{ git commit --amend -m $m.name }
		else
		{echo "ammend failed"}
		$M
		
	}
	
	
	sleep -Seconds 1
}



# %{ $x = $_.trim(); git submodule add -b ($x) -- $pwd "$x" }
