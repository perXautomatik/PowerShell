    param (
        [string]$Path,
        $expectedFilePath = "filter-repo\analysis\directories-all-sizes.txt"
    )

    function Test-PathExistence {
        param ([string]$Path)
        
        # Check if the path exists
        if (-not (Test-Path -Path $Path)) {            
            throw "The specified path does not exist."
        }
    }
    
    function Test-IsFile {
        param ([string]$Path,
                [string]$like
        )
        if(Test-Path -Path $Path -PathType Leaf) 
        {
            if ($Path -like $like) {
                return $true
            } else {                
                throw "Path does not point to the specified file."
            }
        }
        else {
            return $false
        }
    }
    
    function Test-isDirectory {
        param ([string]$Path)
        return Test-Path -Path $Path -PathType Container
    }
    
    function Test-SpecificFileInGitDirectory {
        param (
            [string]$GitDirectoryPath,
            [string]$FilePath
        )
        if (Test-Path -Path $fullPath -PathType Leaf) {        
            return  Join-Path -Path $GitDirectoryPath -ChildPath $FilePath
        }        
    }
    
    function Invoke-Git {
        param (
            [string]$GitCommand,
            [string]$RepoPath
        )
        git -C $RepoPath $GitCommand 2>$null
        return $?
    }

    function ensure-Analyze
    {
        [CmdletBinding()]
        param (
            [Parameter()]
            [string]
            $Path,
            $expectedFilePath
        )
        $returnPath = Test-SpecificFileInGitDirectory -GitDirectoryPath $Path -FilePath $expectedFilePath;
        if ($returnPath) {
            Write-Verbose "Path points to a .git folder containing the specified file."
            return $returnPath
        } else {
            # Check if the path points to a valid Git repository
            if (Invoke-Git -GitCommand "rev-parse --is-inside-work-tree" -RepoPath $Path) {
                # Attempt to analyze the repository
                if (Invoke-Git -GitCommand "filter-repo --analyze --force" -RepoPath $Path) {
                    $returnPath = Test-SpecificFileInGitDirectory -GitDirectoryPath $Path -FilePath $expectedFilePath
                    if ($returnPath) {
                        Write-Verbose "Analysis complete. Path points to a .git folder containing the specified file."
                        return $returnPath
                    } else {
                        throw "Analysis complete. Path points to a .git folder but does not contain the specified file."
                    }
                } else {
                    throw "Failed to analyze the repository."                    
                }
            } else {
                throw "The path does not point to a valid Git repository."                
            }
        }
    }

    # Check if the path exists
    Test-PathExistence -Path $Path

    # Check if the path points directly to the file
    if (Test-IsFile -Path $Path -like "*.git\$expectedFilePath") {
        $filepath = $Path;
    }
    # Check if the path points to a .git directory and contains the file
    elseif (Test-isDirectory -Path $Path) {
        $filepath = ensure-Analyze -path $Path
    }
    # If neither, return that the path is invalid
    else {
        throw "Path is not valid."
    }

    $fileContent = $filepath | Get-Content

<#Create Custom Objects with Column Names:
Split the second row (column names) by the tab character (\t) to get an array of column names.
For each subsequent row, split it by the tab character and create custom objects with properties corresponding to the column names:#>
$columnNames = $fileContent[1] -split '\t'
$customObjects = foreach ($line in $fileContent[2..($fileContent.Length - 1)]) {
    $columns = $line -split '\t'
    $obj = [PSCustomObject]@{}
    for ($i = 0; $i -lt $columnNames.Length; $i++) {
        $obj | Add-Member -MemberType NoteProperty -Name $columnNames[$i] -Value $columns[$i]
    }
    $obj
}

<#Access the Custom Objects by Column Names:
Now you have an array of custom objects, each representing a row from your file.
You can access the properties by their column names. For example:#>
$customObjects[0].'unpacked size'   # Access the 'unpacked size' of the first row
$customObjects[1].'directory name'  # Access the 'directory name' of the second row

<#Filter or Process the Data:
You can filter or manipulate the data as needed. For instance, to get only rows where Date Deleted is <present>:#>
$filteredObjects = $customObjects | Where-Object { $_.'date deleted' -eq '<present>' }