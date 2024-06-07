#function Get-ShaHash {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string]$inp,
        [ValidateSet(1, 256, 384, 512)]
        [int]$bit = 512,
        [ValidateSet("File", "String")]
        [string]$Type = "File"
    )

    begin {
        function Resolve-FullPath ([string]$Path) {    
            if (-not ([IO.Path]::IsPathRooted($Path))) {
                $Path = Join-Path $PWD $Path
            }
            [IO.Path]::GetFullPath($Path)
        }

        $sha = New-Object System.Security.Cryptography.SHA$bit`CryptoServiceProvider
    }

    process {
        if ($Type -eq "File") {
            $inp = Resolve-FullPath $inp
            $toHash = [IO.File]::ReadAllBytes([IO.FileInfo]$inp)
        } else {
            $toHash = [Text.Encoding]::UTF8.GetBytes($inp)
        }
        [BitConverter]::ToString($sha.ComputeHash($toHash))
    }
#}
