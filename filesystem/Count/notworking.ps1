$folders = gci C:\NuGetRoot\NugetServer -Directory
foreach ($folder in $folders) {
    @{ServerName=$env:COMPUTERNAME;
        ProjectGroupID = $folder.Name;
        NuGetPackageCount = (gci $folder.FullName\Packages -Include '*.txt') | %{$_.Size}.Count;
        AverageSize = gci $folder.FullName -Recurse -Filter *.txt | measure-object -property length -average;
    } | Export-Csv -Path d:\monitoring\NugetStatistics -NoTypeInformation -Append
}