Yes, you can get statistics from your playlist using PowerShell and the YouTube Data API. You can also get a list of creators and the number of videos they have in your playlist. However, you will need to modify the script I provided earlier to include some additional steps.

First, you will need to get the channel ID of each video in your playlist. You can do this by adding the `contentDetails` part to the `playlistItems.list` request, and selecting the `videoOwnerChannelId` property from the response. For example:

```powershell
$playlistId = "PLBCF2DAC6FFB574DE" # replace with your playlist ID
$creatorName = "Google Developers" # replace with the creator name or channel ID
$apiKey = "AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY" # replace with your API key
$baseUrl = "https://www.googleapis.com/youtube/v3"
$playlistItemsUrl = "$baseUrl/playlistItems"

$videoIds = @() # create an empty array to store the video IDs
$channelIds = @() # create an empty array to store the channel IDs
$nextPageToken = $null # initialize the next page token to null

while ($true) {
    # if there is no next page token, get the first page of results
    if ($nextPageToken -eq $null) {
        $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
            part = "snippet,contentDetails"
            playlistId = $playlistId
            filter = $creatorName
            key = $apiKey
            maxResults = 50
        }
    }
    # otherwise, get the next page of results using the next page token
    else {
        $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
            part = "snippet,contentDetails"
            playlistId = $playlistId
            filter = $creatorName
            key = $apiKey
            maxResults = 50
            pageToken = $nextPageToken
        }
    }

    # add the video IDs and channel IDs from the current page to the arrays
    $videoIds += $response.items.snippet.resourceId.videoId
    $channelIds += $response.items.contentDetails.videoOwnerChannelId

    # update the next page token from the response
    $nextPageToken = $response.nextPageToken

    # if there is no next page token, break the loop
    if ($nextPageToken -eq $null) {
        break
    }
}
```

Next, you will need to get the channel title of each channel ID. You can do this by using the `channels.list` request, and selecting the `title` property from the response. For example:

```powershell
$channelsUrl = "$baseUrl/channels"

$channelTitles = @() # create an empty array to store the channel titles

foreach ($channelId in $channelIds) {
    $response = Invoke-RestMethod -Uri $channelsUrl -Method Get -ContentType "application/json" -Query @{
        part = "snippet"
        id = $channelId
        key = $apiKey
    }

    # add the channel title from the response to the array
    $channelTitles += $response.items.snippet.title
}
```

Finally, you will need to count the number of occurrences of each channel title in your playlist. You can do this by using a hashtable to store the channel title as the key and the count as the value. For example:

```powershell
$channelCounts = @{} # create an empty hashtable to store the channel counts

foreach ($channelTitle in $channelTitles) {
    # if the channel title already exists in the hashtable, increment the count by one
    if ($channelCounts.ContainsKey($channelTitle)) {
        $channelCounts[$channelTitle]++
    }
    # otherwise, add the channel title to the hashtable with a count of one
    else {
        $channelCounts[$channelTitle] = 1
    }
}
```

Now you have a hashtable that contains the channel title and the number of videos they have in your playlist. You can display the results in a table format by using the `Format-Table` cmdlet. For example:

```powershell
$channelCounts | Format-Table -AutoSize
```

This will output something like this:

```
Name                           Value
----                           -----
Google Developers              50
Android Developers             25
Firebase                       15
TensorFlow                     10
```

