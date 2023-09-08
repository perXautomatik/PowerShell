function Process-Files {
# A function to process files with git status and repair them if needed
    param (
        [Parameter(Mandatory=$true)]
        [string]$Start,
        [Parameter(Mandatory=$true)]
        [string]$Modules
    )
    
    begin {
        
        Push-Location

        # Validate the arguments
        Validate-Path -Path $Start -Name "start"
        Validate-Path -Path $Modules -Name "modules"

        # Redirect the standard error output of git commands to the standard output stream
        $env:GIT_REDIRECT_STDERR = '2>&1'

        Write-Progress -Activity "Processing files" -Status "Starting" -PercentComplete 0

        # Create a queue to store the paths
        $que = New-Object System.Collections.Queue

        # Enqueue the start path
        $Start | % { $que.Enqueue($_) }

        # Initialize a counter variable
        $i = 0;
        
    }
    
    process {

         # Loop through the queue until it is empty
         do
         {    
             # Increment the counter
             $i++;

             # Dequeue a path from the queue
             $path = $que.Dequeue()

             # Change the current directory to the path
             Set-Location $path;

             # Run git status and capture the output
             $output = git status

             # Check if the output is fatal
             if($output -like "fatal*")
             {
                 Repair-Git -Path $path -Modules $modules 
             }
             else
             {
                 # Get the subdirectories of the path and enqueue them, excluding any .git folders
                 Get-ChildItem -Path "$path\*" -Directory -Exclude "*.git*" | % { $que.Enqueue($_.FullName) }
             }

             # Calculate the percentage of directories processed
             $percentComplete =  ($i / ($que.count+$i) ) * 100

             # Update the progress bar
             Write-Progress -Activity "Processing files" -PercentComplete $percentComplete

         } while ($que.Count -gt 0)
    }
    
    end {
        # Restore the original location
        Pop-Location

    # Complete the progress bar
        Write-Progress -Activity "Processing files" -Status "Finished" -PercentComplete 100
    }
}
