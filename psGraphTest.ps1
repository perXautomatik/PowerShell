 Import-Module PSGraph ;

 Add-Type -AssemblyName System.IO

 cd 'C:\Users\chris\appData' ; $folders = Get-ChildItem -Recurse -Filter '.git' -Force
 
$splitValues = ($folders | %{ 
    $input = $_    
    for ($i=0; $i -lt ($_.FullName.split('\').length) ; $i++)
    {
        if ($input.FullName -ne '' -and $input.FullName -ne $null)
        {               
            $splitX = (Split-Path $input.FullName)
            if ($splitX -ne '' -and $splitX -ne $null)
            {
                $input
                $input = [System.IO.DirectoryInfo]$splitX
            }
        }
    }
}) | ? {$_.FullName.split('\').length -gt 2} | select -Unique
#  | Sort-Object -Property @{expression={$_.FullName.split('\').length}}
#$splitValues

#cd 'C:\'
#$splitValues = Get-ChildItem # -Depth 2


 $dot = graph g @{rankdir='LR'}  {
    node -Default @{shape='folder'}
    $splitValues  | ForEach-Object{ node $_.FullName @{label=$_.Name} }
    $splitValues  | ForEach-Object{ edge (Split-Path $_.FullName) -To $_.FullName }
}


 $FileName = "$env:temp\dot.dot"
if (Test-Path $FileName) {
  Remove-Item $FileName
}

 $dot | Set-Content $env:temp\dot.dot
 notepad $env:temp\dot.dot

 $FileName = "$env:temp\hellox.vz"
if (Test-Path $FileName) {
  Remove-Item $FileName
}


$FileName = "$env:temp\hellox.vz"
if (Test-Path $FileName) {
  Remove-Item $FileName
}


 Set-Content -Path $env:temp\hellox.vz -Value $dot ;
  Export-PSGraph -Source $env:temp\hellox.vz -Destination $env:temp\hellox.png -ShowGraph ;
   $viewer = 'U:\PortableApplauncher\AppManager\.free\IrfanView\IrfanViewPortable\IrfanViewPortable.exe' ; 
   & $viewer $env:temp\hellox.png