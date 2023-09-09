function Add-Index { 
#https://stackoverflow.com/questions/33718168/exclude-index-in-powershell
# This function adds an index property to each object in an array using a counter variable
   
    begin {
        # Initialize the counter variable as -1
        $i=-1
    }
   
    process {
        if($_ -ne $null) {
        # Increment the counter variable and add it as an index property to the input object 
        Add-Member Index (++$i) -InputObject $_ -PassThru
        }
    }
}
