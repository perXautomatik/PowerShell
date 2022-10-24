$csv = '
"Name", "Value"
"srcHost",  "machine1"
"srcPath",  "c:\data\source\mailbox.pst"
"destHost", "machine2"
"destPath", "d:\backup"
'

$csv | ConvertFrom-Csv -Header Name,Value | Set-Variable
$srcHost