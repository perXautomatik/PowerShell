function Invoke-OperaLauncher {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $q,
    [Parameter(Position = 1)]
    [string]
    $DriveLetter = 'F:'
  )

  Write-Verbose "Invoking OperaLauncher with parameter $q on drive $DriveLetter"

  if ($PSCmdlet.ShouldProcess("OperaLauncher", "Invoke")) {
    Invoke-Expression "$DriveLetter; Set-Location $DriveLetter\; .\OperaLauncher\opera.ps1 -a $q; & setFileExtension"
  }
}

