<#
.SYNOPSIS
This script performs three tasks:
- It creates a folder named ArchBears in the AppData\LocalLow folder of the current user and creates a junction link to another folder with the same name in the E drive.
- It reads all the log and htm files in the Wizards of the Coast folder and writes their content to a single file named Mtga.txt in the E drive.
- It splits a large file named Exceptions.log into smaller files with a size limit of 50 MB and names them as log_1.log, log_2.log, etc.
#>

function Perform-Tasks {
    # Create a folder named ArchBears in the AppData\LocalLow folder of the current user
    New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\ArchBears"

    # Create a junction link from the new folder to another folder with the same name in the E drive
    Start-Process -FilePath "$env:comspec" -ArgumentList "/k", "mklink", "/j", "$env:LOCALAPPDATA\ArchBears", "E:\Users\Dator\AppData\LocalLow\ArchBears"

    # Get all the log and htm files in the Wizards of the Coast folder recursively
    $files = Get-ChildItem -Path "C:\Program Files (x86)\Wizards of the Coast\*" -Include *.log,*.htm -Recurse

    # Read the content of each file and write it to a single file named Mtga.txt in the E drive
    $files | Get-Content | Out-File -FilePath "E:\ToDatabase\log\Mtga.txt"

    # Set the size limit for splitting the Exceptions.log file
    $upperBound = 50MB

    # Set the file extension and root name for the new files
    $ext = "log"
    $rootName = "log_"

    # Create a stream reader object to read the Exceptions.log file
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList "C:\Exceptions.log"

    # Initialize a counter for naming the new files
    $count = 1

    # Create the first file name by joining the root name, the counter and the extension
    $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)

    # Loop through each line of the Exceptions.log file
    while (($line = $reader.ReadLine()) -ne $null) {
        # Write the line to the current file name
        Add-Content -Path $fileName -Value $line

        # Check if the current file exceeds the size limit
        if ((Get-Item -Path $fileName).Length -ge $upperBound) {
            # Increment the counter and create a new file name
            ++$count
            $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
        }
    }

    # Close the stream reader object
    $reader.Close()
}
