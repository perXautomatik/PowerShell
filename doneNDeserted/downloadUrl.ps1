#https://shellgeek.com/download-zip-file-using-powershell/#:~:text=In%20PowerShell%20to%20download%20file%20from%20url%2C%20use,file%20from%20github%20repository.%20File%20name%20%3A%20powershell-beginners-guide.md

#$source = 'https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/powershell-beginners-guide.md'
#$destination = 'D:\powershell-beginners-guide.md'

function download
{
    [CmdletBinding (PositionalBinding=$true)]
    param(
    [Parameter(Position=0,Mandatory=$True,HelpMessage="download source url")]
    [string]$source,
    [Parameter(Position=1)]
    [string]$destination)
Invoke-RestMethod -Uri $source -OutFile $destination
}