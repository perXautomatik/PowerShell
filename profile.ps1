
echo "profile loaded"
#-------------------------------   Set alias BEGIN    -------------------------------
set-alias -name reload-profile -value reloadProfile
set-alias -name uptime -value uptimef
set-alias -name print-path -value printpath

set-alias -name unzip -value unzipf


# 1. 编译函数 make
function aliasMakeThings {
	nmake.exe $args -nologo
};
set-alias -Name make -Value aliasMakeThings

# 2. 更新系统 os-update
set-alias -Name os-update -Value Update-Packages

# 3. 查看目录 ls & ll
function aliasListDirectory {
	(Get-ChildItem).Name
	Write-Host("")
};
#set-alias -Name ls -Value aliasListDirectory
set-alias -Name ll -Value Get-ChildItem

# 4. 打开当前工作目录
function aliasOpenCurrentFolderF {
	param
	(
		# 输入要打开的路径
		# 用法示例：open C:\
		# 默认路径：当前工作文件夹
		$Path = '.'
	)
	Invoke-Item $Path
};
set-alias -Name open-current-folder -Value aliasOpenCurrentFolderF

# 5. 更改工作目录
function aliasChangeDirectory {
	param (
		# 输入要切换到的路径
		# 用法示例：cd C:/
		# 默认路径：D 盘的桌面
		$Path = 'D:\Users\newton\Desktop\'
	)
	Set-Location $Path
};

#######################################################
#set-alias -Name cd -Value aliasChangeDirectory -Option AllScope

<<<<<<< HEAD
function uptime {
=======
if ( -Not (Test-CommandExists 'sh') ){ Set-Alias sh   git-sh -Option AllScope }
function uptimef {
>>>>>>> 8e02b0f2 ([chore] Renamed snipps)
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}

function print-path {
	($Env:Path).Split(";")
}

function unzip ($file) {
	$dirname = (Get-Item $file).Basename
	echo("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}


# filesInFolAsStream ;
function aliasfilesInFolAsStream {
	get-childitem | out-string -stream
}
set-alias -Name filesinfolasstream -Value aliasfilesInFolAsStream

#new ps OpenAsADmin
function aliasopenasadminf {
	Start-Process powershell -Verb runAs
}

set-alias -Name OpenAsADmin -Value aliasopenasadminf

Function aliasEFunc {Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | Where{ $_ -notmatch 'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' }}  ;
set-alias -name EveryGitRepo -Value aliasEFunc

Function aliasEGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ;
set-alias -name gitSilently -Value aliasEGSfunc

Function aliasEGSRfunc
{
	out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ;
	 %{$proc -split '\n'} | %{ $properties = $_ -split '[\t\s]';
	  $remote = try{ New-Object PSObject -Property @{ name = $properties[0].Trim();
	    url = $properties[1].Trim();  type = $properties[2].Trim() } } catch {'noRemote'} ;
	     $remote | select-object -first 1 | select url}
	  } ;
set-alias -name gitSingleRemote -Value aliasEGSRfunc

function aliasFunctionEverything([string]$filter)
	{Search-Everything -filter $filter -global}

set-alias -name code -value '& $env:code'

set-alias -name everything -value aliasFunctionEverything

function aliasPshellHistoryPath {
	(Get-PSReadlineOption).HistorySavePath
}
set-alias -name pshelHistorypath -value aliasPshellHistoryPath

function aliasPastDo($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ }
}

set-alias -name pastDo -value aliasPastDo

function aliasPastDoEdit($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }
}

set-alias -name pastDoEdit -value aliasPastDoEdit

function aliasExecuteThis($searchstring) {
menu @(everything "ext:exe $searchString") | %{& $_ }
}

set-alias -name executeThis -value aliasExecuteThis


function aliasMyAliases {
Get-Alias -Definition alias* | select name
}

set-alias -name MyAliases -value aliasMyAliases




#Git Ad $leaf as submodule from $remote and branch $branch
Function aliasEFuncGT([string]$leaf,[string]$remote,[string]$branch)
{
 git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch
 } ;
set-alias -name GitAdEPathAsSNB -value aliasEFuncGT

Function aliasEGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ;
set-alias -name GitUp -value aliasEGLp


function pull () { & get pull $args }
<<<<<<< HEAD
function checkout () { & git checkout $args }

#del alias:gc -Force
#del alias:gp -Force

#set-alias -Name gc -Value checkout
#set-alias -Name gp -Value pull


function aliasbc($REMOTE,$LOCAL,$BASE,$MERGED) {
cmd /c "C:\Users\crbk01\Desktop\WhenOffline\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED"
}
set-alias -Name bcompare -Value aliasbc
=======
function read-aliases { Get-Alias | Where-Object { $_.Options -notmatch "ReadOnly" }}
function read-childrenAsStream { get-childitem | out-string -stream }
function read-EnvPaths { ($Env:Path).Split(";") }
function read-headOfFile { param ( $linr = 10, $file ) gc -Path $file  -TotalCount $linr }
function read-json { param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $input ) $json = [ordered]@{}; ($input).PSObject.Properties | % { $json[$_.Name] = $_.Value } $json.SyncRoot }
function read-paramNaliases ($command) { (Get-Command $command).parameters.values | select name, @{n='aliases';e={$_.aliases}} }
function read-pathsAsStream { get-childitem | out-string -stream } # filesInFolAsStream ;
function read-uptime { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?
function Remove-CustomAliases { Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }} # https://stackoverflow.com/a/2816523
function remove-TempfilesNfolders { foreach ($folder in get-tempfilesNfolders) {Remove-Item $folder -force -recurse} }
function sed($file, $find, $replace) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" }  (Get-Content $file).replace("$find", $replace) | Set-Content $file }
function set-FileEncodingUtf8 ( [string]$file ) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" } sc $file -encoding utf8 -value(gc $file) }
function set-x { Set-PSDebug -trace 2}
function set+x { Set-PSDebug -trace 0}
function start-BrowserFlags { vivaldi "vivaldi://flags" } #todo: use standard browser instead of hardcoded
function string { process { $_ | Out-String -Stream } }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more
function get-mac { Get-NetAdapter | Sort-Object -Property MacAddress }
Remove-Item alias:ls -ea SilentlyContinue ; function ls { Get-Childitem} # ls -al is musclememory by now so ignore all args for this "alias"
>>>>>>> 8e02b0f2 ([chore] Renamed snipps)

