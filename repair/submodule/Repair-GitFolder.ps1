function Repair-GitFolder ($folder) {

# A function to repair a corrupted git folder
  $folder | Get-ChildItem -force | ?{ $_.name -eq ".git" } | % {
    $toRepair = $_

    if( $toRepair -is [System.IO.FileInfo] )
    {
      Move-GitFile $toRepair
    }
    elseif( $toRepair -is [System.IO.DirectoryInfo] )
    {
      Fix-GitConfig $toRepair
    }
    else
    {
      Write-Error "not a .git file or folder: $toRepair"
    }
  }
}
