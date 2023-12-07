# MacOS style "open" command (alias to Invoke-Item module (ii))
New-Alias open Invoke-Item

# Remove curl and wget aliases
if (Test-Path alias:curl) {
  Remove-Item alias:curl
}
if (Test-Path alias:wget) {
  Remove-Item alias:wget
}

# Remove alias for cat, we'll use the native `bat` instead
if (Test-Path alias:cat) {
	Remove-Item alias:cat
}
New-Alias cat bat # Needs `bat` to be installed!

New-Alias touch Update-File

iex "$(thefuck --alias)"

New-Alias vim nvim # Needs neovim!

Set-Alias -Name awk -Value C:\"Program Files"\Git\usr\bin\awk.exe
Set-Alias -Name dirname -Value C:\"Program Files"\Git\usr\bin\dirname.exe
Set-Alias -Name ln -Value C:\"Program Files"\Git\usr\bin\ln.exe
Set-Alias -Name sed -Value C:\"Program Files"\Git\usr\bin\sed.exe
Set-Alias -Name touch -Value C:\"Program Files"\Git\usr\bin\touch.exe
Set-Alias -Name uniq -Value C:\"Program Files"\Git\usr\bin\uniq.exe
Set-Alias -Name wc -Value C:\"Program Files"\Git\usr\bin\wc.exe
	   
# Aliases
Set-Alias code codium
Set-Alias g git
Set-Alias grep findstr
Set-Alias l ls
Set-Alias l lsd
Set-Alias lg lazygit
Set-Alias -Name fe -Value Invoke-FuzzyEdit
Set-Alias -Name fh -Value Invoke-FuzzyHistory
Set-Alias -Name fk -Value Invoke-FuzzyKillProcess
Set-Alias py python
Set-Alias v nvim
