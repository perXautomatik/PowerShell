<#
.SYNOPSIS
Get the tab groups information from a JSON file.

.DESCRIPTION
This script takes one parameter: the path to the JSON file that contains the tab groups information. It then reads the content of the file and converts it from JSON to a custom object. It then extracts the creation date, title and url of each tab group and returns them as a list of custom objects.

.PARAMETER Thing
The path to the JSON file that contains the tab groups information.

.EXAMPLE
PS C:\> Get-Something -Thing 'E:\Google Drive\Downloads\thot kute.json'

This example gets the tab groups information from the 'E:\Google Drive\Downloads\thot kute.json' file.
#>

function Get-Something {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [pscustomobject]$Thing
    )
    process {

        # Read the content of the JSON file and convert it to a custom object
        $content = Get-Content -Path $Thing | ConvertFrom-Json

        # Get the state property of the custom object and convert it from JSON to another custom object
        $state = $content.state | ConvertFrom-Json

        # Get the tabGroups property of the state object, which is an array of tab group objects
        $tabGroups = $state.tabGroups

        # Initialize an empty array to store the result
        $result = @()

        # Loop through each tab group object
        foreach ($tabGroup in $tabGroups) {

            # Get the createDate and tabsMeta properties of the tab group object
            $creationDate = $tabGroup.createDate
            $tabsMeta = $tabGroup.tabsMeta

            # Loop through each tab meta object in the tabsMeta array
            foreach ($tabMeta in $tabsMeta) {

                # Get the title and url properties of the tab meta object
                $title = $tabMeta.title
                $url = $tabMeta.url

                # Create a new custom object with the creation date, title and url properties and add it to the result array
                $result += [pscustomobject] @{
                    creationDate = $creationDate
                    title = $title
                    url = $url
                }
            }
        }

        # Return the result array
        $result
    }
}