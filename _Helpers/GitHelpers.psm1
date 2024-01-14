
if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope
    function git-root { $gitrootdir = (git rev-parse --show-toplevel) ; if ( $gitrootdir ) { Set-Location $gitrootdir } }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`' }

        if ( -Not (Test-CommandExists 'sh') ){ Set-Alias sh   git-sh -Option AllScope }

        if ( -Not (Test-CommandExists 'bash') ){ Set-Alias bash   git-bash -Option AllScope }

        if ( -Not (Test-CommandExists 'vi') ){ Set-Alias vi   git-vim -Option AllScope }

        if ( -Not (Test-CommandExists 'vim') ){ Set-Alias vim   git-vim -Option AllScope }
    }

function Translate-Path {
	  [CmdletBinding()]
	  param (
	    # The relative path
	    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
	    [string]
	    $RelativePath,

	    # The base directory`
	    [Parameter(Mandatory = $true)]
	    [ValidateScript({Test-Path $_ -PathType Container})]
	    [string]
	    $BaseDirectory
	  )

	  # Split the relative path by the "/" character`
	  $PathSegments = $RelativePath.Split("/")

	  # Set the current directory to the base directory`
	  $CurrentDirectory = $BaseDirectory

	  # Loop through each path segment`
	  foreach ($Segment in $PathSegments) {
	    # If the segment is "..", go up one level in the directory hierarchy`
	    if ($Segment -eq "..") {
	      $CurrentDirectory = Split-Path -Path $CurrentDirectory -Parent
	    }
	    # If the segment is ".git", stop the loop and append the rest of the path`
	    elseif ($Segment -eq ".git") {
	      break
	    }
	    # Otherwise, ignore the segment`
	    else {
	      continue
	    }
	  }

	  # Get the index of the ".git" segment in the path segments`
	  $GitIndex = [array]::IndexOf($PathSegments, ".git")

	  # Get the rest of the path segments after the ".git" segment`
	  $RestOfPath = $PathSegments[($GitIndex)..$PathSegments.Length]

	  # Join the rest of the path segments by the "/" character`
	  $RestOfPath = $RestOfPath -join "/"

	  # Append the rest of the path to the current directory`
	  $AbsolutePath = Join-Path -Path $CurrentDirectory -ChildPath $RestOfPath

	  # Return the absolute path as a string`
	  return "$AbsolutePath"
	}			

