function NewSqliteConnection
{

    param(
        [Parameter(Mandatory = $true)]
        [string]$source
    , [Parameter(Mandatory = $true)]
        [string]$query
    )


    $con = New-Object -TypeName System.Data.SQLite.SQLiteConnection
    ; $safePath = $source.trim()
    $con.ConnectionString = "Data Source=$safepath"
    try
    {
        $con.Open()

        $sql = $con.CreateCommand()
        $sql.CommandText = $query
        $adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $sql
        $data = New-Object System.Data.DataSet
        [void]$adapter.Fill($data)
        $data.tables

    }
    catch
    {
        $con
    }
}