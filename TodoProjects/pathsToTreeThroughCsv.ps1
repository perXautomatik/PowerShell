cd 'B:\Users\chris\Documents\'

$list = Get-ChildItem -Recurse -Filter '.git'

$q = $list | select -property @{name='path'; expression={$_.FullName }} | select path,@{name='depth';expression={$_.path.split('\').Length}} | Sort-Object -Property depth -Descending

$Header = 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8', 'col9'





$list = $q.path | convertFrom-csv -Delimiter "\" -Header $Header

#$list | %{($_.PSObject.Properties).PSObject.Properties}

$columnNames = ($list | Get-Member -membertype property,noteproperty)

$duplicates = (
    
    $list | Group-Object -Property $columnNames[0]
    
    
    )

$duplicates