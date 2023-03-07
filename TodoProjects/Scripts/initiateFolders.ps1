<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.208
	 Created on:   	2022-08-01 20:09
	 Created by:   	Användaren
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#$getfilesbat = "C:\Users\Användaren\Documents\WindowsPowerShell\Snipps\GETFILES.bat"

#$files = ("cmd /c $getfilesbat $filemask" )
#Start-Process "cmd.exe " "/c $getfilesbat $filemask"
#$files = 
#$files = & "C:\Users\Användaren\Documents\WindowsPowerShell\Snipps\GETFILES.bat"
#$files.length
#$files
function dirQ ($pathx)
{
	$res = (Invoke-Expression 'cmd.exe /c for %%a in ( DIR /Ad /b "$pathx" ) do ( if "!exclude:/%%~Na/=!" equ "/.git/" ( %%a ))')
	
	$res
}

cd "H:\Vortex Mods\diablo2resurrected\mods"
#$res = (Invoke-Expression 'cmd.exe /c for %a in ( DIR ) do ( if "!exclude:/%%~Na/=!" equ "/.git/" ( %%a ))')

#$res
function DirManual()
{
	param (
		[int32]$depth = 1,
		[AllowNull()][string]$dontParse,
		[AllowNull()][string]$find,
		[Parameter(ValueFromPipeline)]
		[validatenotnullOrempty()]
		[string]$path = '.\',
		[float]$maxDur,
		[timespan]$window
		
	)
	$res = (Invoke-Expression 'cmd.exe /c dir "$path"')
	
	#$res = @(Get-ChildItem -Path $Path -Exclude $dontParse)
	$endTime = New-TimeSpan -seconds $maxdur
	$todo = $res.Length
	$i=0
	
	while ($endTime -gt (New-TimeSpan) -and ($i -lt $todo))
	{
		$q = $res[$i++]
	
		If ($q.Name -like $find)
		{
			$q
		}
		ElseIf ($q.PSIsContainer -and $depth -gt 1)
		{
			DirManual -Path $q.FullName -dontParse $dontParse -find $find -depth ($depth - 1) -window $endTime
		} # End If-ElseIf.
		$q.name
	
	}
	
	exit
}



$initial = (Get-ChildItem -Directory -Exclude '.git' | Get-ChildItem -Directory -Exclude '.git' | Get-ChildItem -Directory -Exclude '.git' | ? {$_.Name -eq 'data'}) | select fullname


$progress = @( $initial | ? { !((Get-ChildItem -Path $_.fullname -Directory ) -match '.git') } )


[float]$progress.length  / [float]$initial.length

$progress | % { cd $_.fullname; git init; git add -A; git commit -m 'initial' }



