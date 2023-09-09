function Git-LsTree {
	param ([string]$range, [string]$grepThis)
	
	
  $Body =  git ls-tree $range -r
	
	   $body | % { 
	   $spl = $_ -split ' ',3
	   [pscustomobject]@{     
		   hash = $range
		   q = $spl[0].trim()
		   type = $spl[1].trim()
		   objectID = $spl[2].Substring(0,40).trim()
		   relative = $spl[2].Substring(40).trim()
   
   
		}
	  }
  }
