function Test-Path {

<#
.SYNOPSIS
Determines whether all elements of a path exist.

.DESCRIPTION
The Test-Path cmdlet determines whether all elements of the path exist. It returns $true if all elements exist and $false if any are missing. It can also return the item at the specified path if the PassThru switch is used.

.PARAMETER Path
Specifies the path to test. Wildcards are permitted.

.PARAMETER LiteralPath
Specifies a path to test, but unlike Path, the value of LiteralPath is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks.

.PARAMETER PassThru
Returns an object representing the item at the specified path. By default, this cmdlet does not generate any output.

.INPUTS
System.String
You can pipe a string that contains a path to this cmdlet.

.OUTPUTS
System.Boolean or System.Management.Automation.PathInfo
This cmdlet returns a Boolean value that indicates whether the path exists or an object representing the item at the path if PassThru is used.

.EXAMPLE
Test-Path "C:\Windows"

This command tests whether the C:\Windows directory exists.

.EXAMPLE
Test-Path "C:\Windows\*.exe" -PassThru

This command tests whether there are any files with the .exe extension in the C:\Windows directory and returns them as objects.
#>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Path,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string[]]$LiteralPath,

        [switch]$PassThru
    )

    begin {
        # initialize an empty array to store the paths
        $PathsToTest = @()
    }

    process {
        # add the pipeline input to the array
        if ($Path) {
            $PathsToTest += $Path
        }
        if ($LiteralPath) {
            $PathsToTest += $LiteralPath
        }
    }

    end {
        # loop through each path in the array
        foreach ($P in $PathsToTest) {
            # resolve any wildcards in the path
            $ResolvedPaths = Resolve-Path -Path $P -ErrorAction SilentlyContinue

            # check if any paths were resolved
            if ($ResolvedPaths) {
                # return true or the resolved paths depending on PassThru switch
                if ($PassThru) {
                    $ResolvedPaths | Get-Item
                }
                else {
                    $true
                }
            }
            else {
                # return false or nothing depending on PassThru switch
                if ($PassThru) {
                    # do nothing
                }
                else {
                    $false
                }
            }
        }
    }
}
