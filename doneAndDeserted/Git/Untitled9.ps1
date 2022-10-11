cd D:\Users\crbk01\AppData\Roaming\JetBrains\Datagrip\consolex\db\8cc23256-e02c-43ea-8477-e740c4580b62

#permently rewrites history to only include what's dictated in filter
# --index-filter 'git ls-files | grep -v "^SolVision" | xargs --no-run-if-empty git rm --cached' HEAD
#git filter-branch --subdirectory-filter 'Organized/SolVision'
   
git ls-files | git grep -v "^SolVision" 

