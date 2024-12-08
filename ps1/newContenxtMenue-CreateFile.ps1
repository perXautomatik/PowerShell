$RegistryPath = 'HKCU:\Software\Classes\Directory\Background\Shell\NewGit'
$Command = 'cmd.exe /c echo gitdir: > "%V\\.git"'

# Create the registry key for the new context menu entry
New-Item -Path $RegistryPath -Force

# Add the command that will be executed when the menu item is clicked
New-ItemProperty -Path $RegistryPath -Name 'Icon' -Value 'notepad.exe' -PropertyType String -Force
New-Item -Path "$RegistryPath\command" -Force | New-ItemProperty -Name '(default)' -Value $Command -PropertyType String -Force

# Refresh the shell to update the context menu
$null = New-Object -ComObject Shell.Application
$null.Namespace(0).Self.InvokeVerb('Refresh')
