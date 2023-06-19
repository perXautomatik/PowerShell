<#
.SYNOPSIS A powershell script that compares each file in a given path to each other and outputs the results in a hashtable.

.DESCRIPTION
The script takes a path as a parameter and reads each file in that path as a JSON object. 
It then compares each file to each other using the following operators: =>, <=, =. 
It also counts the number of differing lines between each pair of files. 
The results are stored in a hashtable where the keys are the file names and the values are another hashtable with the comparison results. 
The script also sorts and arranges the results by similarity, 
where the most similar files are in the middle and the files that are larger or smaller than the initial file
 are at the top or bottom respectively. The script can only perform a limited number of corrections to avoid an endless loop.
#>

function Compare-Files { param ( [Parameter(Mandatory=$true)] [string]$Path )

# Check if the path is valid
if (-not (Test-Path $Path)) {
    Write-Error "Invalid path: $Path"
    return
}

# Get all the files in the path
$Files = Get-ChildItem -Path $Path -File

# Create an empty hashtable to store the results
$Results = @{}

# Loop through each file
foreach ($File1 in $Files) {
    # Read the file content as a JSON object
    $Content1 = Get-Content -Path $File1.FullName -Raw | ConvertFrom-Json

    # Create another empty hashtable to store the comparison results for this file
    $Results[$File1.Name] = @{}

    # Loop through each other file
    foreach ($File2 in $Files) {
        # Skip if it is the same file
        if ($File1.Name -eq $File2.Name) {
            continue
        }

        # Read the other file content as a JSON object
        $Content2 = Get-Content -Path $File2.FullName -Raw | ConvertFrom-Json

        # Compare the two JSON objects using the operators =>, <=, =
        $GreaterOrEqual = Compare-Object -ReferenceObject $Content1 -DifferenceObject $Content2 -IncludeEqual | Where-Object { $_.SideIndicator -eq "==" -or $_.SideIndicator -eq "=>" } | Measure-Object | Select-Object -ExpandProperty Count
        $LessOrEqual = Compare-Object -ReferenceObject $Content1 -DifferenceObject $Content2 -IncludeEqual | Where-Object { $_.SideIndicator -eq "==" -or $_.SideIndicator -eq "<=" } | Measure-Object | Select-Object -ExpandProperty Count
        $Equal = Compare-Object -ReferenceObject $Content1 -DifferenceObject $Content2 -IncludeEqual | Where-Object { $_.SideIndicator -eq "==" } | Measure-Object | Select-Object -ExpandProperty Count

        # Count the number of differing lines between the two files
        $DifferingLines = Compare-Object -ReferenceObject $Content1 -DifferenceObject $Content2 | Measure-Object | Select-Object -ExpandProperty Count

        # Store the comparison results in another hashtable with the other file name as the key and an array of values as the value
        $Results[$File1.Name][$File2.Name] = @($GreaterOrEqual, $LessOrEqual, $Equal, $DifferingLines)
    }
}

# Sort and arrange the results by similarity
# Define a limit for the number of corrections
$Limit = 10

# Define a flag to indicate if any correction is made
$Corrected = $false

# Loop through each result
foreach ($Result in $Results.GetEnumerator()) {
    # Get the file name and the comparison hashtable for this result
    $FileName = $Result.Key
    $Comparison = $Result.Value

    # Sort the comparison hashtable by the number of equal lines in descending order
    # This will put the most similar files in the middle
    $SortedComparison = $Comparison.GetEnumerator() | Sort-Object { $_.Value[2] } -Descending

    # Create an empty array to store the arranged file names
    $ArrangedFiles = @()

    # Loop through each sorted comparison result
    foreach ($SortedResult in $SortedComparison) {
        # Get the other file name and the comparison values for this result
        $OtherFileName = $SortedResult.Key
        $Values = $SortedResult.Value

        # Check if this is the first result in the array
        if ($ArrangedFiles.Count -eq 0) {
            # Add the other file name to the array
            $ArrangedFiles += $OtherFileName
        }
        else {
            # Get the index of the other file name in the array
            $Index = $ArrangedFiles.IndexOf($OtherFileName)

            # Check if the other file name is not in the array
            if ($Index -eq -1) {
                # Add the other file name to the end of the array
                $ArrangedFiles += $OtherFileName
            }
            else {
                # Get the previous and next file names in the array
                $PreviousFileName = $ArrangedFiles[$Index - 1]
                $NextFileName = $ArrangedFiles[$Index + 1]

                # Get the comparison values for the previous and next file names
                $PreviousValues = $Comparison[$PreviousFileName]
                $NextValues = $Comparison[$NextFileName]

                # Check if the current file is larger than the previous file and smaller than the next file
                if ($Values[0] -gt $PreviousValues[0] -and $Values[1] -lt $NextValues[1]) {
                    # Move the other file name to the end of the array
                    $ArrangedFiles = $ArrangedFiles | Where-Object { $_ -ne $OtherFileName }
                    $ArrangedFiles += $OtherFileName

                    # Set the corrected flag to true
                    $Corrected = $true
                }
            }
        }
    }

    # Update the comparison hashtable with the arranged file names and values
    $NewComparison = @{}
    foreach ($File in $ArrangedFiles) {
        $NewComparison[$File] = $Comparison[$File]
    }
    $Results[$FileName] = $NewComparison
}

# Check if any correction is made and the limit is not reached
if ($Corrected -and $Limit -gt 0) {
    # Decrement the limit by one
    $Limit--

    # Recursively call the function to sort and arrange the results again
    Compare-Files -Path $Path
}
else {
    # Return the final results as a hashtable
    return $Results
}

} 