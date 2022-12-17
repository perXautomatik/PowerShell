Function MakeSoftLink {
[CmdletBinding()]
param (

    [Parameter(Mandatory=$true,
                HelpMessage="what to link")] 
    [string]$Source,

    [Parameter(Mandatory=$false,
                HelpMessage="where to create link")] 
    [string]$target
)
PROCESS {  

<<<<<<< HEAD

=======
#if ((Split-Path -Leaf $target) -Ieq (Split-Path -leaf $Source))
#{
#$target = Split-Path -Parent $target
#$source
#$target
#$targetName = (Split-Path -Leaf $Source)
#cd $target
#(Split-Path -Leaf $Source)
#}
>>>>>>> 922c545 (merging with projectfolders)
if((Get-Item $source) -is [System.IO.DirectoryInfo]) 
{
$flag = '/D'
}
else
{
$flag = '/j'
}

Start-Process -Wait -FilePath cmd -Verb RunAs -ArgumentList '/k', 
  'mklink', $flag, "`"$target`"", "`"$source`""

}        
END { 

}
<<<<<<< HEAD
}   
=======
}   

makeSoftLink 'D:\Users\crbk01\AppData\Local\Microsoft\Outlook' 'C:\Users\crbk01\AppData\Local\Microsoft\Outlook'
>>>>>>> 922c545 (merging with projectfolders)
