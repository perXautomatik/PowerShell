Function Union-Object ([String[]]$Property = @()) {             # https://powersnippets.com/union-object/
    $Objects = $Input | ForEach {$_}                            # Version 02.00.01, by iRon
    If (!$Property) {ForEach ($Object in $Objects) {$Property += $Object.PSObject.Properties | Select -Expand Name}}
    $Objects | Select ([String[]]($Property | Select -Unique))
} Set-Alias Union Union-Object
