############################################################################
#Project: How to Combine JSON objects using Array in PowerShell
#Developer: Thiyagu S (dotnet-helpers.com)
#Tools : PowerShell 5.1.15063.1155 [irp]
#E-Mail: mail2thiyaguji@gmail.com 
###########################################################################
 
$totalEMPDetails = @()
#Invoke-WebRequest -Uri 'https://gist.github.com/perXautomatik/a61f28b31538eecf42fae3641051b1ac/raw/a7264fb02204494f355748d13dbeefa5f9a350ae/WorkPersonal' -OutFile tiny.JSON
#Invoke-WebRequest -Uri 'https://gist.github.com/perXautomatik/a61f28b31538eecf42fae3641051b1ac/raw/a7264fb02204494f355748d13dbeefa5f9a350ae/OperaGxWorkPersonal' -OutFile larger.JSON



$Ind_EMPDetails = (Get-Content '.\tiny.JSON' | ConvertFrom-Json -NoEnumerate -Depth 90 -AsHashtable ).bookmarks.children #.children
$UK_EMPDetails =  (Get-Content '.\larger.JSON' | ConvertFrom-Json -NoEnumerate -Depth 90 -AsHashtable).bookmarks.children #.children
$header = (Get-Content '.\tiny.JSON' | ConvertFrom-Json -NoEnumerate -AsHashtable ) 

$joined = @{}
foreach ($h in $Ind_EMPDetails.GetEnumerator() )
{
#    $joined[$h.Name] = $h.Value
}
foreach ($h in $UK_EMPDetails.GetEnumerator() )
{
#    $joined[$h.Name] = $h.Value
}
#[hashtable]$header.bookmarks.UnfiledFolder = $totalEMPDetails


$header.bookmarks[0].children = $UK_EMPDetails;
$header.bookmarks[0].children += $Ind_EMPDetails;

 $header | ConvertTo-Json -Depth 100 > 'combined.json'

 #$header.bookmarks.children.keys > 'combined.json'