
I am looping through the folders in C:\NuGetRoot\NugetServer and then displaying the server name, the folder name (ProjectGroupID), package count of files ending in .nupkg in the 'packages folder for each folder, and the avg size of all of the files that are contained within the "packages" folder for each folder. The server name and ProjectGroupID display correctly. The count and average one aren't. I get the error:

gci : Second path fragment must not be a drive or UNC name. Parameter name:
path2
At line:5 char:30
+ NuGetPackageCount = (gci $folder.FullName\packages -Include '*.nupkg') | ...
+                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (D:\apps\nuget.ciodev.accenture.com:String) [Get-ChildItem], ArgumentException
    + FullyQualifiedErrorId : DirArgumentError,Microsoft.PowerShell.Commands.GetChildItemCommand*
I think it has something to do with the "\packages", because if I remove that it works, but I need to navigate to that folder because that's where the files are.

Instead of running Get-ChildItem 3 times like you are, you could run it once for all *.nupkg files, group them by the project they're associated with, and the grouping objects would have most the info you want right there. Consider this alternative:


Url: https://stackoverflow.com/questions/34207142/count-average-files-in-a-folder