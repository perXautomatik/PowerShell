cd 'B:\Users\chris\Documents'

if($null)
{
    $method= "user.getWeeklyTrackChart"

    $user = "konstruktor_k"

    $apikey = "cb1587d2573cef68818e8a22edc76ec5"

    $rest = "http://ws.audioscrobbler.com/2.0/?method=$method&user=$user&api_key=$apikey&format=json"

    $jsonResponse = Invoke-RestMethod $rest
    $jsonResponse | ConvertTo-json -Depth 100 > .\jsonResponse.json
    "rebuilt"
}

Get-Content .\jsonResponse.json | ConvertFrom-Json

