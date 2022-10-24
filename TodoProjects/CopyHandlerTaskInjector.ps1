$target = 'C:\portable\FirefoxPortableESR'
$src = 'U:\PortableApplauncher\AppManager\.free\FirefoxPortable\'


$Input=[string[]]'
U:\PortableApplauncher\AppManager\.free\FirefoxPortable\App\Firefox\fonts\TwemojiMozilla.ttf
U:\PortableApplauncher\AppManager\.free\FirefoxPortable\App\Firefox\default-browser-agent.exe
U:\PortableApplauncher\AppManager\.free\FirefoxPortable\App\Firefox\omni.ja
U:\PortableApplauncher\AppManager\.free\FirefoxPortable\App\Firefox\xul.dll
' -split('\n')

$Input  = $Input | % {$_.trim([System.IO.Path]::GetInvalidFileNameChars())}



#this function was not good enough as i converts the variable between turns

function WrapInTemp() {
param(
$variable
)

$tmp = New-TemporaryFile
$variable | Out-String -Stream | Out-File -FilePath $tmp.FullName

return $tmp.FullName

}
#(wrapInTemp -variable $test)


$Raw=@'
<?xml version="1.0" encoding="utf-8"?>
<TaskDefinition>
	<DestinationPath>B:\</DestinationPath>
	<OperationType>1</OperationType>
	<SourcePaths>
		<Path>C:\Program Files\Copy Handler\libictranslate64u.dll</Path>
		<Path>C:\Program Files\Copy Handler\License.txt</Path>
		<Path>C:\Program Files\Copy Handler\mfc120u.dll</Path>
		<Path>C:\Program Files\Copy Handler\mfcm120u.dll</Path>
		<Path>C:\Program Files\Copy Handler\msvcp120.dll</Path>
	</SourcePaths>
	<Version>1</Version>
</TaskDefinition>
'@





cd $src
$relativeSrcTarget = $Input | ?{ Test-Path -Path $_ } | select @{name='src';expression={$_}},@{name='relative';expression={ resolve-path -relative $_ }} | select *,@{name='target'; expression={ ( [io.path]::getFullPath( (join-path $target $_.relative))) | Split-Path -Parent } }

$grouped = $relativeSrcTarget | Group-Object -Property target

cd 'C:\Program Files\Copy Handler'

$grouped | 
% { 

    $parsed = ([System.Xml.Linq.XDocument]::Parse($Raw));
        
    [System.Xml.Linq.XElement]$Spath = $parsed.Element("TaskDefinition").Element("SourcePaths")
    $Spath.RemoveAll()
        
    foreach ( $tg in $_.Group ) {
        $qt = New-Object -TypeName System.Xml.Linq.XElement -ArgumentList ("Path",$tg.src )
    
        $Spath.add($qt) 
     }    

    [System.Xml.Linq.XElement]$Dpath = $parsed.Element("TaskDefinition").Element("DestinationPath")
    $Dpath.RemoveAll()
    
    $Dpath.SetValue($_.name)
    

    $Dpath

    [System.IO.File]::WriteAllText("C:\temp\Task5.xml", $parsed.ToString());
       
    .\ch64.exe --ImportTaskDefinition C:\temp\Task5.xml          
}

# next step, memmoryMapped file handle instead of writing to files?
