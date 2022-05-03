    function exec-script ($file, $func, $parm) {
       
       . $file    
       
       $x = (& $func $parm)
       
       $x
        
       }
    
    exec-script -file ".\Hello" -func "Hello" -parm "World"
    function Hello ($in) {
     
        write-Host "Hello $in"
    }
