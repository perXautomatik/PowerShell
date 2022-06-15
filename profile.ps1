# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue
# define these environment variables if not set already and also provide them as PSVariables

if ( ( $null -eq $PSVersionTable.PSEdition) -or ($PSVersionTable.PSEdition -eq "Desktop") ) { $PSVersionTable.PSEdition = "Desktop" ;$IsWindows = $true }

if ( -not $IsWindows ) { function Test-IsAdmin { if ( (id -u) -eq 0 ) { return $true } return $false } }
#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}    

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if ( $args.Count -eq 0 ) {
        Get-Childitem env:
    } elseif( $args.Count -eq 1 ) {
        Start-Process (Get-Command $args[0]).Source
    } else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}


function cf {
    if ( $null -ne $(Get-Module PSFzf) ) {
        Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
    } else {
        Write-Error "please install PSFzf"
    }
}

if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope
    function git-root { $gitrootdir = (git rev-parse --show-toplevel) ; if ( $gitrootdir ) { Set-Location $gitrootdir } }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`' }

        if ( -Not (Test-CommandExists 'sh') ){ Set-Alias sh   git-sh -Option AllScope }

        if ( -Not (Test-CommandExists 'bash') ){ Set-Alias bash   git-bash -Option AllScope }

        if ( -Not (Test-CommandExists 'vi') ){ Set-Alias vi   git-vim -Option AllScope }

        if ( -Not (Test-CommandExists 'vim') ){ Set-Alias vim   git-vim -Option AllScope }
    }
}

function Select-Value { # src: https://geekeefy.wordpress.com/2017/06/26/selecting-objects-by-value-in-powershell/
    [Cmdletbinding()]
    param(
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )
    process {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name
        If ( $Property ) {
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($null -eq $k.VirtualKeyCode -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}

# native touch implementation
# src: https://ss64.com/ps/syntax-touch.html
function Set-FileTime {
    param(
        [string[]]$paths,
        [bool]$only_modification = $false,
        [bool]$only_access = $false
    )

    begin {
        function updateFileSystemInfo([System.IO.FileSystemInfo]$fsInfo) {
            $datetime = Get-Date
            if ( $only_access ) {
                $fsInfo.LastAccessTime = $datetime
            } elseif ( $only_modification ) {
                $fsInfo.LastWriteTime = $datetime
            } else {
                $fsInfo.CreationTime = $datetime
                $fsInfo.LastWriteTime = $datetime
                $fsInfo.LastAccessTime = $datetime
            }
        }

        function touchExistingFile($arg) {
            if ( $arg -is [System.IO.FileSystemInfo] ) {
                    updateFileSystemInfo($arg)
                } else {
                $resolvedPaths = Resolve-Path $arg
                foreach ($rpath in $resolvedPaths) {
                    if ( Test-Path -type Container $rpath ) {
                        $fsInfo = New-Object System.IO.DirectoryInfo($rpath)
                    } else {
                        $fsInfo = New-Object System.IO.FileInfo($rpath)
                    }
                    updateFileSystemInfo($fsInfo)
                }
            }
        }

        function touchNewFile([string]$path) {
            #$null > $path
            Set-Content -Path $path -value $null;
        }
    }

    process {
        if ( $_ ) {
            if ( Test-Path $_ ) {
                touchExistingFile($_)
            } else {
                touchNewFile($_)
            }
        }
    }

    end {
        if ( $paths ) {
            foreach ( $path in $paths ) {
                if ( Test-Path $path ) {
                    touchExistingFile($path)
                } else {
                    touchNewFile($path)
                }
            }
        }
    }
}

if ( $IsWindows ) {

    function stree($directory = $pwd) {
        $gitrootdir = (Invoke-Command{Set-Location $args[0]; git rev-parse --show-toplevel 2>&1;} -ArgumentList $directory)

            if ( Test-Path -Path "$gitrootdir\.git" -PathType Container) {
                $newestExe = Get-Item "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe" | select -Last 1
                Write-Debug "Opening $gitrootdir with $newestExe"
                Start-Process -filepath $newestExe -ArgumentList "-f `"$gitrootdir`" log"
            } else {
                Write-Error "git directory not found"
            }
    }

