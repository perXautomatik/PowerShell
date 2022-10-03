$root = 'D:\Project Shelf\PowerShellProjectFolder\scripts'
cd $root
Get-Clipboard | ? {$_ -ne $null} | %{ 
$arelative = ($_ -split([regex]::Escape('(from')))[0].ToString().Trim()
$brelative = (($_ -split([regex]::Escape('(from')))[1] -split('[)][\s\t]{1,}') )[0].ToString().Trim()
[pscustomobject]@{
a = Resolve-Path -path $arelative 
b = Resolve-Path -path $brelative
brelative = $brelative
arelative = $arelative
}
#resolve path only returns if path exsists
} | ? { $_.a -ne $null -and $_.b -ne $null } | % { git rm $_.arelative }


