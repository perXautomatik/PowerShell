function inProgressX($pathx) 
{ 
    $c = $pwd
    cd $pathx; 
    $string = out-string -InputObject (git config --list --show-origin) ; 
    $res = $string -split '\n' | select -Unique ;
     $regex = '\t'; $res | % { $q = $_ -split '\t', 2; $z = ($q[1] -split '=', 2 ) ; 
     if ( @($q[0], $z[0], $z[1]) -notcontains $null ) 
     { [PSCustomObject]@{path = $q[0]; keyx = $z[0] ; valuex = $z[1].trimEnd() } } } |
      group-object -Property keyx  | % { $_.Group[-1] } | ? { $_.path -ne 'file:config' } |
       % { ($_.keyx + ' ' + "'" + $_.valuex + "'") } 
    ;
    cd $c
    }


function inProgressInside {
    [CmdletBinding()]                                                   # -- (1)
    Param                                                               # -- (2)
    (
        [Parameter(ValueFromPipeline)] $itemz
    
    )
    begin { [pscustomobject]$express = @{ actionX ='';teta =''} }
    Process {

        ForEach ($item in $itemz )                                     # -- (3.1)
        {
            try
            {
                $express = [pscustomobject] @{ 
                    actionX = "git config -f -local --add" ;
                    teta = $item } ;
                
                $express | Add-Member -NotePropertyName zeta -NotePropertyValue ("&" + $express.actionX + " " + $item + " *>&1"); ;

            }
            catch
            {
                Write-Error "x"
            }
            finally {
                $express
            }
        }

        
          
    }

}