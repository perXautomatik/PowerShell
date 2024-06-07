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
            $compatibPsEditions = $m.compatiblePsEditions 
            # Check if the current host is compatible
            $isHostCompatible = $false
            if (($compatibleHosts -and $host.Name -in $compatibleHosts) -or !$compatibleHosts) {
                $isHostCompatible = $true
            }

            # Compare the required version with the current PowerShell version
            # and check if the host is compatible
            if ([Version]$requiredVersion -le $PSVersionTable.PSVersion -and $isHostCompatible) {
                # If compatible, output the module info
                $m
            }
        }
    }
}

# Usage:
Get-Module -ListAvailable | Test-ModuleCompatibility
