cd 'B:\Users\chris\Documents\'

$list = Get-ChildItem -Recurse -Filter '.git'

$q = $list | select -property @{name='path'; expression={$_.FullName }} | select path,@{name='depth';expression={$_.path.split('\').Length}} | Sort-Object -Property depth -Descending

$ToBeHashed = @{}


$json = @"
{ "root": {} } 
"@

$q | show-tree


$jobj = ConvertFrom-Json -InputObject $json

#for ($i = 0; $i -lt $ToBeHashed.length; $i++){    $jobj | add-member -Name "BlockC" -value (Convertfrom-Json $blockcvalue) -MemberType NoteProperty  }

#$q | % {

$test = 'B:\Users\chris\Documents\Klei\Diablo II\.git'

$ToBeHashed = $test.split('\')

$ToBeHashed
$ToBeHashed.length
$ToBeHashed[0]

for ($i = 0; $i -lt $ToBeHashed.length; $i++){
    
    $m = $ToBeHashed[$i]
   
    if ($m -ne $null )
    {

        if ($jobj.$m -eq $null )
        {

            $jobj | add-member -Name $m -NotePropertyMembers

        }


     $jobj = $jobj.$m
    }

}
$jobj | ConvertTo-Json

}



$q | % {

$xt = $_.path.split('\')[0].toString()

$jobj.root | add-member -Name "$xt" -value (Convertfrom-Json $blockcvalue) -MemberType NoteProperty -OutVariable $null
}

$jobj