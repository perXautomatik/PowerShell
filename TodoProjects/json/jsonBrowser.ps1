
function Resolve-Properties
{
    param ([parameter(ValueFromPipeline)][object]$inputObject)

    process {
        foreach($prop in $inputObject.psobject.Properties)
        {
        
        if  ( $prop.value.count -gt 1 )      { Resolve-Properties $prop.Value }        
        else
        {
            [pscustomObject]@{
                Name = $prop.Name  
                value = $prop.Value
            }
        }
        
        }
    }
}

cd 'U:\Project Shelf\TabSessionManager - Backup'

(Get-Content .\'2020-11-12 01-22-25 (456 sessions).json' | ConvertFrom-Json ) | 
% { $_.psobject.Properties} | 
    ?{ $_.value.count -gt 1 } | 
        % { $_.psobject.Properties.value} 
        
        
        
        
          # | Resolve-Properties