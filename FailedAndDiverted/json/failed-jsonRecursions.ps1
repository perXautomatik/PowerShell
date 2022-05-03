cls

function Show-ProgressV3{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [PSObject[]]$InputObject,
        [string]$Activity = "Processing items"
    )

        [int]$TotItems = $Input.Count
        [int]$Count = 0

        $Input | foreach {
            'inside'+$TotItems
            $_
            $Count++
            [int]$percentComplete = ($Count/$TotItems* 100)
            Write-Progress -Activity $Activity -PercentComplete $percentComplete -Status ("Working - " + $percentComplete + "%")
        }
}


function Resolve-Properties 
{
  param([Parameter(ValueFromPipeline)][psobject]$InputObject)

begin {
        $i = 0
        # get a new queue
        $queue = [System.Collections.Queue]::new()    
                   

}
  process { 
            
            $InputObject.psobject.Properties | % { $queue.Enqueue($_) }

            $i = 0
            $depth = 0
            $tree = '\----\'
            $queue.Count
            $output = ''
            
            while ($queue.Count -gt 0 -and $i -le 200)
            {
                $i++;
                $queue.Count
                # get one item off the queue
                $prop = $queue.Dequeue().psobject.Properties
                                                              
                
                if( $prop.value.children.length -gt 0)
                {
                    $output = $prop.name+$prop.value.children.length
                    $depth++
                    $prop.value.children | ?{$_.name -ne 'SyncRoot'} | % { $queue.Enqueue($_) }
                }
                elseif ( $prop.children.length -gt 0 )
                {
                    $output = $prop.name+$prop.children.length
                    $depth++
                                 
                    $prop.children | ?{$_.name -ne 'SyncRoot'} | % { $queue.Enqueue($_) }
                }
                else
                {
                    $output = $prop.value
                }

                $treex = $tree * $depth
                $treex + $output

            }  


        }    

  }


cd 'D:\Project Shelf\NoteTakingProjectFolder\GistNotebook\xMarks'


$jsonObj = (get-content .\turk | convertFrom-json)

#$jsonObj.bookmarks.psobject.Properties

$jsonObj | Resolve-Properties 

#$jsonObj.bookmarks.psobject.Properties | Show-ProgressV3 | select value
#@('a','b','c') 

#$properties = [object]@()

#$properties = @($jsonObj.psobject.Properties)

#$properties
#$children = $jsonObj.bookmarks.children




$allchildrens = while ($null -ne $children) {
    $children
    $children = $children.children
}

##$allchildrens

;

