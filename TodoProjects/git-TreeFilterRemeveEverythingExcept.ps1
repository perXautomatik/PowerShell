$SourceParent = 'C:\Users\chris\AppData\Roaming\Microsoft\Windows\PowerShell'
$parentName = 'Beyond Compare 2'
$source = $SourceParent
$SourceParentName = 'appdata'
$tempFolder = 'B:\ToGit\'
$ToFilterBy = 'ConsoleHost_history.txt'
$source = 'C:\Users\chris\AppData\Roaming\Microsoft\Windows\PowerShell'

cd $tempFolder

git clone --mirror $source '$parentName/.git'
  
cd ($tempFolder+'\$parentName')

git config --bool core.bare false 

git add . ; git commit -m 'etc' 


$filter = 'git rm --cached -qr --ignore-unmatch -- . && git reset -q $GIT_COMMIT -- '+$ToFilterBy
git filter-branch --index-filter $filter --prune-empty -- --all

git remote add $SourceParentName $SourceParent

# remove tracked branches after filtering
#git filter-branch --index-filter 'git rm --cached -qr --ignore-unmatch -- . && git reset -q $GIT_COMMIT -- .gitignore' --prune-empty -- --all