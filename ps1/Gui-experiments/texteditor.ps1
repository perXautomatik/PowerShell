Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'PowerShell Textbox GUI'
$form.Size = New-Object System.Drawing.Size(500, 300)
$form.StartPosition = 'CenterScreen'

# Create the textbox
$textbox = New-Object System.Windows.Forms.RichTextBox
$textbox.Location = New-Object System.Drawing.Point(10, 10)
$textbox.Size = New-Object System.Drawing.Size(460, 200)
$textbox.MultiLine = $true
$textbox.ScrollBars = 'Vertical'

# Function to update line numbers
function Update-LineNumbers {
    $lineNumber = 1
    $textbox.Text.Split("`n") | ForEach-Object {
        $prefix = "{0:D3} " -f $lineNumber
        $textbox.Text = $textbox.Text -replace ("^" + [regex]::Escape($_)), ($prefix + $_)
        $lineNumber++
    }
}

# Highlight the fourth line
function Highlight-Line {
    $lines = $textbox.Lines
    $lines[3] = $lines[3].Insert(0, ">> ")
    $textbox.Lines = $lines
    $textbox.Select($textbox.GetFirstCharIndexFromLine(3), $lines[3].Length)
    $textbox.SelectionBackColor = [System.Drawing.Color]::Blue
    $textbox.SelectionColor = [System.Drawing.Color]::White
}

# Create the listbox for multiple selections
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10, 220)
$listBox.Size = New-Object System.Drawing.Size(460, 40)
$listBox.SelectionMode = 'MultiExtended'

# Add items to the listbox
1..5 | ForEach-Object { [void] $listBox.Items.Add("Item $_") }

# Add controls to the form
$form.Controls.Add($textbox)
$form.Controls.Add($listBox)

# Show the form
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
