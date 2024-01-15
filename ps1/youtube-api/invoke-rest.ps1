Yes, you can create a new YouTube playlist with PowerShell using the YouTube Data API. You will need to use the `playlists.insert` method to create a new playlist, and the `playlistItems.insert` method to add videos to the playlist. You will also need to provide your API key and access token for authentication.

To create a new playlist, you can use this command:

```powershell
$playlistsUrl = "$baseUrl/playlists"

# create a playlist object with the title and description
$playlist = @{
    snippet = @{
        title = "My new playlist" # replace with your playlist title
        description = "This playlist contains the videos I deleted from another playlist" # replace with your playlist description
    }
}

# convert the playlist object to JSON
$playlistJson = $playlist | ConvertTo-Json

# send a POST request to the playlists endpoint with the playlist JSON
$response = Invoke-RestMethod -Uri $playlistsUrl -Method Post -ContentType "application/json" -Headers @{
    Authorization = "Bearer $accessToken" # replace with your access token
} -Body $playlistJson

# get the playlist ID from the response
$playlistId = $response.id
```

This will create a new playlist and return the playlist ID in the response. You can use this ID to add videos to the playlist.

To add videos to the playlist, you can use this command:

```powershell
$playlistItemsUrl = "$baseUrl/playlistItems"

# loop through the video IDs that you want to add to the playlist
foreach ($videoId in $videoIds) {
    # create a playlist item object with the playlist ID and video ID
    $playlistItem = @{
        snippet = @{
            playlistId = $playlistId
            resourceId = @{
                kind = "youtube#video"
                videoId = $videoId
            }
        }
    }

    # convert the playlist item object to JSON
    $playlistItemJson = $playlistItem | ConvertTo-Json

    # send a POST request to the playlistItems endpoint with the playlist item JSON
    $response = Invoke-RestMethod -Uri $playlistItemsUrl -Method Post -ContentType "application/json" -Headers @{
        Authorization = "Bearer $accessToken" # replace with your access token
    } -Body $playlistItemJson
}
```

This will loop through the video IDs that you want to add to the playlist and send a POST request to the playlistItems endpoint for each one. You can check the response status code and body to see if the operation was successful or not.

I hope this helps you with your task. If you need more information, you can check out the [YouTube Data API documentation](^1^) or the [PowerShell documentation](^2^). Have a nice day! ??

Källa: Konversation med Bing, 2024-01-15
(1) Download a full YouTube playlist with PowerShell - FoxDeploy.com. https://www.foxdeploy.com/blog/download-a-full-youtube-playlist-with-powershell.html.
(2) How to create a playlist with PowerShell | PDQ. https://www.pdq.com/blog/create-a-hipster-playlist-using-powershell/.
(3) JoJoBond/Powershell-YouTube-Upload - GitHub. https://github.com/JoJoBond/Powershell-YouTube-Upload.
(4) Generate M3U Playlist with PowerShell - KeesTalksTech. https://keestalkstech.com/2014/02/create-mp3-playlist-with-powershell/.
(5) undefined. http://rg3.github.io/youtube-dl/.
(6) undefined. https://www.youtube.com/playlist?list=PL8B03F998924DA45B.
(7) undefined. http://www.youtube.com/playlist?list=PL1058E06599CCF54D&.
(8) undefined. http://www.youtube.com.
(9) undefined. http://www.youtube.com/playlist?list=PL1058E06599CCF54D.
(10) undefined. https://accounts.spotify.com/en/authorize?.
