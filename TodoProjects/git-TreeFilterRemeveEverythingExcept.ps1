$parent = 'C:\Users\chris\AppData\Roaming\Scooter Software\Beyond Compare 4'
$source = $parent
$parentName = 'appdata'
$tempFolder = 'B:\ToGit\'
$ToFilterBy = 'BCPreferences.xml'
$source = 'U:\PortableApplauncher\PortableApps\2. file Organization\PortableApps\Beyond Compare 4'

cd $tempFolder

git clone --mirror $source 'Beyond Compare 2/.git'
  
cd ($tempFolder+'\Beyond Compare 2')

git config --bool core.bare false 

git add . ; git commit -m 'etc' 


$filter = 'git rm --cached -qr --ignore-unmatch -- . && git reset -q $GIT_COMMIT -- '+$ToFilterBy
git filter-branch --index-filter $filter --prune-empty -- --all

git remote add $parentName $parent


