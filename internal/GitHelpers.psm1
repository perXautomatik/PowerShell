
if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ( $gitrootdir ) {
            Set-Location $gitrootdir
        }
    }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args
            }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim {
           . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`'
        }

        if ( -Not (Test-CommandExists 'sh') ){
            Set-Alias sh   git-sh -Option AllScope
        }

        if ( -Not (Test-CommandExists 'bash') ){
            Set-Alias bash   git-bash -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vi') ){
            Set-Alias vi   git-vim -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vim') ){
            Set-Alias vim   git-vim -Option AllScope
        }
    }
}


    function stree($directory = $pwd) {
        $gitrootdir = (Invoke-Command{Set-Location $args[0]; git rev-parse --show-toplevel 2>&1;} -ArgumentList $directory)

            if ( Test-Path -Path "$gitrootdir\.git" -PathType Container) {
                $newestExe = Get-Item "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe" | select -Last 1
                Write-Debug "Opening $gitrootdir with $newestExe"
                Start-Process -filepath $newestExe -ArgumentList "-f `"$gitrootdir`" log"
            } else {
                Write-Error "git directory not found"
            }
    }
    if (Test-CommandExists 'git')
    { #todo: move to git aliases
        function invoke-gitCheckout () { & git checkout $args }
        function invoke-gitFetchOrig { git fetch origin }
        Function invoke-GitLazy($path,$message) { cd $path ; git lazy $message } ; 
        Function invoke-GitLazySilently {Out-File -FilePath .\lazy.log -inputObject (invoke-GitLazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout
        function invoke-gitRemote { param ($subCommand = 'get-url',$name = "origin" ) git remote $subCommand $name }
        Function invoke-GitSubmoduleAdd([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch
    }
	set-alias GitAdEPathAsSNB    invoke-GitSubmoduleAdd                 -Option AllScope
	set-alias -Name:"gitSilently" -Value:"invoke-GitLazySilently" -Description:"" -Option:"AllScope"
	set-alias -Name:"gitSingleRemote" -Value:"invoke-gitFetchOrig" -Description:"" -Option:"AllScope"
	set-alias -Name:"gitsplit" -Value:"subtree-split-rm-commit" -Description:"" -Option:"AllScope"
	set-alias GitUp              invoke-GitLazy                         -Option AllScope
	set-alias -Name:"remote" -Value:"invoke-gitRemote" -Description:"" -Option:"AllScope"
	set-alias remote             invoke-gitRemote                       -Option AllScope   
	set-alias gitsplit           subtree-split-rm-commit                -Option AllScope
function git-root {
	$gitrootdir = (git rev-parse --show-toplevel)
	if ( $gitrootdir ) {
	    Set-Location $gitrootdir
	    }
}
function repairHead {param($from="refs/heads/master",$to="origin/master"); $expr = "git update-ref "+$from+" "+ $to; invoke-expression $expr }

function filter-repo($from,$to,$ref) { $expr = "git filter-repo --path-rename "+$from+":"+$to +" --refs '" + $ref + "'" ; invoke-expression $expr }

function to-Subdirectory($to,$ref) { git filter-repo --to-subdirectory-filter $to --refs $ref }

function remove-directory($rel) { git filter-repo --path $rel --invert-path --force}

function subdir-ToRoot($rel) { git filter-repo --subdirectory-filter $rel --force}

function subdir-ToRoot($rel,$ref) { git filter-repo --subdirectory-filter $rel --force --refs $ref }

function merge-ours($branch) { git merge $branch --strategy ours --allow-unrelated-histories }

function newFeatureBranch { param( [Parameter(Mandatory=$true)][string]$path) ; $branchName = get-item -Path $path -baseName ; git branch -t $branchName $path ; $originalBranchName = (git symbolic-ref HEAD) ; git switch --detach $branchName ; git add $path ; git commit -m "Added file $path" ; git switch --detach $originalBranchName ; rm $path }

function CheckoutNotTree() { param([Parameter(Mandatory=$true)][string]$branchName) ; return (git symbolic-ref HEAD) ; git switch --detach $branchName }

function Invoke-GitTemp {
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

function Git-disable-OwnershipCheck { git config --global core.ignoreStat all }

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
