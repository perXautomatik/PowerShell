# Define a function that takes a filename and a commit id as parameters
function Filter-Root-Files($filename, $commit) {
  # Get the full path of the file in the repo
  $fullpath = Join-Path -Path $PSScriptRoot -ChildPath $filename
  # Check if the file exists in the repo at the given commit
  $exists = git cat-file -e "$commit:$filename" 2> $null
  # If the file exists and is in the root of the repo, return the filename
  if ($exists -and ($fullpath -notmatch '\\\\')) {
    return $filename
  }
  # Otherwise, return an empty string to delete the file
  else {
    return ""
  }
}

# Clone the repository that you want to filter
git clone git@github.com:yourname/my-repo.git

# Go into the cloned repository and install git-filter-repo
cd my-repo
git-filter-repo --version

# Run git filter-repo with the --filename-callback option and pass the function name
git filter-repo --filename-callback Filter-Root-Files

# Push the filtered repository to a new remote location
git remote add filtered git@github.com:yourname/my-repo-filtered.git
git push filtered main
