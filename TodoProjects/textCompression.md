function compressText ($inputTxt)
{
    function Replacer
    {
        replace not all ocations, but recursivly

        for each x (thing to match)
        {
            cte:
                $matches = find x in file 

                $for each match
                    if condition met
                        do replacement to Y    
                            goto cte:
        
        
        }
    }

     for each $line in $inputx | %{ 
         $tokenization = $line | tokenize ; 
        
         Replacer $line $tokenization    
        }
        

     
     

}

