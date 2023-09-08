function prefixCommit()
{
  # Use git-filter-repo to add the branch name as a prefix to each commit message in a branch
  git filter-repo --refs my-branch --message-callback "
    import subprocess
    branch = subprocess.check_output(['git', 'branch', '--contains', commit.original_id.decode('utf-8')]).decode('utf-8').strip().lstrip('* ')
    commit.message = b'[' + branch.encode('utf-8') + b']: ' + commit.message
  "

}
