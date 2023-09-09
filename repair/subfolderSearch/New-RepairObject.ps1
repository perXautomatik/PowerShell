function New-RepairObject {

# Define a function to create an object for repairing a failed result
    <#
    .SYNOPSIS
    Creates an object for repairing a failed result.

    .DESCRIPTION
    This function takes a result object, a hashtable, and a regex as parameters and creates an object for repairing a failed result.
    It uses Get-GitFileContent function to get the content of the git file of the result.
    It uses Test-Path cmdlet and ContainsKey method to check if there is a successful content for the same repo name in the hashtable.
    
    .PARAMETER Result
    A result object that contains the properties GitFile, Success, RepoName, and RepoPath.

    .PARAMETER Hashtable
    A hashtable that stores the content by repo name.

    .PARAMETER Regex
    A regular expression that matches the failure pattern.

     .EXAMPLE
     PS C:\> New-RepairObject $result $success_content "fatal"
     
     #>

     # Validate the parameters
     [CmdletBinding()]
     param (
         [Parameter(Mandatory=$true)]
         [ValidateNotNull()]
         [PSCustomObject]$Result,
 
         [Parameter(Mandatory=$true)]
         [ValidateNotNull()]
         [hashtable]$Hashtable,
 
         [Parameter(Mandatory=$true)]
         [ValidateNotNullOrEmpty()]
         [string]$Regex
     )

     
         # Get the repo name of the result
         $repoName = $Result.RepoName
 
         # Check if the result is not successful using Test-Path cmdlet and Regex parameter
         if (-not (Test-Path $Result.RepoPath -PathType Container) -or $Result.Success -match $Regex) {
             # Check if there is a successful content for the same repo name in the hashtable using ContainsKey method
             if ($Hashtable.ContainsKey($repoName)) {
                 # Get the successful content from the hashtable
                 $content = $Hashtable[$repoName]
 
                 # Get the failed content of the git file of the result using Get-GitFileContent function
                 $failed = Get-GitFileContent $Result.GitFile
 
                 # Create an object for repairing the failed result with properties RepoName, toReplace, failed, and GitFile
                 $repairObject = [PSCustomObject]@{
                     RepoName = $repoName
                     toReplace = $content
                     failed = $failed
                     GitFile = $Result.GitFile
                 }
 
                 # Return the repair object
                 return $repairObject
             }
         }
     
 }
