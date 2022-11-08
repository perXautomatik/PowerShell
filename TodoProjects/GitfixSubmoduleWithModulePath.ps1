[CmdletBinding()]
param (

    [Parameter(Mandatory=$true,
                HelpMessage=".git")] 
                [ValidateNotNullOrEmpty()]
    [string]$errorus,
     #can be done with everything and menu
    [Parameter(Mandatory=$true,    
                HelpMessage="subModuleDirInsideGit")] 
                [ValidateNotNullOrEmpty()]
    [string]$toReplaceWith
)

Try {
    $null = Resolve-Path -Path $errorus -ErrorAction Stop    
    $null = Resolve-Path -Path $toReplaceWith -ErrorAction Stop    
    $null = Test-Path -Path $errorus -ErrorAction Stop    
    $null = Test-Path -Path $toReplaceWith -ErrorAction Stop
}
catch {
    "paths was unresolvable"
}

    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Stop"

    $targetFolder = (([System.IO.FileInfo]$errorus) | select Directory).Directory
    $name = $targetFolder.Name
    
    $path = $targetFolder.Parent.FullName
    $configFile = ($errorus + '\config')



    echo '************************************************************'
       
    echo $targetFolder.ToString()
    echo $name.ToString()
    echo $path.ToString()
        
    echo $configFile.ToString()


    echo '************************************************************'


        

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ($gitrootdir) {
	    Set-Location $gitrootdir
        }
    }

    #---- move --- probably faile due to .git being a folder, and or module folder not exsiting, not critical

    #([System.IO.FileInfo]$errorus) | get-member
    
    try{       
       ([System.IO.FileInfo]$errorus).MoveTo(($targetFolder | Join-Path -ChildPath 'x.git')) 
    }
    catch 
    {
        echo $errorus
    }
    try{
        $q = ($targetFolder | Join-Path -ChildPath '.git')
        mv  $toReplaceWith -Destination $q -ErrorAction Stop
        #([System.IO.FileInfo]$toReplaceWith).MoveTo(($targetFolder | Join-Path -ChildPath '.git')) 
    }
    catch {
        echo 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx failed to move module dir xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        echo $toReplaceWith
        echo $q
    }
    
    #--- remove worktree line -- ! error, not critical, continue
        
        # putting get-content in paranteses makes it run as a separate thread and doesn't lock the file further down the pipe
        (Get-Content -Path $configFile | ? { ! ($_ -match 'worktree') }) | Set-Content -Path $configFile

    # --- forget about files in path, error if git already ignore path, not critical

    Push-Location
                cd $targetFolder     
                $ref = (git remote get-url origin)
    
    echo '************************** ref *****************************'           
    echo $ref.ToString()
    echo '************************** ref *****************************'

    
    cd $path

        git rm -r --cached $name 
        git commit -m "forgot about $name"

    # --- Read submodule

    echo '******************************* bout to read as submodule ****************************************' 

    cd $path ; Git-root # (outside of ref)

    $relative = ((Resolve-Path -Path $targetFolder.FullName -Relative) -replace([regex]::Escape('\'),'/')).Substring(2)

    echo $relative
    echo $ref 
    echo '****************************** relative path ****************************************************'

    function AddNabsorb ([string]$ref, [string]$relative) {

        Git submodule add $ref $relative
        git commit -m "as submodule $relative"

        Git submodule absorbgitdirs $relative

    }

    AddNabsorb -ref $ref -relative $relative

    Pop-Location

    $ErrorActionPreference = $previousErrorAction