function Invoke-Git {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Command = "status" # The git command to run
    )

    if ($Command -eq "") {
        $Command = "status"
    } elseif ($Command.StartsWith("git ")) {
        $Command = $Command.Substring(4)
    }

    # Run the command and capture the output
    $output = Invoke-Expression -Command "git $Command 2>&1" -ErrorAction Stop 

    # Check the exit code and throw an exception if not zero
    if ($LASTEXITCODE -ne 0) {
        $errorMessage = $Error[0].Exception.Message
        throw "Git command failed: git $Command. Error message: $errorMessage"
    }

    # return the output to the host
    $output
}
function git-filter-folder
   {
      param(
      $namex
      )
      $current = git branch --show-current;
      $branchName = ('b'+$namex);
      
      git checkout -b $branchName
      
      git filter-repo --force --refs $branchName --subdirectory-filter $namex
      
      git checkout $current
      
      git filter-repo --force --refs $current --path $namex --invert-paths      
   }
			
	function New-GitTemp {
	  param(
	      # Validate that the Script parameter is not null or empty and is a script block
	      [Parameter(Mandatory = $false)]
	      [ValidateNotNullOrEmpty()]
	      [ValidateScript({$_ -is [scriptblock]})]
	      [scriptblock]
	      $Script,

	      # Validate that the RemoveAfter parameter is a switch
	      [Parameter(Mandatory = $false)]
	      [ValidateScript({$_ -is [switch]})]
	      [switch]
	      $RemoveAfter
	  )

	  # Create a temporary file and get its directory name
	  $tempFile = New-TemporaryFile

	    #Use the Split-Path cmdlet to get the directory name of the temporary file. For example:

	  $tempDir = Split-Path -Parent $tempFile

	  # Create a subdirectory under the temporary directory with a unique name
	    #Use the New-Item cmdlet to create a subdirectory under the temporary directory. You can use any name you want for the subdirectory. For example:
	  $prefix = (New-Guid).Guid
	  $gitDir = New-Item -Path $tempDir -Name "$prefix.gitrepo" -ItemType Directory

	  # Change the current location to the subdirectory
	  Push-Location -Path $gitDir -ErrorAction Stop

	  # Initialize an empty git repository in the subdirectory
	  $q = invoke-git("init")
	  Write-Verbose $q

	  # Check if a script block is specified
	  if ($Script) {
	      # Execute the script block and store the result
	      $result = Invoke-Command -ScriptBlock $Script
	  }
	  else {
	      # Return the path of the subdirectory as output
	      $result = $gitDir
	  }

	  # Return to the previous location
	  Pop-Location -ErrorAction Stop

	  # Check if the flag is set to true
	  if ($RemoveAfter) {
	      # Delete the subdirectory and its contents
	      Remove-Item -Path $gitDir -Recurse -Force
	  }

	  # Return the result as output
	  return $result
	}   

	function git-Checkout () { & git checkout $args }
	function git-FetchOrig { git fetch origin }
	Function Git-Lazy($path,$message) { cd $path ; git lazy $message } ; 
	Function Git-LazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )}
	function git-Remote { param ($subCommand = 'get-url',$name = "origin" ) git remote $subCommand $name }
	Function Git-SubmoduleAdd([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch }
	
	function Git-repairHead {param($from="refs/heads/master",$to="origin/master"); $expr = "git update-ref "+$from+" "+ $to; invoke-expression $expr }
	function Git-filter-repo($from,$to,$ref) { $expr = "git filter-repo --path-rename "+$from+":"+$to +" --refs '" + $ref + "'" ; invoke-expression $expr }
	function Git-to-Subdirectory($to,$ref) { git filter-repo --to-subdirectory-filter $to --refs $ref }
	function Git-remove-directory($rel) { git filter-repo --path $rel --invert-path --force}
	function Git-subdir-ToRoot($rel) { git filter-repo --subdirectory-filter $rel --force}
	function Git-subdir-ToRoot($rel,$ref) { git filter-repo --subdirectory-filter $rel --force --refs $ref }
	function Git-merge-ours($branch) { git merge $branch --strategy ours --allow-unrelated-histories }
	function Git-newFeatureBranch { param( [Parameter(Mandatory=$true)][string]$path) ; $branchName = get-item -Path $path -baseName ; git branch -t $branchName $path ; $originalBranchName = (git symbolic-ref HEAD) ; git switch --detach $branchName ; git add $path ; git commit -m "Added file $path" ; git switch --detach $originalBranchName ; rm $path }
	function Git-CheckoutNotTree() { param([Parameter(Mandatory=$true)][string]$branchName) ; return (git symbolic-ref HEAD) ; git switch --detach $branchName }
	function Git-disable-OwnershipCheck { git config --global core.ignoreStat all }

	set-alias GitAdEPathAsSNB    invoke-GitSubmoduleAdd                 		-Option AllScope -description:" ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch" 
	set-alias -Name:"gitSilently" -Value:"invoke-GitLazySilently" -Description:"" -Option:"AllScope"
	set-alias -Name:"gitSingleRemote" -Value:"invoke-gitFetchOrig" -Description:"" -Option:"AllScope"
	set-alias -Name:"filter-repo" -Value:"git-filter-repo" -Description:"" 		-Option:"AllScope"
	set-alias -Name:"gitsplit" -Value:"subtree-split-rm-commit" -Description:"" -Option:"AllScope"
	set-alias GitUp              Git-Lazy                         				-Option AllScope -description:"#todo: parameterize #todo: rename to more descriptive #todo: breakout"
	set-alias -Name:"remote" -Value:"invoke-gitRemote" -Description:"" 			-Option:"AllScope"

