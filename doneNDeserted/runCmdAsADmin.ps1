function start-Cmd($cmdArgumentsToRunMsBuildInVsCommandPrompt) {

$process = New-Object System.Diagnostics.Process;
$process.StartInfo.UseShellExecute = $false;
$process.StartInfo.RedirectStandardOutput = $true;
$process.StartInfo.FileName = "cmd.exe";
$process.StartInfo.Arguments = $cmdArgumentsToRunMsBuildInVsCommandPrompt;
$process.Start();
$outputStream = $process.StandardOutput;
$outputStream.ReadToEnd();
} 

$output = [string](start-cmd '/C netstat -ab && exit')

$output