cd 'B:\chris\Documents\New folder (3)\Beyond Compare 4'

git filter-branch --index-filter 'git rm --cached -qr --ignore-unmatch -- . && git reset -q $GIT_COMMIT -- .gitignore' --prune-empty -- --all