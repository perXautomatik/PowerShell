cls

cd 'H:\.config\git'


function count-asHash {
    [CmdletBinding()]
    Param (
        # Param1 help description
        [Parameter(ValueFromPipeline=$true)]
        [string]
        $WorkItem
    )
    begin {        
       $wordCounts=@{} 
    }
    
    process {        
        $wordCounts.$WorkItem++         
    }
    
    end {
       return $wordCounts 
    }
    
}




$all = (git rev-list --all)

$allFilesBlames = (Get-ChildItem -File | select name,@{name='blames'; expression ={ @((git blame $_.Name -l) | %{ ($_ -split ' ')[0].trim()  })}} )

#$allFilesBlames

#| % { $allFilesBlames.Add($_.blames)++ } 

$wordStatistic = $allFilesBlames.blames | count-asHash 
$wordStatistic

$all | ? { $wordStatistic.keys -notcontains $_ }  | %{ [pscustomobject]@{'hash'=$_;'date'=(git show -s --format=%ci $_); 'commit'=(git log --format=%B -n 1 $_ )}} | Sort-Object date -Descending  | Out-GridView

if ($null)
{
gitk 632350fbb552c070d0ca2086bab5fd95ed2b49a4
}
