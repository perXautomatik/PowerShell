# Get all symbolic links in a directory
$links = Get-ChildItem -Path "M:\SteamLibrary\steamapps\common\STALKER Shadow of Chernobyl" -Recurse | Where-Object { $_.LinkType -eq 'SymbolicLink' }

# Iterate over each link
foreach ($link in $links) {
    # Get the target of the link
    $target = Get-Item -Path $link.Target -ErrorAction SilentlyContinue

    # Check if the target exists
    if ($null -eq $target) {
        # The target does not exist, the link is broken
        Write-Host "Broken link: $($link.FullName) -> $($link.Target)"

        # Here you can decide what to do with the broken link
        # For example, remove it or prompt for a new target
    }
}
