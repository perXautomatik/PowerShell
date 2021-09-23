function Chunk-Object
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)] [object[]] $InputObject,
        [Parameter()] [scriptblock] $Process,
        [Parameter()] [int] $ElementsPerChunk
    )

    Begin {
        $cache = @();
        $index = 0;
    }
    Process {
        if($cache.Length -eq $ElementsPerChunk) {
            # if we collected $ElementsPerChunk elements in an array, sent it out to the pipe line
            Write-Output $cache;

            # Then we add the current pipe line object to the array and set the $index as 1
            $cache = @($_);
            $index = 1;
        }
        else {
            $cache += $_;
            $index++;
        }

    }
    End {
        # Here we check if there are anything still in $cache, if so, just sent out it to pipe line
        if($cache) {
            Write-Output $cache;
        }
    }
}


echo 1 2 3 4 5 6 7 | Chunk-Object -ElementsPerChunk 2;
Write-Host "=============================================================================";
(echo 1 2 3 4 5 6 7 | Chunk-Object -ElementsPerChunk 2).gettype();
Write-Host "=============================================================================";
(echo 1 2 3 4 5 6 7 | Chunk-Object -ElementsPerChunk 2).length;

Url: https://stackoverflow.com/questions/20871425/powershell-function-to-chunk-the-pipe-line-objects-into-arrays-cant-get-the-cor