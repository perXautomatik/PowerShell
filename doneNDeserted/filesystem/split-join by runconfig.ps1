

function Get-FileEncoding {<#Url: https://stackoverflow.com/questions/9121579/powershell-out-file-prevent-encoding-changes#>
    param ( [string] $FilePath )

    [byte[]] $byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $FilePath

    if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
        { $encoding = 'UTF8' }  
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
        { $encoding = 'BigEndianUnicode' }
    elseif ($byte[0] -eq 0xff -and $byte[1] -eq 0xfe)
         { $encoding = 'Unicode' }
    elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
        { $encoding = 'UTF32' }
    elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76)
        { $encoding = 'UTF7'}
    else
        { $encoding = 'Ascii' }
    return $encoding
}

function join-ByRunconfig { 
    [cmdletbinding()]
    param(             
        [ValidateNotNullOrEmpty()] 
        [string]$prefix,
        [ValidateNotNullOrEmpty()] 
        [string]$prefixReplace,
        [parameter(ValueFromPipeline)]
        [string]$runconfig,
        [parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] 
        [string]$output
    )
    Process {
       '' > $output ;
       [xml]$xml = Get-Content -path $runconfig -Encoding UTF8 ; 
       $xml.component.configuration.'script-file'| 
       % {$_.value -replace $prefix, ($prefixReplace -replace '\\','/')} | 
       % {" --:$_" ; get-content -path $_ -Encoding Oem  ; "go" }  | 
        
       out-file -filepath $output  -Append -Encoding Oem 
       }
 }


 function find-LastLineNumberof($myFile,$myString)
 {
      $i = $index = -1
    $null = [Linq.Enumerable]::LastOrDefault(
  [IO.File]::ReadLines($myFile),
  [Func[string, bool]] { 
     ++$script:i; 
     if ($args[0] -match (regexEscape $myString) ) { $script:index = $script:i; return $true } 
  }
)

$index # output the index of the last match, if not found, -1
 }
 
 function regexEscaped([string]$string){return [regex]::escape($string)}

function ToArray
{
  begin {$output = @();} process { $output += $_; } end { return ,$output; }
}
 
 <#like regex, but we want to to act on instead of a group of matches, the run configs
 also, the match (--:line) is the path to the file, not the name
 also onliny 1 occurence per runconfig line. error otherwise?
 #>

function split-ByRunconfig 
{ 
    param( $prefix, $prefixReplace, $runconfig, $output) 

    [xml]$xml = get-content $runconfig -Encoding Oem ; 
    [string[]]$linesTomatch = $xml.component.configuration.'script-file'| % {($_.value -replace $prefix, ($prefixReplace -replace '\\','/'))}
    
    $i = -1
    $fileLines = (Get-Content -ReadCount 0 $output) | %{ $i++; [PSCustomObject]@{ i = $i; str = $_ } }
    
    
    [psobject[]]$matchesx = $fileLines | ?{ if($_.str.length -ge 6 ) { $_.str.Substring(1,5) -match '[\s\t]?--:'} }   
    $end = $matchesx[1..$matchesx.length]

    $charNR = 0 ; 
    $i = 0 ; 
    $occurence = 0 ;
    
    while ($occurence -le $end.Length)
    {
        $x = '';
    
        $pathname = $matchesx[$occurence].str -replace '--:' 
        
        $s = $matchesx[$occurence].i+1        
        $u = $matchesx[$occurence+1].i-1
        $u = if($u -eq -1) {$fileLines.length} else {$u}
        
        $pathname = $pathname.trim()

        if (test-path $pathname )
         {
            $encoding = Get-FileEncoding -FilePath $pathname

            $x = $fileLines[($s..$u)] | %{$_.str } 
        
            $x | Set-Content -Path $pathname 
        
            Write-Host "$s..$u$pathname" ;
          }
        else 
        { $pathname }
        $occurence++ ;
    }

}

#$myFile = 'H:\ignore.txt';
#$myString =   '#' ;



 cd 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\projects\Kv-FlaggGenerering\.idea\runConfigurations'

$prefix =  '[$]APPLICATION_CONFIG_DIR[$][/]';
$prefixReplace =  'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\';
$runconfig = '.\SeparateFileTempTableKvUtsök.xml';
$output = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\a922a8bc-6602-44d4-8ab2-a4062fc64d99\Kv-FlaggGenerering\xUtsökningSocken.sql';

  
#split-ByRunconfig $prefix, $prefixReplace, $runconfig, $output


join-ByRunconfig  $prefix  $prefixReplace  $runconfig  $output
 # -ReadCount 0 returns all lines as single array
#[Array]::FindLastIndex( (Get-Content -ReadCount 0 $myFile), [Predicate[string]] { $args[0] -match $myString } ) | Measure-Object ;
 
#find-LastLineNumberof $myFile $myString