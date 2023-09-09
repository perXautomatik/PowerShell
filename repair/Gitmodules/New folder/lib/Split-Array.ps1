function Split-Array
{


# This function takes an array of objects and splits it into smaller chunks of a given size
# It also executes a script block on each chunk if provided
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)] [object[]] $InputObject,
        [Parameter()] [scriptblock] $Process,
        [Parameter()] [int] $ChunkSize
    )

    Begin { #run once
        # Initialize an empty array to store the chunks
        $cache = @();
        # Initialize an index to keep track of the chunk size
        $index = 0;
    }
    Process { #run each entry

        if($cache.Length -eq $ChunkSize) {
            # if the cache array is full, send it out to the pipe line
            write-host '{'  –NoNewline
            write-host $cache –NoNewline
            write-host '}'

            # Then we add the current pipe line object to the cache array and reset the index
            $cache = @($_);
            $index = 1;
        }
        else {
            # Otherwise, we append the current pipe line object to the cache array and increment the index
            $cache += $_;
            $index++;
        }

      }
    End { #run once
        # Here we check if there are any remaining objects in the cache array, if so, send them out to pipe line
        if($cache) {
            Write-Output ($cache );
        }
    }
}
