$playlistId = "PLBCF2DAC6FFB574DE" # replace with your playlist ID
$creatorName = "Google Developers" # replace with the creator name or channel ID
$apiKey = "AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY" # replace with your API key
$baseUrl = "https://www.googleapis.com/youtube/v3"
$playlistItemsUrl = "$baseUrl/playlistItems"

# get the video IDs of the videos in the playlist by the creator
$response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
    part = "snippet"
    playlistId = $playlistId
    filter = $creatorName
    key = $apiKey
    maxResults = 50
}

$videoIds = $response.items.snippet.resourceId.videoId # this will store the video IDs in an array

# construct the batch request body
$boundary = "batch_youtube_example" # this can be any string
$body = "" # this will store the request body

foreach ($videoId in $videoIds) {
    # add a boundary line
    $body += "--$boundary`r`n"
    # add the content type header
    $body += "Content-Type: application/http`r`n"
    # add the content transfer encoding header
    $body += "Content-Transfer-Encoding: binary`r`n"
    # add a blank line
    $body += "`r`n"
    # add the individual request method, URL, and headers
    $body += "DELETE $playlistItemsUrl?id=$videoId&key=$apiKey`r`n"
    $body += "Content-Type: application/json`r`n"
    # add another blank line
    $body += "`r`n"
}

# add the final boundary line
$body += "--$boundary--"

# send the batch request
$response = Invoke-RestMethod -Uri "$playlistItemsUrl?batch=true" -Method Post -ContentType "multipart/mixed; boundary=$boundary" -Body $body

