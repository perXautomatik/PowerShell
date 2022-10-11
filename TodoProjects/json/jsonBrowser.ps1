
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

cd 'C:\Users\chris\Documents\394c4bae9f3023729a6ccb4aa1fff31d'

(Get-Content .\turk | ConvertFrom-Json ) | 
% { $_.psobject.Properties} | 
    ?{ $_.value.count -gt 1 } | 
        % { $_.psobject.Properties.value} 
        
        
        
        
          # | Resolve-Properties