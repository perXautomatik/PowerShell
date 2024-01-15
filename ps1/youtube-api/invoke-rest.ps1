Hello, this is Bing. I can help you with your query. ??

Yes, you can use a PowerShell script to remove videos from a YouTube playlist by a certain creator. However, you will need to have access to the playlist ID and the video IDs of the videos you want to remove. You will also need to use the YouTube Data API to perform the playlist operations.

One possible way to do this is to use the `Invoke-RestMethod` cmdlet to send HTTP requests to the YouTube Data API endpoints. You will need to provide your API key and the playlist ID as query parameters. You can also use the `filter` parameter to specify the creator name or channel ID of the videos you want to remove.

For example, to get the video IDs of the videos in a playlist by a certain creator, you can use this command:

```powershell
$playlistId = "PLBCF2DAC6FFB574DE" # replace with your playlist ID
$creatorName = "Google Developers" # replace with the creator name or channel ID
$apiKey = "AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY" # replace with your API key
$baseUrl = "https://www.googleapis.com/youtube/v3"
$playlistItemsUrl = "$baseUrl/playlistItems"

$response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Get -ContentType "application/json" -Query @{
    part = "snippet"
    playlistId = $playlistId
    filter = $creatorName
    key = $apiKey
    maxResults = 50 # you can change this to get more or less results
}

$videoIds = $response.items.snippet.resourceId.videoId # this will store the video IDs in an array
```

To remove the videos from the playlist, you can use this command:

```powershell
$playlistItemsUrl = "$baseUrl/playlistItems"

foreach ($videoId in $videoIds) {
    $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Delete -ContentType "application/json" -Query @{
        id = $videoId
        key = $apiKey
    }
}
```

This will loop through the video IDs and send a DELETE request to the YouTube Data API for each one. You can check the response status code to see if the operation was successful or not.

I hope this helps you with your task. If you need more information, you can check out the [YouTube Data API documentation](^1^) or the [PowerShell documentation](^2^). Have a nice day! ??

Källa: Konversation med Bing, 2024-01-15
(1) Script to remove all videos from Youtube Watch Later playlist. https://gist.github.com/astamicu/eb351ce10451f1a51b71a1287d36880f.
(2) Remove Watched Videos from Youtube Watch Later playlist. https://github.com/gabenasci/yt-remove-watched-videos.
(3) Download a full YouTube playlist with PowerShell - FoxDeploy.com. https://www.foxdeploy.com/blog/download-a-full-youtube-playlist-with-powershell.html.
