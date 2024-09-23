<#
.synopsis
.Example 
	usage:
	$searchString = "C:\OldPath"
	$replaceString = "D:\NewPath"

	Validate-StartMenuShortcuts -startMenuPath $startMenuPath -searchString $searchString -replaceString $replaceString

#>

    param (
        [string]$startMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs",
        [string]$searchString,
        [string]$replaceString
    )

    $shortcuts = Get-ChildItem -Path $startMenuPath -Recurse -Include *.lnk -Force
    $shell = New-Object -ComObject WScript.Shell
    $logFile = "InvalidShortcuts.log"

    # Clear the log file
    Clear-Content -Path $logFile -ErrorAction SilentlyContinue

    foreach ($shortcut in $shortcuts) {
        $shortcutPath = $shortcut.FullName
        $shortcutObject = $shell.CreateShortcut($shortcutPath)
        $targetPath = $shortcutObject.TargetPath

        if (-not (Test-Path -Path $targetPath)) {
            # Target path is invalid, apply the replacement
            $newTargetPath = $targetPath -replace [regex]::Escape($searchString), $replaceString

            if (Test-Path -Path $newTargetPath) {
                # Update the shortcut to the new valid path
                $shortcutObject.TargetPath = $newTargetPath
                $shortcutObject.Save()
                Write-Host "Updated shortcut: $shortcutPath to $newTargetPath"
            } else {
                # Log the failed path
                Add-Content -Path $logFile -Value "Invalid shortcut: $shortcutPath -> $targetPath"
                Write-Host "Invalid shortcut: $shortcutPath -> $targetPath"
            }
        }
    }

    Write-Host "Check the log file for invalid shortcuts: $logFile"