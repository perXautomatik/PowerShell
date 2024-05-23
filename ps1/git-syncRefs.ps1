# In the source repository
$repo1 = 'C:\Users\CbRootz\Documents\'
<#
refs/heads/AppData/small
refs/heads/AppDataB
refs/heads/LocalB
refs/heads/LoppyXx
refs/heads/xLoppyXx
refs/remotes/origin/LargeINcluding
refs/remotes/origin/LoppyX
refs/remotes/origin/LoppyXx
refs/remotes/origin/MergingCWithD
refs/remotes/origin/NeoScavengerSaves
refs/remotes/origin/chrome
refs/remotes/origin/mtga
refs/remotes/win-dot/Dotfiles
refs/remotes/win-dot/LoppyPersist
refs/remotes/win-dot/master

refs/heads/Arrogant_Bastard_Typhoon_Gaming_mouseB
refs/heads/DarkestB
refs/heads/Diablo_IIB
refs/heads/Diablo_II_ResurrectedB
refs/heads/FOMMB
refs/heads/Google_DriveB
refs/heads/HomePcDocuments
refs/heads/KleiB
refs/heads/Path_of_BuildingB
refs/heads/UserFolder/Documents-My_Games
refs/heads/Visual_Studio_____B
refs/heads/gitConfigAltB
refs/heads/smallerDocuments
refs/remotes/github/master
refs/remotes/origin/Documents

refs/stash
refs/tags/a1
#>

$toPush = @('refs/heads/AppData/small',
    'refs/heads/AppDataB',
    'refs/heads/LocalB',
    'refs/heads/LoppyXx',
    'refs/heads/xLoppyXx',
    'refs/remotes/origin/LargeINcluding',
    'refs/remotes/origin/LoppyX',
    'refs/remotes/origin/LoppyXx',
    'refs/remotes/origin/MergingCWithD',
    'refs/remotes/origin/NeoScavengerSaves',
    'refs/remotes/origin/chrome',
    'refs/remotes/origin/mtga',
    'refs/remotes/win-dot/Dotfiles',
    'refs/remotes/win-dot/LoppyPersist',
    'refs/remotes/win-dot/master')

<#repo descriotion: documents, savegames #>
$repo2 = 'C:\Users\CbRootz\.config'
$toPush = @( 
    
@(
    'refs/heads/Activity-WatchFilters',
    'refs/heads/AntiDupl_NET_______B',
    'refs/heads/AomeiB',
    'refs/heads/Assorted',
    'refs/heads/IISExpressB',
    'refs/heads/DockerDesktopB',
    'refs/heads/OneQuickB',
    'refs/heads/_DataGrip______B',
    'refs/heads/_Neo_jDesktopB',
    'refs/heads/_git_bfg_reportB',
    'refs/remotes/AppData/Documents'
),

@(
    'refs/heads/AnvandarenCnfig',
    'refs/heads/Cnfig',
    'refs/heads/_configC',
    'refs/remotes/dotfiles/master',
    'refs/remotes/notPushable/main',
    'refs/remotes/win-dot/Dotfiles',
    'refs/remotes/win-dot/master',
    'refs/remotes/win-dotfiles/Dotfiles',
    'refs/remotes/win-dotfiles/LoppyPersist',
    'refs/remotes/win-dotfiles/master'
),

@(
    'refs/heads/Config-WindowsPowershell',
    'refs/heads/Documents-WindowsPowershell',
    'refs/heads/b/PowerShell',
    'refs/heads/bScripts',
    'refs/heads/config-powershell',
    'refs/remotes/NoFolders/TemPSmallerProfile',
    'refs/remotes/NoFolders/main',
    'refs/remotes/NoFolders/master',
    'refs/remotes/NoFolders/smallerProfile',
    'refs/remotes/Powershell-Profile/5-Stable',
    'refs/remotes/Powershell-Profile/7-Unstable',
    'refs/remotes/Powershell-Profile/7.+-Stable',
    'refs/remotes/Powershell-Profile/Config-WindowsPowershell',
    'refs/remotes/Powershell-Profile/Documents-WindowsPowershell',
    'refs/remotes/Powershell-Profile/Mark-1',
    'refs/remotes/Powershell-Profile/ModerNState',
    'refs/remotes/Powershell-Profile/Modules',
    'refs/remotes/Powershell-Profile/Ps1',
    'refs/remotes/Powershell-Profile/abModules',
    'refs/remotes/Powershell-Profile/bScripts',
    'refs/remotes/Powershell-Profile/config-powershell',
    'refs/remotes/Powershell-Profile/documents-powershell',
    'refs/remotes/Powershell-Profile/kreloc',
    'refs/remotes/Powershell-Profile/master',
    'refs/remotes/Powershell-Profile/patch-1',
    'refs/remotes/Powershell-Profile/ps2',
    'refs/remotes/Powershell-Profile/state'
),

@(
    'refs/heads/AppDataB',
    'refs/heads/AppData/small',
    'refs/heads/LocalB',
    'refs/heads/Vortex',
    'refs/heads/xLoppyXx',
    'refs/heads/LoppyXx',
    'refs/remotes/AppData/LargeINcluding',
    'refs/remotes/AppData/LoppyX',
    'refs/remotes/AppData/LoppyXx',
    'refs/remotes/AppData/MergingCWithD',
    'refs/remotes/AppData/NeoScavengerSaves',
    'refs/remotes/AppData/Vortex',
    'refs/remotes/AppData/chrome',
    'refs/remotes/AppData/detachedHead',
    'refs/remotes/AppData/master',
    'refs/remotes/AppData/mtga',
    'refs/remotes/origin/LargeINcluding',
    'refs/remotes/origin/LoppyX',
    'refs/remotes/origin/LoppyXx',
    'refs/remotes/origin/MergingCWithD',
    'refs/remotes/origin/NeoScavengerSaves',
    'refs/remotes/origin/chrome',
    'refs/remotes/origin/master',
    'refs/remotes/origin/mtga'
),

@(
    'refs/heads/LoppyPersist',
    'refs/heads/LoppyPersistx',
    'refs/heads/snappy_driver_installer_originB',
    'refs/heads/scoopB',
    'refs/heads/steamB'
),

@(
    'refs/heads/Start_MenuB',
    'refs/heads/UserfOlder-master',
    'refs/heads/ToGitB',
    'refs/heads/userfolderx'
),

'refs/stash',
'refs/tags/AppDLocal',
'refs/tags/AppDLocalLow',
'refs/tags/ToReplaceForHistory',
'refs/tags/ToReplaceForHistorySake2',
'refs/tags/apdRoaming',
'refs/tags/beforeRebase',
'refs/tags/docs-powershell',
'refs/tags/ob',
'refs/tags/steveLee',
'refs/tags/ts'

)
<#repo descriotion: dotfiles, #>

cd $repo1
git for-each-ref --format='%(refname)' | ? { $_ -in $toPush} | foreach { git push $repo2 $_ }