function aliasviv {
vivaldi "vivaldi://flags"
}
set-alias -Name browserflags -Value aliasviv

function aliasrb {
shutdown /r
}
set-alias -Name reboot -Value aliasrb

#-------------------------------    Set alias END     -------------------------------



# Unixlike commands
#######################################################

function df {
	get-volume
}

function sed($file, $find, $replace){
	(Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function sed-recursive($filePattern, $find, $replace) {
	$files = ls . "$filePattern" -rec
	foreach ($file in $files) {
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace "$find", "$replace" } |
		Set-Content $file.PSPath
	}
}

function grep($regex, $dir) {
	if ( $dir ) {
		ls $dir | select-string $regex
		return
	}
	$input | select-string $regex
}

function grepv($regex) {
	$input | ? { !$_.Contains($regex) }
}

function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
	ps $name
}

function touch($file) {
	"" | Out-File $file -Encoding ASCII
}

function sudo {
	$file, [string]$arguments = $args;
	$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	$psi.Arguments = $arguments;
	$psi.Verb = "runas";
	$psi.WorkingDirectory = get-location;
	[System.Diagnostics.Process]::Start($psi) >> $null
}

# https://gist.github.com/aroben/5542538
function pstree {
	$ProcessesById = @{}
	foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
		$ProcessesById[$Process.ProcessId] = $Process
	}

	$ProcessesWithoutParents = @()
	$ProcessesByParent = @{}
	foreach ($Pair in $ProcessesById.GetEnumerator()) {
		$Process = $Pair.Value

		if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
			$ProcessesWithoutParents += $Process
			continue
		}

		if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
			$ProcessesByParent[$Process.ParentProcessId] = @()
		}
		$Siblings = $ProcessesByParent[$Process.ParentProcessId]
		$Siblings += $Process
		$ProcessesByParent[$Process.ParentProcessId] = $Siblings
	}

	function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
		$Process = $ProcessesById[$ProcessId]
		$Indent = " " * $IndentLevel
		if ($Process.CommandLine) {
			$Description = $Process.CommandLine
		} else {
			$Description = $Process.Caption
		}

		Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
		foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
			Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
		}
	}

	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
	Write-Output ("{0,6} {1}" -f "---", "------------")

	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
		Show-ProcessTree $Process.ProcessId 0
	}
}


#-------------------------------    Functions BEGIN   -------------------------------
# Python 直接执行
$env:PATHEXT += ";.py"

# 更新系统组件
function Update-Packages {
	# update pip
	# Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
	# $a = pip list --outdated
	# $num_package = $a.Length - 2
	# for ($i = 0; $i -lt $num_package; $i++) {
	# 	$tmp = ($a[2 + $i].Split(" "))[0]
	# 	pip install -U $tmp
	# }

	# update conda
	Write-Host "Step 1: 更新 Anaconda base 虚拟环境" -ForegroundColor Magenta -BackgroundColor Cyan
	conda activate base
	conda upgrade python

	# update TeX Live
	$CurrentYear = Get-Date -Format yyyy
	Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
	tlmgr update --self
	tlmgr update --all

	# update Chocolotey
	# Write-Host "Step 3: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
	# choco outdated

	# update Apps using winget
	Write-Host "Step 3: 通过 winget 更新 Windows 应用程序" -ForegroundColor Magenta -BackgroundColor Cyan
	winget upgrade
	winget upgrade --all

}
#-------------------------------    Functions END     -------------------------------


#-------------------------------   Set Network BEGIN    -------------------------------
# 1. 获取所有 Network Interface
function Get-AllNic {
	Get-NetAdapter | Sort-Object -Property MacAddress
}
set-alias -Name getnic -Value Get-AllNic

# 2. 获取 IPv4 关键路由
function Get-IPv4Routes {
	Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
}
set-alias -Name getip -Value Get-IPv4Routes

# 3. 获取 IPv6 关键路由
function Get-IPv6Routes {
	Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
}
set-alias -Name getip6 -Value Get-IPv6Routes
#-------------------------------    Set Network END     -------------------------------
