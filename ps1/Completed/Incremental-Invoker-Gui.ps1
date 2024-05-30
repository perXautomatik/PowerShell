#Requires -Module PSEverything
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
import-module PSEverything

# Load required assembly for thread jobs
#Import-Module ThreadJob
<#TODO: accept piped objects
    specify params
        -beginblock
        -executionblock
        -incrementingblock
        -deincrementingblock
    gui fields representing params, 
        read-writable
        accepting hotloading through them
#>

# Start the parsing process in a separate thread
$ram1 = @(search-everything -filter 'path:scoop path:bucket\ ext:json' -global)


# Create a synchronized queue to hold the matching files
$global:queue = [System.Collections.Concurrent.ConcurrentQueue[String]]::new()


for ($i = 0; $i -lt $ram1.Count; $i++) {
    $global:queue.Enqueue($ram1[$i])
}
$u = "";
$global:queue.TryPeek([ref]$u)
$u

# Define the script block that will parse the files
$hashTable = @{}

# Define the script block that will be invoked by the buttons
$scriptToInvoke = {
    param($action)    
   
    for ($i = 0; $i -lt $ram1.Count; $i++) {
        $action = "";
        $null = $global:queue.TryTake([ref]$action)
        $matchC = (Get-Content -Path $action -ErrorAction SilentlyContinue) -match "mklink"
        if($hashTable[$matchC])
        {}
        else
        {
            $hashTable[$matchC] = $action;
            if ($matchC) {
                return $action            
            }
        }    
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Number Adjuster'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(100,20)
$label.Size = New-Object System.Drawing.Size(100,23)
$label.Text = '0'

$incrementButton = New-Object System.Windows.Forms.Button
$incrementButton.Location = New-Object System.Drawing.Point(150,50)
$incrementButton.Size = New-Object System.Drawing.Size(75,23)
$incrementButton.Text = '>'

# Increment button click event
$incrementButton.Add_Click({
        $q = (& $scriptToInvoke -action 'next')
        $label.Text = $q
        notepad $q
})

$decrementButton = New-Object System.Windows.Forms.Button
$decrementButton.Location = New-Object System.Drawing.Point(50,50)
$decrementButton.Size = New-Object System.Drawing.Size(75,23)
$decrementButton.Text = '<'

# Decrement button click event
$decrementButton.Add_Click({
    if ($threadJob.State -eq 'Completed' -and $global:fileIndex -gt 0) {
        $global:fileIndex--
        $file = & $scriptToInvoke -nextFileIndex $global:fileIndex
        # Update the GUI with the previous file details
        $label.Text = $file.FullName
    }
})


$form.Controls.Add($label)
$form.Controls.Add($incrementButton)
$form.Controls.Add($decrementButton)

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()

