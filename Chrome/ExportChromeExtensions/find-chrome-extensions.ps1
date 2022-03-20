# https://gist.github.com/marcinantkiewicz/9ac20677145f246eb01cd1759cb03f35 
# Author: Marcin Antkiewicz
# marcin@kajtek.org
# @deciban

# Use:
#find_chrome_extensions -OutputDir "c:\"  

#idea ref: https://www.reddit.com/r/PowerShell/comments/5px71w/getting_chrome_extensions/
#PS 2.o has no convertfrom-json, 2.0 helper from http://stackoverflow.com/questions/28077854/powershell-2-0-convertfrom-json-and-convertto-json-implementation
#
# Lists basic infromation about chrome extensions, ex:
# id                               Name                Version      Perms
# --                               ----                -------      -----
# aapocclcgogkmnckokdopfmhonfmgoek __MSG_appName__     0.9
# apdfllckaahabafndbhieahigkjlhalf __MSG_appName__     14.1         {background, clipboardRead, clipboardWrite, 

function msa-ConvertFrom-Json([object] $item){ 
    Add-Type -Assembly system.web.extensions
    $ps_js=New-Object system.web.script.serialization.javascriptSerializer

    #The comma operator is the array construction operator in PowerShell
    return ,$ps_js.DeserializeObject($item)
}

function List-ChromeExtensions($path,$user,$output) {
    $findings = @()
    $chrome_ext_dir = "$path\$user\AppData\Local\Google\Chrome\User Data\Default\Extensions"
    $extensions = Get-ChildItem $chrome_ext_dir -ErrorAction SilentlyContinue

    if($extensions){
        Foreach($ext in $extensions){
            foreach($version in (Get-ChildItem $chrome_ext_dir\$ext)){
                Foreach($ver in $version){
                    if(-Not(Test-Path  -PathType Leaf $chrome_ext_dir\$ext\$ver\manifest.json)){ 
                        $findings += "Error: $ext\$ver has no manifest file"
                        continue
                    }
                    
                    $manifest = Get-Content $chrome_ext_dir\$ext\$ver\manifest.json -ErrorAction SilentlyContinue | Out-String 
                    $jsn = msa-convertfrom-json($manifest)
            
                    $info = New-Object PSObject
                    $info | Add-Member -MemberType NoteProperty -Name Owner -Value $user@$env:ComputerName
                    $info | Add-Member -MemberType NoteProperty -Name Id -Value $ext.Name
                    $info | Add-Member -MemberType NoteProperty -Name Name -Value $jsn.name
                    $info | Add-Member -MemberType NoteProperty -Name Version -Value $jsn.version
                    $info | Add-Member -MemberType NoteProperty -Name Perms -Value $jsn.permissions
           
                    $findings += $info         
                }
            }
        }
    }
    Else {
            $info = New-Object PSObject
            $info | Add-Member -MemberType NoteProperty -Name Owner -Value $user@$env:ComputerName
            $info | Add-Member -MemberType NoteProperty -Name Id -Value "error"
            $info | Add-Member -MemberType NoteProperty -Name Error -Value "user $user - cannot find Chrome extensions dir at $chrome_ext_dir" 
            $findings += $info
    }
    
    $findings | Export-Csv $output -NoType
}

function find_chrome_extensions {
    param($OutputDir)
    $ps_version = $PSVersionTable.PSVersion.Major
    $path = "$env:SystemDrive\Users\"
    foreach($user in Get-ChildItem -Name $path){
            List-ChromeExtensions $path $user "$OutputDir\chrome-extensions-$user.csv"
    }
}

#find_chrome_extensions -OutputDir "c:\"  