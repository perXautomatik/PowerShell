function Healthy-GetSubmodules {
   
    # Synopsis: A script to get the submodules recursively for a given repo path or a list of repo paths
    # Parameter: RepoPaths - The path or paths to the repos
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$RepoPaths # The path or paths to the repos
    )

    # A function to validate a path argument
    # Call the main function for each repo path in the pipeline
    foreach ($RepoPath in $RepoPaths) {
      Get-SubmoduleDeep -RepoPath $RepoPath
    }
}
