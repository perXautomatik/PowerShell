<#
.SYNOPSIS
This script accepts an arbitrary json string of nested depth greater than 1 and returns each key-value pair at depth 1 as a separate flat list. Each returned value is also a json string.
#>

function Unnest-Json {
    # Get the input json string as a parameter
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$input
    )

    # Convert the input string to a custom object
    $json = ($input | ConvertFrom-Json)

    # Check if the conversion was successful
    if (($json | Measure-Object).Count -eq 0) {
        # Return an error message if not
        return "Malformed json, failed at ConvertFrom-Json"
    }
    else {
        # Get the value of the first property of the custom object, which should be an array of nested objects
        $psObjectWithTypeHeader = $json.psobject.properties.value

        # Check if the value was retrieved successfully
        if (($psObjectWithTypeHeader | Measure-Object).Count -eq 0) {
            # Return an error message if not
            return "Malformed json, failed at psobject.properties.value"
        }
        else {
            # Get the properties of each nested object in the array
            $psObjectProperies = $psObjectWithTypeHeader.PSObject.Properties

            # Check if the properties were retrieved successfully
            if (($psObjectProperies | Measure-Object).Count -eq 0) {
                # Return an error message if not
                return "Malformed json, failed at psobject.properties"
            }
            else {
                # Loop through each property and get its name and value as a flat list
                $flatListContentExposedStillToNested = $psObjectProperies | ForEach-Object { $_.Name; $_.Value }

                # Check if the flat list was created successfully
                if (($flatListContentExposedStillToNested | Measure-Object).Count -eq 0) {
                    # Try an alternative way of getting the property names using Get-Member
                    $nothing = $psObjectWithTypeHeader | Get-Member -MemberType Property | ForEach-Object {$_.Name}

                    # Check if the alternative way was successful
                    if (($nothing | Measure-Object).Count -eq 0) {
                        # Return an error message if not
                        return "Malformed json, failed at get-member-membertype"
                    }
                    else {
                        # Use the alternative result as the flat list
                        $flatListContentExposedStillToNested = $nothing
                    }
                }
                else {
                    # Loop through each item in the flat list and convert it to a json string
                    $flatListContentExposedStillToNested | ForEach-Object { $_ | ConvertTo-Json }
                }
            }
        }
    }
}

# Example usage
$sampleJson = '{"data":[{"name":"Alice","age":25},{"name":"Bob","age":30},{"name":"Charlie","age":35}]}'
$sampleJson | Unnest-Json

