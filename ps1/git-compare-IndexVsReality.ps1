function Filter-StringsWithPrefix {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$MainStrings,

        [Parameter(Mandatory=$true)]
        [string[]]$Prefixes
    )

    process {
        # Filter strings in $MainStrings that start with any string from $Prefixes
        $MainStrings | Where-Object {
            $mainString = $_
            $Prefixes | Where-Object { $mainString -like "$_*" }
        }
    }
}


$gitPaths = git ls-files

$fsItems = Get-ChildItem -Recurse | % { ($_.FullName -replace [regex]::escape($pwd) -replace [regex]::escape("\"), '/').trim('/')   };
$combinedPaths = $gitPaths + $fsItems | Sort-Object -Unique | Sort-Object -CaseSensitive
$gitIgnored = invoke-git "status --ignored" | 
    % { $_.trim("/").trim() } ;
     $indexedNactual = (Compare-Object -ReferenceObject $gitPaths -DifferenceObject $fsItems ) ; 
     (Compare-Object -ReferenceObject $gitIgnored -DifferenceObject $indexedNactual.inputobject ) | 
     Measure-Object ; 
     $indexedNactual.inputObject |
      Filter-StringsWithPrefix -Prefixes $gitIgnored | 
        Measure-Object