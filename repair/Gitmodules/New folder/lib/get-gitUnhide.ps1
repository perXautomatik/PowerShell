function get-gitUnhide ($Path)
{
    Get-ChildItem -Path "$Path\*" -Force | Where-Object { $_.Name -eq ".git" }
}
