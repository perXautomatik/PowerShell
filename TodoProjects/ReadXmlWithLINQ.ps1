

Add-Type -AssemblyName System.Xml.Linq 


$Raw=@'
<root>
  <child id='1'/>
  <child id='2'>Child 1
    <grandchild id='3'>GC1</grandchild>
    <grandchild id='4' />
  </child>
</root>
'@

#same thing
    $parsed=[System.Xml.Linq.XDocument]$Raw
    $parsed = [System.Xml.Linq.XDocument]::Parse($Raw);

$c = 'C:\temp\temp.txt'
    $Loaded = [System.Xml.Linq.XDocument]::Load($c)

#$parsed.Descendants()|select name,value


$elements = $parsed.Element("root").Elements("child");

$elementslist = [System.Linq.Enumerable]::ToList($elements);
$elementslist


#--------- write to xml




$Raw=@'
<?xml version="1.0" encoding="utf-8"?>
<TaskDefinition>
	<DestinationPath>E:\</DestinationPath>
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


$parsed = [System.Xml.Linq.XDocument]::Parse($Raw);
[System.Xml.Linq.XElement]$eq = $parsed.Element("TaskDefinition").Element("SourcePaths")

$elements = $eq.Elements("Path");

$elementslist = [System.Linq.Enumerable]::ToList($elements);

$eq.RemoveAll()

foreach ($e in 1..10) 
{
    $qt = New-Object -TypeName System.Xml.Linq.XElement -ArgumentList ("Path",$c )
    
    $eq.add( $qt)
}
$parsed