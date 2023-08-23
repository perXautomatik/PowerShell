
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
}
set-alias remote             invoke-gitRemote                       -Option AllScope   
set-alias gitsplit           subtree-split-rm-commit                -Option AllScope
