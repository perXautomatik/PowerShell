use what changed to install irfanviewer. then uninstall and just take the file asigning.
install everything
bcompare.
steam.

all images linked to one hdd

all sounds ans music to one hdd

do so for all extensions, question being, would it be extreamly heavy for the storage?
we copy the full path to the new drive to 

it would be easier to overview batchprocesses, easier to find duplicates and possible to identify filesm whoere actually the same but due to some minor detale consideed to be different.

wonder if one could guess file extension while processing the files, like files without filename, the link can be renamed with actual filename after all.
Imports PdfSharp.Drawing
Imports PdfSharp.Pdf
Imports System.Text.RegularExpressions
imports System
imports System.Collections.Generic

param($drive1, $drive2, $drive3)
$diskdata = get-PSdrive $drive1 | Select-Object Used,Free
write-host "$($drive1) has  $($diskdata.Used) Used and $($diskdata.Free) free"
if ($drive2 -ne $null) {
$diskdata = get-PSdrive $drive2 | Select-Object Used,Free
write-host "$($drive2) has  $($diskdata.Used) Used and $($diskdata.Free) free"
    if ($drive3 -ne $null) {
    $diskdata = get-PSdrive $drive3 | Select-Object Used,Free
    write-host "$($drive3) has  $($diskdata.Used) Used and $($diskdata.Free) free"
    }
    else
