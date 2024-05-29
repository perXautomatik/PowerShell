Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptToInvoke = {
    # Replace this with the actual script line you want to run
    param($number)
    Write-Host "The current number is: $number"
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
$incrementButton.Text = '→'
$incrementButton.Add_Click({
    $label.Text = [int]$label.Text + 1
    & $scriptToInvoke -number $label.Text
})

$decrementButton = New-Object System.Windows.Forms.Button
$decrementButton.Location = New-Object System.Drawing.Point(50,50)
$decrementButton.Size = New-Object System.Drawing.Size(75,23)
$decrementButton.Text = '←'
$decrementButton.Add_Click({
    $label.Text = [int]$label.Text - 1
    & $scriptToInvoke -number $label.Text
})

$form.Controls.Add($label)
$form.Controls.Add($incrementButton)
$form.Controls.Add($decrementButton)

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