if ( "${env:ChocolateyInstall}" -eq "" ) {
        function Install-Chocolatey {
            if (Get-Command choco -ErrorAction SilentlyContinue) {
                Write-Error "chocolatey already installed!"
            } else {
                Start-Process (Get-HostExecutable) -ArgumentList "-Command Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1') -verb RunAs"
            }
        }
        else {
            function choco { Start-Process (Get-HostExecutable) -ArgumentList "-noProfile -noLogo -Command choco.exe ${args}; pause" -verb runAs } 
        }
    }
}

function Get-HostExecutable {
if ( $PSVersionTable.PSEdition -eq "Core" ) {
    $ConsoleHostExecutable = (get-command pwsh).Source
} else {
    $ConsoleHostExecutable = (get-command powershell).Source
}
return $ConsoleHostExecutable
}

# don't override chocolatey sudo or unix sudo
if ( -not $(Test-CommandExists 'sudo') ) {
function sudo() {
    if ( $args.Length -eq 0 ) {
        Start-Process $(Get-HostExecutable) -verb "runAs"
    } elseif ( $args.Length -eq 1 ) {
        Start-Process $args[0] -verb "runAs"
    } else {
        Start-Process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}
}



# Helper Functions
#######################################################

function uptimef {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}
function unzipf ($path) {
	$dirname = (Get-Item $path).Basename
	echo("Extracting", $path, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $path -OutputPath $dirname -ShowProgress
}


# already expanded to save time https://github.com/nvbn/thefuck/wiki/Shell-aliases#powershell
if ( $(Test-CommandExists 'thefuck') ) {
    function fuck {
        $PYTHONIOENCODING_BKP=$env:PYTHONIOENCODING
        $env:PYTHONIOENCODING="utf-8"
        $history = (Get-History -Count 1).CommandLine

        if (-not [string]::IsNullOrWhiteSpace($history)) {
            $fuck = $(thefuck $args $history)
            if ( -not [string]::IsNullOrWhiteSpace($fuck) ) {
                if ( $fuck.StartsWith("echo") ) { $fuck = $fuck.Substring(5) } else { iex "$fuck" }
            }
        }
        [Console]::ResetColor()
        $env:PYTHONIOENCODING=$PYTHONIOENCODING_BKP
    }
    Set-Alias f fuck -Option AllScope
}

# hacks for old powerhsell versions
if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
function Get-ExitBoolean($command) { & $command | Out-Null; $?} ; Set-Alias geb   Get-ExitBoolean # fixed: https://github.com/PowerShell/PowerShell/pull/9849
function Use-Default # $var = d $Value : "DefaultValue" eg. ternary # fixed: https://toastit.dev/2019/09/25/ternary-operator-powershell-7/
{
    for ($i = 1; $i -lt $args.Count; $i++){
        if ($args[$i] -eq ":"){
            $coord = $i; break
        }
    }
    if ($coord -eq 0) {
        throw new System.Exception "No operator!"
    }
    if ($args[$coord - 1] -eq ""){
        $toReturn = $args[$coord + 1]
    } else {
        $toReturn = $args[$coord -1]
    }
    return $toReturn
}
Set-Alias d    Use-Default
}


if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin { $user = [Security.Principal.WindowsIdentity]::GetCurrent(); return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); }

    function Reopen-here { Get-Process explorer | Stop-Process Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"}

    function Reset-Spooler { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Stop-Service -Name Spooler -Force; Get-Item ${env:SystemRoot}\System32\spool\PRINTERS\* | Remove-Item -Force -Recurse; Start-Service -Name Spooler'" -verb "runAs"    }

    function subl { Start-Process "${Env:ProgramFiles}\Sublime Text\subl.exe" -ArgumentList $args -WindowStyle Hidden  } # hide subl shim script

    function get-tempfilesNfolders { foreach ($folder in @('C:\Windows\Temp\*', 'C:\Documents and Settings\*\Local Settings\temp\*', 'C:\Users\*\Appdata\Local\Temp\*', 'C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*', 'C:\Windows\SoftwareDistribution\Download', 'C:\Windows\System32\FNTCACHE.DAT')) {$_}  }
    function Export-Regestrykey { param ( $reg = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\' ,$outFile = 'H:\hkcu-regbackup.txt' ) get-childitem -path $reg | out-file $outFile }

    function start-bc ($REMOTE,$LOCAL,$BASE,$MERGED) { cmd /c "${Env:ProgramFiles}\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED" } #todo: replace hardcode with global variable pointing to path
    function start-cygwin { param ( $cygwinpath = "${Env:ProgramFiles}\cygwin64\" ) ."$cygwinpath\Cygwin.bat" }

    function Compare-ImagesMetadata { param ( $exifToolPath = "${Env:ProgramFiles}\geosetter\tools\" ,$inputA = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front (2).jpg" ,$inputB = "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front.jpg" ) ; $set1 = .\exiftool.exe -a -u -g1  $inputA ; $set2 = .\exiftool.exe -a -u -g1  $inputB ; Compare-Object $set1 $set2 | select -ExpandProperty inputobject }
    function new-SymbolicLink { param ( $where = 'H:\mina grejer\Till Github' ,$from = 'H:\mina grejer\Project shelf\Till Github' ) New-Item -Path $where -ItemType SymbolicLink -Value $from }

}

    if (Test-CommandExists 'search-Everything')
    { 
        function invoke-Everything([string]$filter) { @(Search-Everything  -filter $filter -global) }
        function invoke-FuzzyWithEverything($searchstring) { menu @(everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution
        function Every-execute ($inputx)                { $filter = "ext:exe $inputx" ; $filter } #& (Every-Menu $filter)
        function Every-AsHashMap                        { param( $filter = 'ext:psd1 \module')  $q = @{}                                                                                                                                                                                                                        ; everything $filter                                                                    | %{@{ name = (get -item $_).name                                  ; time=(get -item $_).LastWriteTime                            ; path=(get -item $_) } }                                                         | sort -object -property time                  | %{ $q[$_.name] = $_.path }                                                             ; $q                          | select -property values}
        function Every-execute                          { param( $filter = 'regex:".*\\data\\[^\\]*.ahk"',$navigate=$true) Every-Menu | %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { if($navigate)                                                                                                                                                                                                                                                                                                      {cd ($_ | split -path -parent)} ; . $_ } }
        function Every-invoke-expression                { param( $psFileFilter = 'convert-xlsx-to-csv.ps1') . ( everythnig $psFileFilter | select -first 1) } ; invoke-expression "ExcelToCsv -File 'D:\unsorted\fannyUtskick.xlsx'"
        function Every-Explore                          { param( $filter = 'ext:exe lasso') ; Every-Menu $filter | % { $path = if(!( Test-Path $_ -PathType Container)) { $_ | split-path -leaf } else {$_} ; explorer $path } }
        function Every-Menu                             { param( $filter) $a= @(everything $filter) ;  if($a.count -eq 1) {$a} else {menu $a} }
        function Every-AddType                          { param( $filter) $a = Every-Menu $filter ; Add-Type -Path $a }
    }

    if (Test-CommandExists 'git')
    { #todo: move to git aliases
        function invoke-gitCheckout () { & git checkout $args }
        function invoke-gitFetchOrig { git fetch origin }
        Function invoke-GitLazy($path,$message) { cd $path ; git lazy $message } ; 
        Function invoke-GitLazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout
        function invoke-gitRemote { param ($subCommand = 'get-url',$name = "origin" ) git remote $subCommand $name }
        Function invoke-GitSubmoduleAdd([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch
        function commitPath($path,$message) {$c = $pwd; cd $path ; git add . ; git commit -am $message ; cd $c }
    }

    if ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue)) {
        function find-historyAppendClipboard($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard
        function find-historyInvoke($searchstring) { $path = get-historyPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.
    }


function split-fileByLineNr { param( $pathName = '.\gron.csv',$OutputFilenamePattern = 'output_done_' , $LineLimit = 60) ;
$ext = $pathName | split-path -Extension 
 $inputx = Get-Content ;
 $line = 0 ;
 $i = 0 ;
 $path = 0 ;
 $start = 0 ;
 while ($line -le $inputx.Length) {
      if ($i -eq $LineLimit -Or $line -eq $inputx.Length) {
    $path++ ;
    $pathname = "$OutputFilenamePattern$path$ext" ;
    $inputx[$start..($line - 1)] | Out -File $pathname -Force ;
    $start = $line ;
 
    $i = 0 ;
    Write-Host "$pathname" ;
    } ;
 $i++ ;
 $line++ 
 }
}
function split-fileByMatch($pathName , $regex) { #param( $pathName = 'C:\Users\crbk01\Documents\WindowsPowerShell\snipps\Modules\Todo SplitUp.psm1' , $regex = '(?<=function\s)[^\s\(]*') ;
 $ext = ($pathName | split-path -Extension)
 $parent = ($pathName | split-path -Parent)
 $OriginalName = ($pathName | split-path -LeafBase)
 $inputx = Get-Content $pathName; $line = 0 ; $i = 0 ; $start = @(select-string -path $pathName -pattern $regex ) | select linenumber ; $LineLimit = $start | select -Skip 1 ; $names = @() ; [regex]::matches($inputx,$regex).groups.value | %{$names+= $_ }
 $occurence = 0 ;
 

 while ($line -le $inputx.Length) {
    if ($i -eq ([int]$LineLimit[$occurence].linenumber -1) -Or $line -eq $inputx.Length) 
    {    
        $currentName = $names[$occurence];
        $pathname = Join-Path -path $parent -childPath "$OriginalName-$currentName$ext" ;
        $u = ([int]$start[$occurence].linenumber -1)
    
        $inputx[$u..($line - 1)] > $pathname
    
        $occurence++ ; 
        Write-Host "$u..($line - 1)$pathname" ;
    };
 $i++ ;
 $line++ 
 }
}



#function aliasCode { & $env:code }
function ..                                     { Set-Location ".." }
function ....                                   { Set-Location (Join-Path -Path ".." -ChildPath "..") }
function all                                    { process                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_ | Select-Object * } }  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7#piping-objects-to-functions
function cdc                                    { Set-Location "$XDG_CONFIG_HOME" }
function cdcheat                                { Set-Location "$CHEATS_DIR" }
function cdd                                    { Set-Location "$DESKTOP_DIR" }
function cddd                                   { Set-Location "$DEVEL_DIR" }
function cddev                                  { Set-Location "$DEVEL_DIR" }
function cdn                                    { Set-Location "$NOTES_DIR" }
function cdports                                { Set-Location "$PORTS_DIR" }
function cdt                                    { Set-Location "$TODO_DIR" }
function clear-Days_Back                        { param( $path = "C:\Support\SQLBac\" ,$Daysback = "0" ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $CurrentDate = Get-Date $DatetoDelete = $CurrentDate.AddDays($Daysback) Get-ChildItem $path | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item }
function ConvertFrom-Bytes                      { param( [string]$bytes, [string]$savepath ) $dir = Split-Path $savepath if (!(Test-Path $dir))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { md $dir | Out-Null } [convert]::FromBase64String($bytes) | Set-Content $savepath -Encoding Byte }
function ConvertTo-Bytes ( [string]$path )      { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } [convert]::ToBase64String((Get-Content $path -Encoding Byte)) }
function df                                     { get-volume }
function enter-dir                              { param( $path = '%USERPROFILE%\Desktop\' ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } Set-Location $Path }; #if no param, navigate to desktop # 5. 更改工作目录 # 输入要切换到的路径 # 用法示例：cd C:/ # 默认路径：D 盘的桌面
function exit-Nrenter                           { shutdown /r } #reboot
function export($name, $value)                  { set-item -force -path "env:$name" -value $value; }
function foldercontain($folder,$name)           { $q = get-childitem $folder; return $q -contains $name }
function Get-AllNic                             { Get-NetAdapter | Sort-Object -Property MacAddress } # 1. 获取所有 Network Interface
function get-Childnames                         { param( $path = $pwd) (Get-ChildItem -path $path).Name ; Write-Host("") }; # 3. 查看目录 ls & ll
function Get-DefaultAliases                     { Get-Alias | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_.Options -match "ReadOnly" }}
function get-envVar                             { Get-Childitem -Path Env:*}
function get-EspHeader                          { param( $path = '.\FormiD.esp', $max = 13,$headerSize = 3 ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $q = ((( -join (gc $path                                                                                                                                                                                    | select -first $headerSize)) -replace "[^\w. ]                                                                                                                                                                                                                                                                                                                                         {1,}","å").split("å") -match "^.*[.](esp |esm)$")                                                           ; $q                                                           | ?                                                                                                                                       {($q                                                                           | select -first $max) -NotContains $_}}
function get-historyPath                        { (Get-PSReadlineOption).HistorySavePath }
function Get-IPv4Routes                         { Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  {$_.NextHop -ne '0.0.0.0'} } # 2. 获取 IPv4 关键路由
function Get-IPv6Routes                         { Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  {$_.NextHop -ne '::'} } # 3. 获取 IPv6 关键路由
function get-isFolder                           {$PSBoundParameters -is [system.in.folder]}
function get-parameters                         { Get-Member -Parameter *}
function get-RegInstallpaths                    { Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall                                                                                                                                                                                          | %                                                                                                                                                                                                                                                                                                                                                                                           { Get -ItemProperty $_.PsPath }                                                     | Select DisplayName,InstallLocation }
function get-whatpulse                          { param( $program,$path) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $query = "select rightstr(path,instr(reverse(path),'/') -1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)" ; $adapter = newSqliteConnection -source (Everything 'whatpulse.db')[0] -query $query   ; $b=@($data.item('exe'))                                          ; $a = @($data.item('path'))                                   ; $i=0                                                                            ; while($i -lt $a.Length)                                                   {$res[$b[$i]]=$a[$i] ; $i++ }                                                                                 ; $res                        | where                                                                                                                                                                  { $_.name -match $program -and $_.path -match $path}}
function grep                                   { process                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_ | Select-String -Pattern $args } } # function grep($regex, $dir)                                                                                                                                                                                                                                                { if ( $dir )                                                                                                                                                                                                                                                                                                                                                                                                                                                                           { ls $dir | select-string $regex return } $input | select-string $regex }
function grepv($regex)                          { $input | ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     { !$_.Contains($regex) } }
function Initialize-Profile                     { . $PROFILE.CurrentUserCurrentHost} #function initialize-profile                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { & $profile } #reload-profile is an unapproved verb.
function invoke-Nmake                           { nmake.exe $args -nologo }; # 1. 编译函数 make
function invoke-powershellAsAdmin               { Start-Process powershell -Verb runAs } #new ps OpenAsADmin
function join-ByRuncunfig { param( $prefix='[$]APPLICATION_CONFIG_DIR[$][/]'
,$refixReplace='C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\', 
$runconfig="TillMinaMedelanden.run.xml",$output='runConfig/Combined.sql') [xml]$xml=get -content $runConfig -Encoding UTF8 ; $xml.component.configuration.'script -file' | %                                                                                                                                                                                                                                                                                    
 {$_.value -replace $prefix, ($prefixReplace -replace '\\','/')} | %                                                                                                                                                                                                                                                  {" - -:$_"                                                  
 ; get -content -path $_ -Encoding UTF8                                            ; "go" } >> $output }
function list                                   { process                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_ | Format-List * } } # fl is there by default
function man                                    { Get-Help $args[0] | out-host -paging }
function md                                     { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function measure-ExtOccurenseRecursivly         { param( $path = "D:\Project Shelf\MapBasic" ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } Get-ChildItem -Path $path -Recurse -File | group Extension -NoElement  | sort Count -Descending | select -Property name }
function measure-words                          { param( $inputStream = (Get -ChildItem | %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      { Get -Content $_.name }), $regex="[^a-z0-9_-]") $hash = @{} ; $a="" ; $inputStream | %                                                                                                                                                                                                                                                                                                                                                                                                                                                           {$a+=$_} ; $a -split $regex | %                                                                                                                                                                                                                                  { $_.tolower()} | %                                                                                                                           {$hash[$_]++} ; $sorted= % {$hash.GetEnumerator() | sort -object {[int]$_.value}} ; return $sorted} ; $sorted | where{$_.name -notmatch "^\d+$"} | where{$_.name.length -gt 4 }
function mkdir                                  { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function My-Scripts                             { Get-Command -CommandType externalscript }
function open-here                              { param( $Path = $pwd ) Invoke-Item $Path }; # 4. 打开当前工作目录 # 输入要打开的路径 # 用法示例：open C:\ # 默认路径：当前工作文件夹
function open-ProfileFolder                     { explorer (split-path -path $profile -parent)}
function pgrep($name)                           { Get-Process $name }
function pkill($name)                           { Get-Process $name -ErrorAction SilentlyContinue | kill }
function pull ()                                { & get pull $args }
function read-aliases                           { Get-Alias | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       { $_.Options -notmatch "ReadOnly" }}
function read-EnvPaths                          { ($Env:Path).Split(";") }
function read-headOfFile                        { param( $linr = 10, $path ) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" }  gc -Path $path  -TotalCount $linr }
function read-json                              { param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $input ) $json = [ordered]@{}; ($input).PSObject.Properties | %                                                                                                                                                                                                                                                                                 { $json[$_.Name] = $_.Value } $json.SyncRoot }
function read-paramNaliases ($command)          { (Get-Command $command).parameters.values | select name, @{n='aliases';e={$_.aliases}} } 
function read-pathsAsStream                     { get-childitem | out-string -stream } # filesInFolAsStream ;
function read-uptime                            { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION=                                                                                                                                                                                                                                                                                 {$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?
function Remove-CustomAliases                   { Get-Alias | Where-Object                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       { ! $_.Options -match "ReadOnly" } | %                                                                                                                                                                                                                                                                               { Remove-Item alias:$_ }} # https://stackoverflow.com/a/2816523
function remove-TempfilesNfolders               { foreach ($folder in get-tempfilesNfolders)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     {Remove-Item $folder -force -recurse} }
function Sanatize-path                          { param( $path='G:\mhk',$replaceChar='_') if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $regex= "[^\)\w \\\ -:.åäöÅÄÖ %\                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        {,~$\(!@¤£é&=#§]"                                                                                                                                                                               ; Get -ChildItem $path -Recurse                                                         | Where -Object              {$_.name -match $regex}                            | rename -item -newName                                                                                                                                                                                                                                                                                                                                                                                                              {$_.name -replace $regex,$replaceChar}}
function sed($path, $find, $replace)            { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" }  (Get-Content $path).replace("$find", $replace) | Set-Content $path }
function set-FileEncodingUtf8 ( [string]$path ) { if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } sc $path -encoding utf8 -value(gc $path) }
function set-x                                  { Set-PSDebug -trace 2}
function set+x                                  { Set-PSDebug -trace 0}
function sort-PathByLvl                         { param( $inputList) $inputList                                                                                                                                                                                                                                          | Sort                                                                                                                                                                                                                                                                                                                                                                                   {($_ -split '\\').Count},                                                                                                                                                                                                                                                                                            {$_} -Descending                                       | select -object -first 2                                          | %                                                                                                                                                                                                                                                                                                                                                           { $error.clear()                                            ; try                                                                                                                                                                                                { out -null -input (test -ModuleManifest $_ > '&2>&1' ) } catch                                                                               { "Error" } ; if (!$error) { $_ } }}
function start-BrowserFlags                     { vivaldi "vivaldi://flags" } #todo: use standard browser instead of hardcoded
function start-notepad-profile                  { notepad $profile}
function string                                 { process                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        { $_ | Out-String -Stream } }
function touch($path)                           { "" | Out-File $path -Encoding ASCII }
function which($name)                           { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more
Remove-Item alias:ls -ea SilentlyContinue ; function ls { Get-Childitem} # ls -al is musclememory by now so ignore all args for this "alias"

#-------------------------------    Functions END     -------------------------------

#-------------------------------   Set alias BEGIN    -------------------------------
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators") ; $TAType::Add('accelerators',$TAType)

set-alias accelerators       [accelerators]::Get
set-alias edprofile          start-Notepad-Profile
set-alias exp-pro            open-ProfileFolder
set-alias kidStream          get-childitem                          |       out-string -stream
set-alias history            (Get-PSReadlineOption).HistorySavePath 
set-alias parameters         get-parameters
set-alias start-su           start-powershellAsAdmin
set-alias version            $PSVersionTable                        #       bash-like
Set-Alias cat                Get-Content                            -Option AllScope
Set-Alias cd                 Set-Location                           -Option AllScope
Set-Alias clear              Clear-Host                             -Option AllScope
Set-Alias cp                 Copy-Item                              -Option AllScope
Set-Alias history            Get-History                            -Option AllScope
Set-Alias kill               Stop-Process                           -Option AllScope
Set-Alias lp                 Out-Printer                            -Option AllScope
Set-Alias mv                 Move-Item                              -Option AllScope
Set-Alias ps                 Get-Process                            -Option AllScope
Set-Alias pwd                Get-Location                           -Option AllScope
Set-Alias which              Get-Command                            -Option AllScope   
Set-Alias open               Invoke-Item                            -Option AllScope
Set-Alias basename           Split-Path                             -Option AllScope
Set-Alias realpath           Resolve-Path                           -Option AllScope   #       cmd-like Set-Alias rm      Remove-Item -Option   AllScope
Set-Alias rmdir              Remove-Item                            -Option AllScope
Set-Alias echo               Write-Output                           -Option AllScope
Set-Alias cls                Clear-Host                             -Option AllScope   
Set-Alias chdir              Set-Location                           -Option AllScope
Set-Alias copy               Copy-Item                              -Option AllScope
Set-Alias del                Remove-Item                            -Option AllScope
Set-Alias dir                Get-Childitem                          -Option AllScope
Set-Alias erase              Remove-Item                            -Option AllScope
Set-Alias move               Move-Item                              -Option AllScope
Set-Alias rd                 Remove-Item                            -Option AllScope
Set-Alias ren                Rename-Item                            -Option AllScope
Set-Alias set                Set-Variable                           -Option AllScope
Set-Alias type               Get-Content                            -Option AllScope
Set-Alias env                Get-Environment                        -Option AllScope   #       custom   aliases
Set-Alias flush-dns          Clear-DnsClientCache                   -Option AllScope
Set-Alias touch              Set-FileTime                           -Option AllScope   
set-alias lsx                get-Childnames                         -Option AllScope
set-alias filesinfolasstream read-childrenAsStream                  -Option AllScope
set-alias bcompare           start-bc                               -Option AllScope   
set-alias GitAdEPathAsSNB    invoke-GitSubmoduleAdd                 -Option AllScope
set-alias GitUp              invoke-GitLazy                         -Option AllScope
set-alias gitSilently        invoke-GitLazySilently                 -Option AllScope
set-alias gitSingleRemote    invoke-gitFetchOrig                    -Option AllScope
set-alias executeThis        invoke-FuzzyWithEverything             -Option AllScope   
set-alias filesinfolasstream read-pathsAsStream                     -Option AllScope
set-alias everything         invoke-Everything                      -Option AllScope
set-alias make               invoke-Nmake                           -Option AllScope
set-alias MyAliases          read-aliases                           -Option AllScope
set-alias OpenAsADmin        invoke-powershellAsAdmin               -Option AllScope
set-alias home               open-here                              -Option AllScope
set-alias pastDo             find-historyInvoke                     -Option AllScope
set-alias pastDoEdit         find-historyAppendClipboard            -Option AllScope
set-alias HistoryPath        (Get-PSReadlineOption).HistorySavePath -Option AllScope
set-alias reboot             exit-Nrenter                           -Option AllScope
set-alias browserflags       start-BrowserFlags                     -Option AllScope
set-alias df                 get-volume                             -Option AllScope
set-alias printpaths         read-EnvPaths                          -Option AllScope
set-alias reload             initialize-profile                     -Option AllScope
set-alias uptime             read-uptime                            -Option AllScope   
set-alias getnic             get-mac                                -Option AllScope   #       1.       获取所有      Network Interface   set-alias ll       Get-ChildItem -Option AllScope
set-alias getip              Get-IPv4Routes                         -Option AllScope
set-alias getip6             Get-IPv6Routes                         -Option AllScope
set-alias os-update          Update-Packages                        -Option AllScope
set-alias remote             invoke-gitRemote                       -Option AllScope   
set-alias gitsplit           subtree-split-rm-commit                -Option AllScope
set-alias isFolder           get-isFolder                           -Option AllScope
set-alias start-powershellAsAdmin invoke-powershellAsAdmin          -Option AllScope
set-alias psVersion          $PSVersionTable.PSVersion.Major        -Option AllScope 
#-------------------------------    Set alias END     -------------------------------

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"
