# Synopsis: This function replaces any slashes in a filename with underscores
  # Check if the file exists in the repo at the given commit
  # If the file exists and is in the root of the repo, return the filename
  # Otherwise, return an empty string to delete the file
  $FilterRootFiles = "return filename.replace(b'/', b'_') if b'/' in filename else filename"

  
# Synopsis: This function runs git filter-repo with the given filename callback and force flag
# Parameters: callback - a function name that takes a byte string as input and returns a byte string as output
#             force - a boolean value indicating whether to pass the --force flag to git filter-repo or not
# Returns: nothing, but prints the output of git filter-repo to stdout
function RunGitFilterRepo {
  # Check if the callback is a valid function name
  if ! type "$1" &> /dev/null; then
    echo "Error: callback must be a valid function name"
    return 1
  fi

  # Assign the parameters to local variables
  local callback=$1
  local force=$2

  # Check if the force flag is true or false
  if [[ $force == true ]]; then
    # Pass the --force flag to git filter-repo
    git filter-repo --filename-callback "$callback" --force
  elif [[ $force == false ]]; then
    # Do not pass the --force flag to git filter-repo
    git filter-repo --filename-callback "$callback"
  else
    # Invalid force flag value
    echo "Error: force must be either true or false"
    return 1
  fi
}
