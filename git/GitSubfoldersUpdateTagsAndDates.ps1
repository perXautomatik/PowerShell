<#
.SYNOPSIS
Commit every folder that contains a sub repo with a custom date and message.

.DESCRIPTION
This script takes one parameter: the path to the root folder that contains the sub repos. It then uses the Get-ChildItem cmdlet to get the list of folders that contain a file of esp. It then runs the Header gen function for each folder and tags the sub repo with the output. It then gets the date created, modified and accessed of each file in the folder and converts them to dates using the StringToDate function. It then sets the commit environment variables to the oldest and newest dates among them using the SetCommitEnviormentDateTime function. It then commits the sub repo with a message that contains the size of the folder in bytes.

.PARAMETER RootFolder
The path to the root folder that contains the sub repos.

.EXAMPLE
PS C:\> .\commit-sub-repos.ps1 -RootFolder "C:\Users\user\Documents\Project"

This example commits every folder that contains a sub repo under "C:\Users\user\Documents\Project" with a custom date and message.
#>

# Define a function to set the commit environment variables to a custom date
function SetCommitEnviormentDateTime([datetime]$Committer, [datetime]$Author) {

    # Format the dates as ISO 8601 strings
    $committerDate = $Committer.ToString("yyyy-MM-ddTHH:mm:ss")
    $authorDate = $Author.ToString("yyyy-MM-ddTHH:mm:ss")

    # Set the environment variables for GIT_COMMITTER_DATE and GIT_AUTHOR_DATE
    $env:GIT_COMMITTER_DATE = $committerDate
    $env:GIT_AUTHOR_DATE = $authorDate
}

# Define a function to initialize a git repository in a folder
function InitGit([string]$Folder) {

    # Change the current directory to the folder
    Set-Location -Path $Folder

    # Run git init command
    git init
}

# Define a function to commit every folder that contains a sub repo with a custom date and message
function Commit-SubRepos {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootFolder
    )

    # Get the list of folders that contain a file of esp in the root folder
    $folders = Get-ChildItem -Path $RootFolder -Directory -Filter *.esp

    # Loop through each folder
    foreach ($folder in $folders) {

        # Run Header gen function for each folder and tag the sub repo with the output
        $tag = Header-Gen -Folder $folder.FullName
        git tag $tag

        # Initialize an empty array to store the dates of each file in the folder
        $dates = @()

        # Get the date created, modified and accessed of each file in the folder and convert them to dates using StringToDate function
        foreach ($file in Get-ChildItem -Path $folder.FullName) {
            $dates += StringToDate -OldFilename $file.DateCreated
            $dates += StringToDate -OldFilename $file.DateModified
            $dates += StringToDate -OldFilename $file.DateAccessed
        }

        # Set the commit environment variables to the oldest and newest dates among them using SetCommitEnviormentDateTime function
        SetCommitEnviormentDateTime -Committer (Get-MinimumDate -Dates $dates) -Author (Get-MaximumDate -Dates $dates)

        # Commit the sub repo with a message that contains the size of the folder in bytes
        git commit -m "$($folder.Length / 1MB) MB $($folder.Length / 1KB) KB $($folder.Length) bytes"
    }
}

# Dot-source the Header-Gen, StringToDate, Get-MinimumDate and Get-MaximumDate functions from another script file
. ./helper-functions.ps1

# Call the function with the parameter from the command line
Commit-SubRepos -RootFolder $RootFolder

#EOF
