function GitGrep {
	param ([string]$range, [string]$grepThis)
  
	git log --pretty=format:"%H" $range --no-merges --grep="$grepThis" | ForEach-Object {
	  $Body = git log -1 --pretty=format:"%b" $_ | Select-String "$grepThis"
	  if($Body) {
		git log -1 --pretty=format:"%H,%s" $_
		Write-Host $Body
	  }
	}
  }
