$BasePath = "C:\NuGetRoot\NugetServer"
$folders = gci "$BasePath\*\Packages\..\*.nupkg" -Recurse
$(foreach ($folder in $folders|group @{e={$_.fullname.split('\')[0..3] -join '\'}}) {
    [pscustomobject]@{
        ServerName=$env:COMPUTERNAME
        ProjectGroupID = Split-Path $folder.Name -Leaf
        NuGetPackageCount = $folder.group.Where({$_.Directory -match 'Packages'}).count
        AverageSize = $folder.Group | measure-object -property length -average | Select -Expand Average
    }
}) | Export-CSV d:\monitoring\NugetStatistics -NoType -Append
