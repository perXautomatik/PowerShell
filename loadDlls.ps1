#sqlite dll
$workpath = "C:\Program Files\System.Data.SQLite\2010\bin\System.Data.SQLite.dll"  ; 

if ( $(Test-CommandExists 'everything') ) {$alternative = (everything 'wfn:System.Data.SQLite.DLL')[0] ;}

$p = if(Test-Path $workpath){$workpath} else {$alternative} ;
$p = $p ?? 'unable to set path' 

		if( Test-Path $p ) 
		{
			Add-Type -Path $p
			echo $p 
		}
