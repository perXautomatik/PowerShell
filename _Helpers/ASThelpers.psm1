#using namespace System.Management.Automation.Language

	function get-Function { (Get-ChildItem Function:$args).ScriptBlock.Ast.Body.Parent.Extent.text }
	function get-AstExtent { (Get-ChildItem Function:$args).ScriptBlock.Ast.Extent }
	
	function get-FunctionsFromAst($ast) {$AST.FindAll({$args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}, $true)}
	function get-astFromFile {     # Load the PS1 file as an AST
	  [System.Management.Automation.Language.Parser]::ParseFile($args, [ref]$null, [ref]$null)
	}
	function get-Functions($path) {
	  $AST = get-astFromFile $PS1File
  
	  # Get all the function definitions in the AST
	    get-FunctionsFromAst $ast | % {
	      [PSCustomObject]@{
	          name = $_.name
	          StartRow = $_.Extent.StartLineNumber
	          EndRow = $_.Extent.EndLineNumber 
	          ExtentText = $_.Extent.text
	      }
	    }    
   
	  }
	  
	function SplitOutFunctions ($PS1File)
	{
	  $Functions = get-Functions $PS1File
  
	  # Loop through each function definition
	  foreach ($Function in $Functions) {
  
	      # Define the path of the new file with the function name
	      $NewFile = Join-Path (Split-Path $PS1File) ($Function.Name + ".ps1")
  
	      # Write the function body to the new file
	      Set-Content -Path $NewFile -Value $Function.ExtentText
	  }
function addTo-Profile($name) { $func = get-function $name ; Add-Content -Path $PROFILE -Value $func }

# Define a function that takes a path, a line number, and a switch parameter as parameters
	function Get-RowNumber {
	    param (
	      [string]$Path,
	      [int]$StartColumnNumber,
	      [switch]$EndLine
	  )

	  # Check if the path is valid and the file exists
	  if (-not (Test-Path -Path $Path -PathType Leaf)) {
	      Write-Error "Invalid path or file not found: $Path"
	      return
	  }

	  # Get the length of each line in the file
  
	  # Initialize the row number and the character count
	  $RowNumber = 0
	  $CharCount = 0

	  # Loop through the line lengths until the character count exceeds the start column number of the extent
	  foreach ($LineLength in (Get-Content -Path $Path | % { $_ | Measure-Object -Property Length })) {
	      # Increment the row number
	      $RowNumber++

	      # Add the line length and one (for the newline character) to the character count
      
	      $CharCount += $LineLength.Length + 1

	      # Check if the character count is greater than or equal to the start column number of the extent
	      if ($CharCount -ge $StartColumnNumber) {
	          # Return the row number
	          return $RowNumber
	      }
	  }

	  # If the loop ends without finding a match, return an error message
	  Write-Error "The extent value does not match any row in the file"

	}


	function Get-ExtentInfo {
	    param (
	        [System.Management.Automation.Language.IScriptExtent]$Extent
	    )

	    # Check if the extent is valid
	    if (-not $Extent) {
	        Write-Error "Invalid extent value"
	        return
	    }

	    # Get the path from the File property of the extent object
	    $Path = $Extent.File

	    # Check if the path is valid and the file exists
	    if (-not (Test-Path -Path $Path -PathType Leaf)) {
	        Write-Error "Invalid path or file not found: $Path"
	        return
	    }

	    # Get the start row and the end row of the extent using the Get-RowNumber function or its variants defined earlier
	    $StartRow = Get-RowNumber -Path $Path -StartLineNumber $Extent.StartLineNumber 
	    $EndRow = Get-RowNumber -Path $Path -EndLineNumber $Extent.EndLineNumber -EndLine 

	    # Get the start index and the end index of the extent in the content string using a loop
	    $StartIndex = 0
	    $EndIndex = 0
	    $CurrentLine = 1
	    $CurrentColumn = 1

	    for ($i = 0; $i -lt $Content.Length; $i++) {
	        # Check if the current character is a newline character
	        if ($Content[$i] -eq "`n") {
	            # Increment the current line and reset the current column
	            $CurrentLine++
	            $CurrentColumn = 1
	        }
	        else {
	            # Increment the current column
	            $CurrentColumn++
	        }

	        # Check if the current line and column match the start line and column of the extent
	        if ($CurrentLine -eq $StartLineNumber -and $CurrentColumn -eq $StartColumnNumber) {
	            # Set the start index to the current index
	            $StartIndex = $i
	        }

	        # Check if the current line and column match the end line and column of the extent
	        if ($CurrentLine -eq $EndLineNumber -and $CurrentColumn -eq $EndColumnNumber) {
	            # Set the end index to the current index
	            $EndIndex = $i

	            # Break out of the loop
	            break
	        }
	    }

	    # Get the text of the extent by slicing the content string
	    $ExtentText = $Content.Substring($StartIndex, $EndIndex - $StartIndex + 1)

	    # Create a custom object with the properties: StartRow, EndRow, and ExtentText
	    $Object = [PSCustomObject]@{
	        StartRow = $StartRow
	        EndRow = $EndRow
	        ExtentText = $ExtentText
	    }

	    # Return the custom object
	    return $Object
	}
	function addTo-Profile($name) { $func = get-function $name ; Add-Content -Path $PROFILE -Value $func }

	function Copy-Function {
	  param(
	    [string]$Name # The name of the function to copy
	  )
	  addTo-Profile $Name
	}
