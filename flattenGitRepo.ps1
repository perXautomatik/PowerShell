  # Import the os and subprocess modules
  # Get the full path of the file in the repo
  # Check if the file exists in the repo at the given commit
  # If the file exists and is in the root of the repo, return the filename
  # Otherwise, return an empty string to delete the file
$FilterRootFiles = @"
def filter_root_files(filename, commit):
  
  if exists and ('\\' in filename):
    return filename

  else:
    return ''
"@


# Clone the repository that you want to filter
git clone -- 'https://github.com/perXautomatik/powershell-GroupIntoFolder.git' '.'
# Run git filter-repo with the --filename-callback option and pass the function name
git filter-repo --filename-callback $FilterRootFiles

# Push the filtered repository to a new remote location
#git remote add filtered 'https://gist.github.com/perXautomatik/42bb0a6d1bdd0adf75ad5638905268fd'
#git push filtered main
