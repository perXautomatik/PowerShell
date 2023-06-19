<#
.SYNOPSIS
Export the tab groups information from multiple JSON files to a CSV file.

.DESCRIPTION
This script takes one parameter: the path to the folder that contains the JSON files with the tab groups information. It then uses the Get-Something function to get the creation date, title and url of each tab group from each JSON file. It then uses the Union-Object function to combine the results from all JSON files into a single array of custom objects. It then exports the array to a CSV file with the same name as the folder and a .csv extension.

.PARAMETER Folder
The path to the folder that contains the JSON files with the tab groups information.

.EXAMPLE
PS C:\> .\export-tab-groups.ps1 -Folder 'E:\Google Drive\Downloads'

This example exports the tab groups information from all JSON files in the 'E:\Google Drive\Downloads' folder to a CSV file called 'E:\Google Drive\Downloads.csv'.
#>

# Define a function to export the tab groups information from multiple JSON files to a CSV file
function Export-TabGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Folder
    )

    # Get the list of JSON files in the folder
    $jsonFiles = Get-ChildItem -Path $Folder -Filter *.json

    # Initialize an empty array to store the result
    $result = @()

    # Loop through each JSON file
    foreach ($jsonFile in $jsonFiles) {

        # Get the tab groups information from the JSON file using the Get-Something function
        $temp = Get-Something -Thing $jsonFile.FullName

        # Add the tab groups information to the result array using the Union-Object function
        $result = $result | Union-Object -Property creationDate, title, url -InputObject $temp
    }

    # Construct the CSV file name from the folder name and a .csv extension
    $csvFile = $Folder + '.csv'

    # Export the result array to the CSV file with a semicolon delimiter and no type information
    $result | Export-Csv -Path $csvFile -Delimiter ';' -NoTypeInformation
}

# Dot-source the Get-Something function from another script file
. ./get-something.ps1

# Dot-source the Union-Object function from another script file
. ./union-object.ps1

# Call the function with the parameter from the command line
Export-TabGroups -Folder $Folder

#EOF
