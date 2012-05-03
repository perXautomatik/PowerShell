# Sometimes home doesn't get properly set for pre-Vista LUA-style elevated admins

if ($home -eq "") {
    remove-item -force variable:\home
    $home = (get-content env:\USERPROFILE)
    (get-psprovider 'FileSystem').Home = $home
}
set-content env:\HOME $home

# Keep the existing window title

$windowTitle = (get-title).Trim()

if ($windowTitle.StartsWith("Administrator:")) {
    $windowTitle = $windowTitle.Substring(14).Trim()
}

# Posh-Git overrides

$GitPromptSettings.AfterBackgroundColor = "DarkRed"
$GitPromptSettings.BeforeBackgroundColor = "DarkRed"
$GitPromptSettings.BeforeIndexBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBackgroundColor = "DarkRed"
$GitPromptSettings.BranchAheadBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBehindBackgroundColor = "DarkRed"
$GitPromptSettings.BranchBehindAndAheadBackgroundColor = "DarkRed"
$GitPromptSettings.DelimBackgroundColor = "DarkRed"
$GitPromptSettings.IndexBackgroundColor = "DarkRed"
$GitPromptSettings.WorkingBackgroundColor = "DarkRed"
$GitPromptSettings.UntrackedBackgroundColor = "DarkRed"

$GitPromptSettings.AfterForegroundColor = $Host.UI.RawUI.ForegroundColor
$GitPromptSettings.BeforeForegroundColor = $Host.UI.RawUI.ForegroundColor
$GitPromptSettings.BeforeIndexForegroundColor = "Green"
$GitPromptSettings.BranchForegroundColor = "White"
$GitPromptSettings.IndexForegroundColor = "Green"
$GitPromptSettings.WorkingForegroundColor = "Cyan"
$GitPromptSettings.UntrackedForegroundColor = "Cyan"

$GitPromptSettings.AfterText = " "
$GitPromptSettings.BeforeText = " "
$GitPromptSettings.ShowStatusWhenZero = $false

# Type overrides (starters compliments of Scott Hanselman)

Update-TypeData (join-path $scripts "My.Types.ps1xml")

# Remove default things we don't want

if (test-path alias:\clear)           { remove-item -force alias:\clear }              # We override with clear.ps1
if (test-path alias:\ri)              { remove-item -force alias:\ri }                 # ri conflicts with Ruby
if (test-path alias:\cd)              { remove-item -force alias:\cd }                 # We override with cd.ps1
if (test-path alias:\chdir)           { remove-item -force alias:\chdir }              # We override with an alias to cd.ps1
if (test-path alias:\md)              { remove-item -force alias:\md }                 # We override with md.ps1
if (test-path alias:\sc)              { remove-item -force alias:\sc }                 # Conflicts with \Windows\System32\sc.exe
if (test-path function:\md)           { remove-item -force function:\md }              # We override with md.ps1
if (test-path function:\mkdir)        { remove-item -force function:\mkdir }           # We override with an alias to md.ps1
if (test-path function:\prompt)       { remove-item -force function:\prompt }          # We override with prompt.ps1

# Aliases/functions

set-alias grep   select-string
set-alias wide   format-wide
set-alias whoami get-username
set-alias chdir  cd
set-alias mkdir  md

set-content function:\mklink "cmd /c mklink `$args"

# Development overrides

set-content env:\TERM "msys"    # To shut up Git 1.7.10+

    if (test-path "C:\Dev\bin\Startup.ps1") { . C:\Dev\bin\Startup.ps1 }
elseif (test-path "D:\Dev\bin\Startup.ps1") { . D:\Dev\bin\Startup.ps1 }
elseif (test-path "E:\Dev\bin\Startup.ps1") { . E:\Dev\bin\Startup.ps1 }