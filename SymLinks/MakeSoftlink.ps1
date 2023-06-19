<#
.SYNOPSIS
Create a symbolic link or a junction to a source file or folder.

.DESCRIPTION
This script takes two parameters: the source file or folder to link, and the target path to create the link. It then checks if the source is a file or a folder, and sets the appropriate flag for the mklink command. It then runs the mklink command as an administrator to create the symbolic link or the junction.

.PARAMETER Source
The source file or folder to link.

.PARAMETER Target
The target path to create the link. If not specified, it defaults to the current directory with the same name as the source.

.EXAMPLE
PS C:\> MakeSoftLink -Source 'D:\Users\crbk01\AppData\Local\Microsoft\Outlook' -Target 'C:\Users\crbk01\AppData\Local\Microsoft\Outlook'

This example creates a junction from 'C:\Users\crbk01\AppData\Local\Microsoft\Outlook' to 'D:\Users\crbk01\AppData\Local\Microsoft\Outlook'.
#>

function MakeSoftLink {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   HelpMessage="what to link")] 
        [string]$Source,

        [Parameter(Mandatory=$false,
                   HelpMessage="where to create link")] 
        [string]$Target = (Join-Path -Path (Get-Location) -ChildPath (Split-Path -Leaf $Source))
    )
    PROCESS {  

        # Check if the source is a file or a folder
        if((Get-Item $Source) -is [System.IO.DirectoryInfo]) 
        {
            # Set the flag for creating a junction
            $flag = '/J'
        }
        else
        {
            # Set the flag for creating a symbolic link
            $flag = '/D'
        }

        # Run the mklink command as an administrator to create the link
        Start-Process -Wait -FilePath cmd -Verb RunAs -ArgumentList '/c', 
          'mklink', $flag, "`"$Target`"", "`"$Source`""
    }        
    END { 

    }
}   
