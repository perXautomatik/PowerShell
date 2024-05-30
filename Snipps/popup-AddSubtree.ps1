Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Add-GitSubtree {
    param (
        [string]$ExternalRepoUrl,
        [string]$ReferenceSha,
        [string]$SubtreePath
    )

    # Verify that the subtree path does not conflict with existing paths
    if (Test-Path $SubtreePath) {
        [System.Windows.Forms.MessageBox]::Show("The specified subtree path conflicts with an existing path in the repository.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Add the external repository as a remote
    git remote add external-repo $ExternalRepoUrl

    # Fetch the external repository
    git fetch external-repo

    # Add the subtree using the reference SHA
    git subtree add --prefix=$SubtreePath external-repo $ReferenceSha
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Add Git Subtree'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

# Create the input fields
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = 'Please enter the external repository URL:'
$form.Controls.Add($label1)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(10,40)
$textBox1.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,70)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'Please enter the reference SHA:'
$form.Controls.Add($label2)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(10,90)
$textBox2.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox2)

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(10,120)
$label3.Size = New-Object System.Drawing.Size(280,20)
$label3.Text = 'Please enter the subtree path:'
$form.Controls.Add($label3)

$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(10,140)
$textBox3.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox3)

# Create the OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(10,170)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# Show the form
$form.Topmost = $True
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $ExternalRepoUrl = $textBox1.Text
    $ReferenceSha = $textBox2.Text
    $SubtreePath = $textBox3.Text

    Add-GitSubtree -ExternalRepoUrl $ExternalRepoUrl -ReferenceSha $ReferenceSha -SubtreePath $SubtreePath
}
