<#
# Synopsis: This function changes the current working directory and maintains a history of visited directories.
# Parameters: 
# - $args[0]: A string that specifies the target directory, or a flag that modifies the behavior of the function.
# - If $args[0] is empty, the function changes the directory to $HOME.
# - If $args[0] is a negative integer, the function changes the directory to the corresponding entry in the history list.
# - If $args[0] is "-l", the function prints the history list.
# - If $args[0] is "-", the function swaps the current and previous directories.
# - Otherwise, the function changes the directory to $args[0].#>
function cd {
    # Check if PowerShell version is 5.1 or above
    if ($PSVersionTable.PSVersion.Major -ge 5 -and $PSVersionTable.PSVersion.Minor -ge 1) {
        # Use the built-in variable $PWD and $PSCmdlet.SessionState.Path.History
        $cwd = $PWD
        $count = $PSCmdlet.SessionState.Path.History.Count

        if ($args.length -eq 0) {
            Set-Location $HOME
            # Remove any duplicate entries in the history list
            $PSCmdlet.SessionState.Path.History = $PSCmdlet.SessionState.Path.History | Select-Object -Unique
        }
        elseif ($args[0] -like "-[0-9]*") {
            # Convert the argument to a positive index
            $num = [Math]::Abs([int]$args[0]) - 1
            # Check if the index is valid
            if ($num -lt $count) {
                Set-Location $PSCmdlet.SessionState.Path.History[$num]
                # Remove the entry from the history list and insert it at the beginning
                $PSCmdlet.SessionState.Path.History.RemoveAt($num)
                $PSCmdlet.SessionState.Path.History.Insert(0, $PWD)
            }
            else {
                Write-Error "Invalid index: $args[0]"
            }
        }
        elseif ($args[0] -eq "-l") {
            # Print the last 50 entries in the history list
            $start = [Math]::Max(0, $count - 50)
            for ($i = $start; $i -lt $count; $i++) {
                "{0,6}  {1}" -f -$($count - $i), $PSCmdlet.SessionState.Path.History[$i].ToString().Replace("Microsoft.PowerShell.Core\FileSystem::","")
            }
        }
        elseif ($args[0] -eq "-") {
            # Swap the current and previous directories
            if ($count -gt 1) {
                Set-Location (Get-Location -Stack)[0]
                # Remove any duplicate entries in the history list
                $PSCmdlet.SessionState.Path.History = $PSCmdlet.SessionState.Path.History | Select-Object -Unique
            }
        }
        else {
            # Change the directory to the argument
            Set-Location "$args"
            # Remove any duplicate entries in the history list
            $PSCmdlet.SessionState.Path.History = $PSCmdlet.SessionState.Path.History | Select-Object -Unique
        }
    }
    else {
        # Use global variables for compatibility with older versions
        if ($GLOBAL:PWD -isnot [System.Management.Automation.PathInfo]) {
            $GLOBAL:PWD = Get-Location
        }

        if ($GLOBAL:CDHIST -isnot [System.Collections.ArrayList]) {
            $GLOBAL:CDHIST = [System.Collections.Arraylist]::Repeat($PWD, 1)
        }

        $cwd = Get-Location
        $count = $GLOBAL:CDHIST.count

        if ($args.length -eq 0) {
            Set-Location $HOME 
            # Remove any duplicate entries in the history list
            for ($i = 0; $i -lt $($GLOBAL:CDHIST.count); ) {
                if ($GLOBAL:CDHIST[$i].Path -eq (Get-Location).Path) {
                    [void]$GLOBAL:CDHIST.RemoveAt($i)
                }
                else {
                    ++$i;
                }
            }
            
            if ($GLOBAL:CDHIST[0] -ne (Get-Location)) {
                [void]$GLOBAL:CDHIST.Insert(0,(Get-Location)) 
            }
        }
        elseif ($args[0] -like "-[0-9]*") {
            # Convert the argument to a positive index
            $num = [Math]::Abs([int]$args[0]) - 1
            # Check if the index is valid
            if ($num -lt $count) {
                $GLOBAL:PWD = $GLOBAL:CDHIST[$num]
                Set-Location $GLOBAL:PWD
                # Remove the entry from the history list and insert it at the beginning
                [void]$GLOBAL:CDHIST.RemoveAt($num)
                [void]$GLOBAL:CDHIST.Insert(0,$GLOBAL:PWD) 
            }
            else {
                Write-Error "Invalid index: $args[0]"
            }
        }
        elseif ($args[0] -eq "-l") {
            # Print the last 50 entries in the history list
            $start = [Math]::Max(0, $count - 50)
            for ($i = $start; $i -lt $count; $i++) {
                "{0,6}  {1}" -f -$($count - $i), $GLOBAL:CDHIST[$i].ToString().Replace("Microsoft.PowerShell.Core\FileSystem::","")
            }
        }
        elseif ($args[0] -eq "-") {
            # Swap the current and previous directories
            if ($count -gt 1) {
                $t = $CDHIST[0]
                $CDHIST[0] = $CDHIST[1]
                $CDHIST[1] = $t
                Set-Location $GLOBAL:CDHIST[0]
                $GLOBAL:PWD = Get-Location
            }
        }
        else {
            # Change the directory to the argument
            Set-Location "$args"
            # Remove any duplicate entries in the history list
            for ($i = 0; $i -lt $($GLOBAL:CDHIST.count); ) {
                if ($GLOBAL:CDHIST[$i].Path -eq (Get-Location).Path) {
                    [void]$GLOBAL:CDHIST.RemoveAt($i)
                }
                else {
                    ++$i;
                }
            }

            [void]$GLOBAL:CDHIST.Insert($GLOBAL:CDHIST.count, (Get-Location))
        }

        $GLOBAL:PWD = Get-Location
    }
}
