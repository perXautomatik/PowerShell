function Test-ModuleCompatibility {
    param(
        [Parameter(ValueFromPipeline=$true)]
        $Module
    )

    process {
        foreach ($m in $Module) {
            # Extract the minimum required version of PowerShell from the module manifest
            $requiredVersion = $m.PowerShellVersion
            # Extract the compatible PowerShell host names from the module manifest
            $compatibleHosts = $m.PowerShellHostName
            # Extract the compatible PowerShell editions from the module manifest
            $compatibleEditions = $m.CompatiblePSEditions

            # Check if the current host is compatible
            $isHostCompatible = $false  -or !$compatibleHosts
            if (-not $compatibleHosts -or $host.Name -in $compatibleHosts) {
                $isHostCompatible = $true
            }

            # Check if the current edition is compatible
            $isEditionCompatible = $false   -or !$isEditionCompatible
            if (-not $compatibleEditions -or $PSEdition -in $compatibleEditions) {
                $isEditionCompatible = $true
            }

            # Compare the required version with the current PowerShell version
            # and check if the host and edition are compatible
            if ([Version]$requiredVersion -le $PSVersionTable.PSVersion -and $isHostCompatible -and $isEditionCompatible) {
                # If compatible, output the module info
                $m
            }
            else {
                Write-Verbose "not compatible" 
                Write-Verbose $m
            }
        }
    }
}

function List-Modules-OfPath {
    ($env:PSModulePath).split(";") | %{ Get-ChildItem $_ -ErrorAction SilentlyContinue } 
}
function List-Modules-OfScope {
    # Usage:
    $modules = Get-Module -ListAvailable 

    $modules += get-module

    $hm = @{}
    ($env:PSModulePath).split(";") | 
        % { 
                $mp = $_; 
                $hm[$mp]=@( 
                    $modules |
                        ? {$_.path.StartsWith($mp, [StringComparison]::OrdinalIgnoreCase)}) 
        };
    $hm        
}

function List-Modules-ByFunchtion-Exposing {
     
    param(
       [Parameter(ValueFromPipeline=$true)]
       $Module
   )
   begin
   {$u = @{} ; }
   process {
       foreach ($m in $Module) {        
           $u[$m]+= @(Get-Module -Name $m -ListAvailable | %{ $m.ExportedCommands.Values }) 
       }
   }
   end
   {
       $u.GetEnumerator() |
       Group-Object -Property @{expr={ $_.Value.length}} | 
       Sort-Object -Property name,Count |
           select -Property Group -ExpandProperty group
   }
} 
