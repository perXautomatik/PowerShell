if ($GLOBAL:PWD -isnot [System.Management.Automation.PathInfo])
{
	$GLOBAL:PWD = get-location
}

if ($GLOBAL:CDHIST -isnot [System.Collections.ArrayList])
{
	$GLOBAL:CDHIST = [System.Collections.Arraylist]::Repeat($PWD, 1)
}

$cwd = get-location
$count = $GLOBAL:CDHIST.count

if ($args.length -eq 0) 
{
	set-location $HOME 
	$GLOBAL:PWD = get-location
	$GLOBAL:CDHIST.Remove($GLOBAL:PWD)
	if ($GLOBAL:CDHIST[0] -ne $GLOBAL:PWD) 
	{
		$GLOBAL:CDHIST.Insert(0,$GLOBAL:PWD) 
	}
}
elseif ($args[0] -like "-[0-9]*") 
{
	$num = $args[0].Replace("-","")
	$GLOBAL:PWD = $GLOBAL:CDHIST[$num]
	set-location $GLOBAL:PWD
	$GLOBAL:CDHIST.RemoveAt($num)
	$GLOBAL:CDHIST.Insert(0,$GLOBAL:PWD) 
}
elseif ($args[0] -eq "-l") 
{
	$start = [System.Math]::Max(0, $count - 50)
	
	for ($i = 0; $i -lt $count; $i++) 
	{
		"{0,6}  {1}" -f $i, $GLOBAL:CDHIST[$i].ToString().Replace("Microsoft.PowerShell.Core\FileSystem::","")
	}
}
elseif ($args[0] -eq "-") 
{ 
	if ($GLOBAL:CDHIST.count -gt 1)
	{
		$t = $CDHIST[0]
		$CDHIST[0] = $CDHIST[1]
		$CDHIST[1] = $t
		set-location $GLOBAL:CDHIST[0]
		$GLOBAL:PWD = get-location
	}
}
else 
{
	set-location "$args"
	$GLOBAL:PWD = get-location

	for ($i = $count - 1; $i -ge 0; $i--)
	{
		if ($GLOBAL:PWD.Path -eq $GLOBAL:CDHIST[$i])
		{
			$GLOBAL:CDHIST.RemoveAt($i)
		}
	}

	$GLOBAL:CDHIST.Insert($GLOBAL:CDHIST.count, $GLOBAL:PWD)
}

$GLOBAL:PWD = get-location