#Url: https://social.technet.microsoft.com/wiki/contents/articles/30562.powershell-accessing-sqlite-databases.aspx
<#1. Download the SQLite assemblies🔗
Windows doesn't come with SQLite libraries by default. Fortunately, the SQLite foundation provides the necessary libraries to access SQLite databases. First, go to https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki  and download the proper library for your system. As you can see on that page, there are many different options, so you need to figure out what version of the .NET Framework your PowerShell uses, and whether you run a 32bits or 64bits console.
You can figure those things out with two commands: [IntPtr]::Size and $PSVersionTable. If the first command gives you a 4 then you're 32bits, if it's an 8 then pick 64bits. As for the second one, the .NET Framework you use is specified on the CLRVersion line. Here is an example:
#>
[IntPtr]::Size 
#PS> 
$PSVersionTable

<#Name                           Value
#----                           -----
#PSVersion                      4.0
#WSManStackVersion              3.0
#SerializationVersion           1.1.0.1
#CLRVersion                     4.0.30319.34014
#BuildVersion                   6.3.9600.17090
#PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0}
#PSRemotingProtocolVersion      2.2
#>

<#In this case you would download the 64bits file for Microsoft .NET v4.0. Simply run the setup file and it will install the proper DLL files on your system, and register the assemblies.

#2. Importing the SQLite assemblies🔗
#To import the assemblies you need to use the Add-Type command:

#> 
Add-Type -Path "C:\Program Files (x86)\EDP Vision\System.Data.SQLite.dll"
#If you installed the right libraries this should work without error. Once that line is done, you have the needed libraries loaded to access SQLite databases using standard .NET methods.

#3. Connecting to a database🔗
#To connect to the database using the ADO.NET protocol, you need to create a SQLiteConnection object with the proper connection string:

 $con = New-Object -TypeName System.Data.SQLite.SQLiteConnection
#PS>
 $con.ConnectionString = "Data Source=C:\Users\crbk01\AppData\Local\Microsoft\Edge\User Data\Profile 2\History"
#PS>
 $con.Open()
<#If the file exists then it should connect without error, and now you can start issuing commands.

#4. Creating a query🔗
#Accessing data from the database requires the user of a SQLite adapter. First, you need to create a new command, and then pass that command to the adapter:
#> 

$sql = $con.CreateCommand()
#PS>
 $sql.CommandText = "SELECT * FROM sqlite_master"
#PS>
 $adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $sql
#PS> 
$data = New-Object System.Data.DataSet
#PS> 
[void]$adapter.Fill($data)
#This will return the requested data in the dataset we created. You can access it by table, row or individual cells:

#PS>
 $data.tables.rows

<#                                  id message
#                                  -- -------
#                                   1 This is a test
#                                   2 That is also a test
#
#>
$data.tables.rows[0].message
#This is a test

<#
5. Inserting data🔗
You insert data in a similar way, by creating a command, except that now you need to use some SQLiteParameter variables to insert values:
#>

$sql = $con.CreateCommand()
$sql.CommandText = "INSERT INTO test (id, message) VALUES (@id, @message)"
$sql.Parameters.AddWithValue("@id", 3);

<#
IsNullable              : True
DbType                  : Int32
Direction               : Input
ParameterName           : @id
Size                    : 0
SourceColumn            :
SourceColumnNullMapping : False
SourceVersion           : Current
Value                   : 3
Precision               : 0
Scale                   : 0
#>
$sql.Parameters.AddWithValue("@message", "Some more testing");

<#
IsNullable              : True
DbType                  : String
Direction               : Input
ParameterName           : @message
Size                    : 0
SourceColumn            :
SourceColumnNullMapping : False
SourceVersion           : Current
Value                   : Some more testing
Precision               : 0
Scale                   : 0
#>
$sql.ExecuteNonQuery()

#1

<#As you can see, it's pretty straight forward to add values, and you get instant feedback on each parameter, and at the end when you execute the command.
6. Conclusion🔗
Once done, remember to dispose of your command and close the connection to the database:#>

$sql.Dispose()
$con.Close()


