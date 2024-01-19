#source https://social.technet.microsoft.com/Forums/en-US/fddb6ec0-cc48-43f0-929e-bf25d07fbf48/get-target-path-of-shortcuts?forum=winserverpowershell
 function Get-DesktopShortcuts{
    $Shortcuts = Get-ChildItem -Recurse "C:\users\public\Desktop" -Include *.lnk -Force
    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
        ShortcutName = $Shortcut.Name;
        ShortcutFull = $Shortcut.FullName;
        ShortcutPath = $shortcut.DirectoryName
        Target = $Shell.CreateShortcut($Shortcut).targetpath
        }
        New-Object PSObject -Property $Properties
    }

[Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
}


function Get-ShortcutTargetShell_application
{
    param ([string]$folder )    
    
    $folder = $folder
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.namespace($folder)
    $objFolder.Items() |
    Where-Object {$_.Type -eq "Shortcut"} |
    ForEach-Object {
        [pscustomobject]@{
            $objFolder.getDetailsOf($folder, 0) = $objFolder.getDetailsOf($_, 0);
            $objFolder.getDetailsOf($folder, 182) = $objFolder.getDetailsOf($_, 182)
            $objFolder.getDetailsOf($folder, 185) = $objFolder.getDetailsOf($_, 185)
            $objFolder.getDetailsOf($folder, 194) = $objFolder.getDetailsOf($_, 194)
        }
    }
}


function gecd
{
    param ([string]$folder )    
    
    $objShell = New-Object -ComObject Shell.Application
    
    $objFolder = $objShell.namespace($folder)
    
    $objFolder.Items() | % { $_.GetLink}

}

function Get-ShortcutTargetInPath () {
    param ([string]$folder )    
    
    $objShell = New-Object -ComObject Shell.Application
    
    $objFolder = $objShell.namespace($folder)
    
    $objFolder.Items() |
    Where-Object {$_.Type -eq "Shortcut"} |
    ForEach-Object {
        [pscustomobject]@{
            path =     ($_.GetLink).path;
            $objFolder.getDetailsOf($folder, 0) = $objFolder.getDetailsOf($_, 0);
            $objFolder.getDetailsOf($folder, 182) = $objFolder.getDetailsOf($_, 182);
            $objFolder.getDetailsOf($folder, 185) = $objFolder.getDetailsOf($_, 185);
            #$objFolder.getDetailsOf($folder, 194) = $objFolder.getDetailsOf($_, 194);
        }
    }
}

$Output = Get-ShortcutTargetShell_application -folder 'D:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\ide' 
$Output # | Out-GridView

$Output | Out-GridView