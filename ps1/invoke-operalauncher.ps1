function Invoke-OperaLauncher {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $q
  )

  Write-Verbose "Invoking OperaLauncher with parameter $q"

  if ($PSCmdlet.ShouldProcess("OperaLauncher", "Invoke")) {
    Invoke-Expression "F:; Set-Location F:\; .\OperaLauncher\opera.ps1 -a $q; & setFileExtension"
  }
}

