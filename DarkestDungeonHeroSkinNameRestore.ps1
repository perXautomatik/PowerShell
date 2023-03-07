function iToAlfa ([int]$ix)
{
  return [char](($ix%$alfa)+$asci)
}

function listPosfixes 
{

  [CmdletBinding()]
  Param (
      [parameter(mandatory=$true)]
      [ValidateNotNullOrEmpty()]      
      [string]$parrentPathx,    
      [string]$prefixq
  )

  $foldername = $prefixq+($parrentPathx | split-path -leaf)
  $alreadyPosfixes = @()
      Get-ChildItem $parrentPathx -dir |  ?{$_.basename -match $foldername} |
       %{
        $find = $foldername+'_';
        $bName = $_.basename;
        
        $alreadyPosfixes += $bName.substring(([regex]::match($bName,$find)).index+([regex]::match($bName,$find)).length)
      }
  return      $alreadyPosfixes
}

function unusedAlpha ($index,$posfixy)  
{
  $notTaken = ($alfaB | ? {$_ -notin $posfixy })
  
  if ($notTaken.length -gt 1) 
  {
    if ($index -gt $notTaken.length)
    {
      return $notTaken | select -first 1
    }
    else
    {
      return $notTaken[$index]
    }
  }
  else
  {
    return $notTaken
  }
  
    
}

function newTestpath ($refixA,$parentN,$sufix,$parrentPathQ)
{
  
  $array= @($refixA,$parentN,$sufix);
  $newNameTP = $array -join ""
  $newpathTP = (Join-Path $parrentPathQ $newNameTP)
  return  $newpathTP;
}

function alaphaprifix ($nr)
{
  if ($nr -gt (-1)) {  
    (iToAlfa $nr)+'_'
  }
  else
  {''}
}

function alaphaSufix ($snr)
{  
    '_'+(iToAlfa $snr)  
}


function generateName 
{ 
  [CmdletBinding()]
  Param (
      [parameter(mandatory=$true)]
      [ValidateNotNullOrEmpty()]      
      $currentParrentName,
      [parameter(mandatory=$true)]
      [ValidateNotNullOrEmpty()] 
      $currentPath
  )
  
  [int]$q = -1;     
  
    if ($i -ge $alfa) {
      $i%=$alfa
      $q++;
    }
  
    $sufixGn = alaphaSufix $i
    $prefixGn = alaphaprifix $q
    $testPathAtempts = 0;

    $takenPosfixes = listPosfixes -parrentPathx $currentPath -prefixq $prefixGn

    $testPath = newTestpath -refixA $prefixGn -parentN $currentParrentName -sufix $sufixGn -parrentPathQ $currentPath
    
    while (((Test-Path $testPath) -or ($null -eq $testPath)) -and $testPathAtempts -le 40 )       
    {
          $newSufixGn = unusedAlpha $testPathAtempts $takenPosfixes

          if ($null -eq $newSufixGn ) {
             $q++; 
             $takenPosfixes = listPosfixes -parrentPathx $currentPath -prefixq (alaphaprifix $q)
            } 
            else
            {            
    
              $prefixGn = alaphaprifix $q
              $sufixGn = '_'+(unusedAlpha $i $takenPosfixes)

            $testPath = newTestpath -refixA $prefixGn -parentN $currentParrentName -sufix $sufixGn -parrentPathQ $currentPath           
          }          
          $testPathAtempts++;
        }          
        $theName = split-path $testPath -Leaf;
        return $theName
    }
    

cd 'C:\Users\Användaren\AppData\Roaming\Vortex\darkestDungeon\mods\dlcloverslabHeroes\heroes'


$alfaB  = 0..25 | %{ $_+65} | %{ [char]$_} 
$asci = 65;
$alfa = 25;

# filter


#?{$_.basename -match ((split-path $_.fullname -parent) | split-path -Leaf ) } | 

$toRename = Get-ChildItem -dir | %{ $i = 0 ; $_ } | % {Get-ChildItem -path $_.BaseName -dir} | ?{ [string]$str=($_.BaseName) ; $str.Length -ge 20 } 

$toRename | %{ 
  $i++; 
  
  $orignalPath=$_.fullname; 
  
  $parentPath = (split-path $orignalPath -parent); 
  
  $parentName = split-path $parentPath -Leaf; 
  

  
  $newName = generateName -currentParrentName $parentName -currentPath $parentPath; 
  
  Rename-Item -Path $orignalPath $newName
}