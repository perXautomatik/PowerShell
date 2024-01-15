$playlistId = "PLBCF2DAC6FFB574DE" # replace with your playlist ID
$creatorName = "Google Developers" # replace with the creator name or channel ID
$apiKey = "AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY" # replace with your API key
$baseUrl = "https://www.googleapis.com/youtube/v3"
$playlistItemsUrl = "$baseUrl/playlistItems"

$videoIds = @() # create an empty array to store the video IDs
$nextPageToken = $null # initialize the next page token to null

while ($true) {
    # if there is no next page token, get the first page of results
    if ($nextPageToken -eq $null) {
        $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
            part = "snippet"
            playlistId = $playlistId
            filter = $creatorName
            key = $apiKey
            maxResults = 50
        }
    }
    # otherwise, get the next page of results using the next page token
    else {
        $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
            part = "snippet"
            playlistId = $playlistId
            filter = $creatorName
            key = $apiKey
            maxResults = 50
            pageToken = $nextPageToken
        }
    }

    # add the video IDs from the current page to the array
    $videoIds += $response.items.snippet.resourceId.videoId

    # update the next page token from the response
    $nextPageToken = $response.nextPageToken

    # if there is no next page token, break the loop
    if ($nextPageToken -eq $null) {
        break
    }
}

# now you have all the video IDs in the array, you can remove them from the playlist as before
foreach ($videoId in $videoIds) {
    $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Delete -ContentType "application/json" -Query @{
        id = $videoId
        key = $apiKey
    }
}

