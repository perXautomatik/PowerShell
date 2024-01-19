#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}    

if (!$everythingError)
{

    if (Test-CommandExists 'search-Everything')
    { 
        function invoke-Everything([string]$filter) { @(Search-Everything  -filter $filter -global) }
        function invoke-FuzzyWithEverything($searchstring) { menu @(invoke-Everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution
        function Every-execute ($inputx)                { $filter = "ext:exe $inputx" ; $filter } #& (Every-Menu $filter)
    function Every-AsHashMap                        { param( $filter = 'ext:psd1 \module')  $q = @{}                                                                                                                                                                                                                        ; everything $filter                                                                    | %{@{ name = (get -item $_).name                                  ; time=(get -item $_).LastWriteTime                            ; path=(get -item $_) } }                                                         | sort -object -property time                  | %{ $q[$_.name] = $_.path }                                                             ; $q                          | select -property values}
    
#        function Every-Load                             { param( $psFileFilter = 'convert-xlsx-to-csv.ps1') . ( everythnig $psFileFilter | select -first 1) } ; invoke-expression "ExcelToCsv -File 'D:\unsorted\fannyUtskick.xlsx'"
    function get-whatpulse                          { param( $program,$path) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $query = "select rightstr(path,instr(reverse(path),'/') -1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)" ; $adapter = newSqliteConnection -source (Everything 'whatpulse.db')[0] -query $query   ; $b=@($data.item('exe'))                                          ; $a = @($data.item('path'))                                   ; $i=0                                                                            ; while($i -lt $a.Length)                                                   {$res[$b[$i]]=$a[$i] ; $i++ }                                                                                 ; $res                        | where                                                                                                                                                                  { $_.name -match $program -and $_.path -match $path}}

    set-alias -Name:"everything" -Value:"invoke-Everything" -Description:"" -Option:"AllScope"    

    if (Test-CommandExists 'menu')
    {
        function Every-Menu { param( $filter) $a= @(everything $filter) ;  if($a.count -eq 1) {$a} else {menu $a} }
        function invoke-FuzzyWithEverything($searchstring) { menu @(everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution
        set-alias -Name:"executeThis" -Value:"invoke-FuzzyWithEverything" -Description:"" -Option:"AllScope"
#        function Every-Load                             { param( $psFileFilter = 'convert-xlsx-to-csv.ps1') . ( everythnig $psFileFilter | select -first 1) } ; invoke-expression "ExcelToCsv -File 'D:\unsorted\fannyUtskick.xlsx'"
        function Every-AsHashMap                        { param( $filter = 'ext:psd1 \module')  $q = @{}                                                                                                                                                                                                                        ; everything $filter                                                                    | %{@{ name = (get -item $_).name                                  ; time=(get -item $_).LastWriteTime                            ; path=(get -item $_) } }                                                         | sort -object -property time                  | %{ $q[$_.name] = $_.path }                                                             ; $q                          | select -property values}
        function Every-execute                          { param( $filter = 'regex:".*\\data\\[^\\]*.ahk"',$navigate=$true) Every-Menu | %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 { if($navigate)                                                                                                                                                                                                                                                                                                      {cd ($_ | split -path -parent)} ; . $_ } }
        function Every-Load                             { param( $psFileFilter = 'convert-xlsx-to-csv.ps1') . ( everythnig $psFileFilter | select -first 1) } ; invoke-expression "ExcelToCsv -File 'D:\unsorted\fannyUtskick.xlsx'"
        function Every-Explore                          { param( $filter = 'ext:exe lasso') ; Every-Menu $filter | %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      { $path = if(!( Test-Path $_ -PathType Container))                                                                                                                                                                                                                                                                   { $_ | split-path -leaf } else                                                                                                                                                                                                                                                                                                                                                                                                                                                          {$_} ; explorer $path } }
        function Every-Menu { param( $filter) $a= @(everything $filter) ;  if($a.count -eq 1) {$a} else {menu $a} }

		Set-Alias -Name everything -Value invoke-everything

<#initialy : @(Search-Everything  -filter $filter -global) #>	
		function invoke-Everything {
		    param(
		        [Parameter(Mandatory=$false)]
		        [string]$folderPath = "B:\PF\NoteTakingProjectFolder",
		        [Parameter(Mandatory=$false)]
		        [string]$filter = '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>',
		        [Parameter(Mandatory=$false)]
		        [switch]$notGlobal = $false
		    )
		    #install-module pseverything
		    #Import-Module pseverything

		    $folderPath = $folderPath.trim("\\")

		    # Build a string with the parameters for Search-Everything
		    $searchString = "Search-Everything"
    
		    if ($folderPath) {
		        $searchString += " -PathInclude '$folderPath'"
		    }

		    if ($filter) {
		        $searchString += " -Filter '$filter'"
		    }

		    if (!$notGlobal) {
		        $searchString += " -Global"
		    }
		    $lines = @()
		    # Invoke the string as a command and get the folders
		    $lines =  Invoke-Expression $searchString
		    return $lines
		}          
	
	function everything-GitRoots ($pathx,$search)
	{
	       # Get the folder path from the user input
    
    

	    # Search for files with extension .ps1 using Everything
	    $files = Invoke-Everything -folderPath $pathx -filter $search  | %{ $_ | Get-Item }

	    # Initialize a hashtable to store the git root paths and the file paths
	    $gitRoots = @{}
	    Write-Output ($files | Measure-Object)
	    # Loop through each file
	    foreach ($file in $files) {
	        # Get the full path of the file
	        $filePath = $file

	        # Try to get the git root path of the file using git rev-parse --show-toplevel
	        try {
	            $filexp = $file | Split-Path -Parent
	            $expr = "git -C '"+$filexp+"' rev-parse --show-toplevel"
	            $gitRoot = invoke-expression $expr

	            # If the git root path is not in the hashtable, create a new entry with an empty array
	            if (-not $gitRoots.ContainsKey($gitRoot)) {
	                $gitRoots[$gitRoot] = @()
	            }

	            # Add the file path to the array of the corresponding git root path
	            $gitRoots[$gitRoot] += $filePath
	        }
	        # Catch any error and assign it to the git root variable
	        catch {
	            write-error $expr
	            Write-Error $filePath
	            $gitRoot = "error: $_"
	        }

        
	    }

	    # Loop through each git root path in the hashtable
	    foreach ($gitRoot in $gitRoots.Keys) {
	        # Print the git root path
	        Write-Host "Git root: $gitRoot"

	        # Print the file paths under the git root path
	        foreach ($filePath in $gitRoots[$gitRoot]) {
	            Write-Host "  - $filePath"
	        }
	    }
	}


	#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
	function Test-CommandExists {
	    Param ($command)
	    $oldErrorActionPreference = $ErrorActionPreference
	    $ErrorActionPreference = 'stop'
	    try { Get-Command $command; return $true }
	    catch {return $false}
	    finally { $ErrorActionPreference=$oldErrorActionPreference }
	}    
function get-whatpulse                          { param( $program,$path) if (!$path -or !(Test-Path $path))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             { throw "file not found: '$path'" } $query = "select rightstr(path,instr(reverse(path),'/') -1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)" ; $adapter = newSqliteConnection -source (Everything 'whatpulse.db')[0] -query $query   ; $b=@($data.item('exe'))                                          ; $a = @($data.item('path'))                                   ; $i=0                                                                            ; while($i -lt $a.Length)                                                   {$res[$b[$i]]=$a[$i] ; $i++ }                                                                                 ; $res                        | where                                                                                                                                                                  { $_.name -match $program -and $_.path -match $path}}
set-alias executeThis        invoke-FuzzyWithEverything             -Option AllScope   

		
set-alias everything         invoke-Everything                      -Option AllScope
	
	
    }
