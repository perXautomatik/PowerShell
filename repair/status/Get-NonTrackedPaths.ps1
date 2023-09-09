function Get-NonTrackedPaths {

# Define a function that takes a list of paths as input and returns an array of objects with their status (error message or tracking status)
<#
.SYNOPSIS
Takes a list of paths as input and returns an array of objects with their status (error message or tracking status).

.DESCRIPTION
This function takes a list of paths as input and checks if they are valid git repositories.
It also checks if they are tracked by any other path in the list as a normal part of repository or as a submodule using the Test-GitTracking function.
It returns an array of objects with the path and status (error message or tracking status) as properties.

.PARAMETER Paths
The list of paths to check.

.EXAMPLE
Get-NonTrackedPaths -Paths @("C:\path1", "C:\path2", "C:\path3", "C:\path4")

This example takes a list of four paths and returns an array of objects with their status (error message or tracking status).
#>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Paths # The list of paths to check
  )

  # Initialize an empty array to store the non-tracked paths
  $NonTrackedPaths = @()

  # Initialize a queue to store the paths to be checked
  $PathQueue = New-Object System.Collections.Queue

  # Sort the paths alphabetically and enqueue them
  foreach ($Path in $Paths | Sort-Object) {
    $PathQueue.Enqueue($Path)
  }

  # Initialize an empty array to store the output objects
  $OutputObjects = @()

  # Loop through the queue until it is empty
  while ($PathQueue.Count -gt 0) {

    # Dequeue the first path from the queue
    $Path = $PathQueue.Dequeue()

    # Create an output object with the path as a property
    $OutputObject = New-Object PSObject -Property @{Path = $Path}

    # Check if the path is a valid git repository using the Test-GitRepository function
    if (Test-GitRepository -Path $Path) {

      # Assume the path is not tracked by any other path
      $IsTracked = $false

      # Filter the remaining paths in the queue to only include those that are relative to the current path or vice versa
      $FilteredPaths = @($PathQueue | Where-Object {($_.StartsWith($Path) -or $Path.StartsWith($_))})

      # Loop through the filtered paths with a progress bar
      $j = 0
      foreach ($OtherPath in $FilteredPaths) {

	# Update the progress bar for the inner loop
	$j++
	Write-Progress -Activity "Checking other paths" -Status "Processing other path $j of $($FilteredPaths.Count)" -PercentComplete ($j / $FilteredPaths.Count * 100) -Id 1

	# Check if the other path is a valid git repository using the Test-GitRepository function
	if (Test-GitRepository -Path $OtherPath) {

	  # Check if the current path is tracked by the other path using the Test-GitTracking function
	  try {
	    if (Test-GitTracking -Path $Path -OtherPath $OtherPath) {

	      # Set the flag to indicate the current path is tracked by the other path
	      $IsTracked = $true

	      # Add a status property to the output object of the current path with the tracking status
	      Add-Member -InputObject $OutputObject -MemberType NoteProperty -Name Status -Value "Tracked by $($OtherPath)"

	      # Break the inner loop
	      break

	    }
	  }
	  catch {
	    # Print the error as a verbose message and continue
	    Write-Verbose $_.Exception.Message

	    # Remove the error prone repo from the queue
$d = ([System.Collections.ArrayList]@($PathQueue | Where-Object {$_ -ne $OtherPath}))
	    $PathQueue = New-Object System.Collections.Queue

        foreach ($Path in $d) {
            $PathQueue.Enqueue($Path)
          }


	    # Add a status property to the output object of the other path with the error message
	    foreach ($OutputObject in $OutputObjects) {
	      if ($OutputObject.Path -eq $OtherPath) {
		Add-Member -InputObject $OutputObject -MemberType NoteProperty -Name Status -Value $_.Exception.Message
	      }
	    }

	    continue

	  }

	}

      }

      # If the flag is still false, add the current path to the non-tracked paths array and set its status as untracked
      if (-not $IsTracked) {
	        $NonTrackedPaths += $Path

	        Add-Member -InputObject $OutputObject -MemberType NoteProperty -Name Status -Value "Untracked" -ErrorAction SilentlyContinue
      }

    }
    else {
      # Add a status property to the output object of the current path with an error message
      Add-Member -InputObject $OutputObject -MemberType NoteProperty -Name Status -Value "Invalid git repository"
    }

    # Add the output object to the output objects array
    $OutputObjects += $OutputObject

  }
  $OutputObjects
}
