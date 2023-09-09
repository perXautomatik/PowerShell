function Hide-GitDir {

<#
.SYNOPSIS
Hides the .git directory on Windows.

.DESCRIPTION
Hides the .git directory on Windows by running attrib.exe +H /D.

.PARAMETER Path
The path of the submodule.
#>
    param (
	[Parameter(Mandatory)]
	[string]$Path
    )

    # check if attrib.exe is available on Windows
    if (Get-Command attrib.exe) {
	# run attrib.exe +H /D to hide the .git directory
	MSYS2_ARG_CONV_EXCL="*" attrib.exe "+H" "/D" "$Path/.git"
    }
}
