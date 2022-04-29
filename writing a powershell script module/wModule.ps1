
function foldercontain($folder,$name)
{
    $q = get-childitem $folder
    $q -contains $name 
}

function generateManifestsAndmodule ($path)
{
    $q = generateModules $path
    generateManifest $path
    return $q
}

<#
use `New-ModuleManifest` to create a module manifest template 
    that can be modified for your different modules. 
    For an example of a default module manifest,
     see the [Sample module manifest](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7.2#sample-module-manifest).

`New-ModuleManifest -Path C:\myModuleName.psd1 -ModuleVersion "2.0" -Author "YourNameHere"`

   [-FunctionsToExport <String[]>]
   [-AliasesToExport <String[]>]
   [-VariablesToExport <String[]>]
   [-CmdletsToExport <String[]>]
   
   [-ModuleList <Object[]>]
   [-NestedModules <Object[]>]
   
   [-ExternalModuleDependencies <String[]>]
   [-RequiredModules <Object[]>]
   [-RequiredAssemblies <String[]>]
   
   [-ProjectUri <Uri>]
   [-Copyright <String>]
   [-LicenseUri <Uri>]
   [-Author <String>]
   [-CompanyName <String>]
   
   [-CompatiblePSEditions <String[]>]
   [-Description <String>]
   [-HelpInfoUri <String>]
   [-PowerShellVersion <Version>]
   [-RootModule <String>]
   [-DotNetFrameworkVersion <Version>]
   [-PowerShellHostName <String>]
   [-PowerShellHostVersion <Version>]


   [-Guid <Guid>]
   [-ModuleVersion <Version>]
   [-ProcessorArchitecture <ProcessorArchitecture>]

#>
function generateManifest ($path)
{
   [String[]]$FunctionsToExport 
   [String[]]$AliasesToExport
   VariablesToExport[String[]]
   [-CmdletsToExport <String[]>]
   
   [-ModuleList <Object[]>]
   [-NestedModules <Object[]>]
   
   [-ExternalModuleDependencies <String[]>]
   [-RequiredModules <Object[]>]
   [-RequiredAssemblies <String[]>]
   
   [-ProjectUri <Uri>]
   [-Copyright <String>]
   [-LicenseUri <Uri>]
   [-Author <String>]
   [-CompanyName <String>]
   
   [-CompatiblePSEditions <String[]>]
   [-Description <String>]
   [-HelpInfoUri <String>]
   [-PowerShellVersion <Version>]
   [-RootModule <String>]
   [-DotNetFrameworkVersion <Version>]
   [-PowerShellHostName <String>]
   [-PowerShellHostVersion <Version>]


   [-Guid <Guid>]
   [-ModuleVersion <Version>]
   [-ProcessorArchitecture <ProcessorArchitecture>]

    if (foldercontain $path '.git')


}

function generatedmodules ($path)
{
    $foldername = split-path $foldername -leaf

    if (foldercontain $path $foldername.psd1)
    {
            return 'import-module -name .\$foldername' }
    else 
        toutch $foldername.psd1

    for each childitem y
    { 
       ( if (isfolder $y) 
            generateManifestsAndmodules $y
        else
            ".\$y"
             ) >> $foldername.psd1
    }
    
    [string]$functions 
    for each childitem y ? isfolder
    { 
      $functions += get-wordsPresidedBy $y 'function'
    }

    for each $f in $functions
    {
        'call Export-ModuleMember $f' >> $foldername.psd1
    }    
}

