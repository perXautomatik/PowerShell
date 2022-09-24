# Update output buffer size to prevent clipping in Visual Studio output window.
    $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size (100, 25)


    

    
    funtion empty-buffer {
  

    $buffer.Clear()
    }

    function Out-More #implementation of Out-Host -Paging /more
    {
        param ( $Lines = 10,
        [Parameter(ValueFromPipeline=$true)] 
        $InputObject)
        
        begin{$counter = 0;$buffer = @()}
        
        process
        {$counter++ ;
         
         if ($counter -ge $Lines) {
            $counter = 0; 
            cls;
            Write-Host 'Press ENTER to continue' -ForegroundColor Yellow ;
            echo $buffer.length ;
         
             $present =  $buffer | %{[pscustomobject] @{ prop1=$_ } }
             $present = $present  | Format-Table -Property @{ e='prop1'; width = 50 } | out-string
             
             #$present = $present | format
             $q = menu @($present) 

             empty-buffer
            };                   
         $buffer+=$InputObject
         }
         
    } 

    gc $historyPath | out-more