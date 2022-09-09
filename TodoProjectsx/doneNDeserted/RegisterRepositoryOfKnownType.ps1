$parameters = @{
  Name = "Sfta"
  ScriptSourceLocation  = "https://raw.githubusercontent.com/DanysysTeam/PS-SFTA/master/SFTA.ps1"
  PublishLocation = "https://github.com/DanysysTeam/PS-SFTA"
  InstallationPolicy = 'Trusted'
}
Register-PSRepository @parameters
Get-PSRepository