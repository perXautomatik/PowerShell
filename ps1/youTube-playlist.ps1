# Define your API key and playlist ID
$apiKey = 'YOUR_API_KEY'
$playlistId = 'YOUR_PLAYLIST_ID'

# Define the base URL for the YouTube Data API
$apiUrl = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=25&playlistId=$playlistId&key=$apiKey"

# Fetch the playlist items
$response = Invoke-RestMethod -Uri $apiUrl

# Extract the video details
foreach ($item in $response.items) {
    $videoTitle = $item.snippet.title
    $videoChannel = $item.snippet.channelTitle
    $videoDuration = $item.contentDetails.duration # You may need to make an additional API call to get the duration
    $videoUrl = "https://www.youtube.com/watch?v=" + $item.snippet.resourceId.videoId

    # Output the video details
    Write-Host "Title: $videoTitle"
    Write-Host "Channel: $videoChannel"
    Write-Host "Duration: $videoDuration"
    Write-Host "URL: $videoUrl"
    Write-Host "-----------------------------"
}
