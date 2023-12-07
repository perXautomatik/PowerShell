# General
$Env:EDITOR = "nvim"
$Env:PAGER = "less.exe"

# AWS-CLI
$Env:AWS_PAGER = "less.exe"

# Python
$env:PYTHONIOENCODING="utf-8"

# FZF
$Env:FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"

$scripts = "$HOME\.config\powershell\Scripts"
$env:path += ";$scripts"
$env:EDITOR = "nvim"
$env:PAGER = "bat"
$env:FX_SHOW_SIZE = "true"
# Set dotfiles path (PS module)
$DotFilesPath = "$HOME/dotfiles"
$ENV:DOTFILES_DIR = "$HOME/.config" 

### fzf config
$env:FZF_DEFAULT_COMMAND = 'fd --type f'
$env:FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
$env:FZF_ALT_C_COMMAND = "fd --type d"

