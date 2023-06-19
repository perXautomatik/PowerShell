<#
.SYNOPSIS
This script recursively calculates the size of a folder and its subfolders, excluding the ones that have the ReparsePoint attribute, which means they are symbolic links or mount points. It also handles errors and writes them to the output.
#>

function Get-FolderSize {
    # Get the folder path as a parameter
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$folder
    )

    # Initialize a variable to store the size
    $size = 0

    # Try to get the child items of the folder
    try {
        $children = Get-ChildItem -Path $folder

        # Loop through each child item
        $children | Where-Object {$_.Attributes.ToString() -NotLike "*ReparsePoint*"} | ForEach-Object {
            $item = $_

            # Try to get the full name of the item
            try {
                $fullName = $item.FullName

                # Check if the item is not the same as the folder
                if ($fullName -ne $folder) {
                    # Try to check if the item is a file or a subfolder
                    try {
                        if (-not (Test-Path -Path $fullName -PathType Container)) {
                            # If it is a file, add its length to the size
                            $size += $item.Length
                        }
                        else {
                            # If it is a subfolder, recursively call the function on it and add its size to the size
                            $ress = Get-FolderSize -Folder $fullName
                            $size += $ress
                        }
                    }
                    catch {
                        # Write an error message if the item type check failed
                        Write-Output " inner1@ $ress $size $fullName : $($PSItem.ToString())"
                    }
                }
            }
            catch {
                # Write an error message if the full name retrieval failed
                Write-Output " second@ $size $fullName : $($PSItem.ToString())"
            }
        }
    }
    catch {
        # Write an error message if the child items retrieval failed
        Write-Output " thies@ $size $fullName : $($PSItem.ToString())"
    }

    # Return the size of the folder
    return $size
}

# Example usage
Get-FolderSize -Folder 'C:\Users\crbk01\Desktop'
