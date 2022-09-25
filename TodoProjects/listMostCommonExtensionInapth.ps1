

#get list of most common extension of children in path |
    #that we then can pipe and ask over larger areas, |

$hash = @()
Get-ChildItem  -Path $path -Recurse -File | Group-Object -Property Extension

#convert the path into a pso object, and assign the new propperty, hash with extensions, and then a sorted stringed version of the same.
