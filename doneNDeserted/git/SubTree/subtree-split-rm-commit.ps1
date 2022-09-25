echo "git path as branch ..Subtree then forget";
#depends on git aliases-

param(  [notnullempty()][string]$leaf,
        [notnullempty()][string]$otherBranchname,
        [notnullempty()][string]$otherRemote
 )
if ($null -eq $leaf)
{
    $leaf = $pwd;
    cd ..
}
  
if($null -eq $otherBranchname -and $null -eq $otherRemote)
{   
 git pathToBranchpushOrig $leaf 
 }
 else
 {
 $remote = if($null -eq $otherRenote){remote}else{$otherRemote}
 $branchame = if($null -eq $otherBranchname){remote}else{$leaf}
 
 git subtree split -P $leaf -b $branchame
 git push $branchame $remote

 }

git rm -rf --cached $leaf;
 

git commit -m "[chore] after subtree split; removing $leaf folder" ;
