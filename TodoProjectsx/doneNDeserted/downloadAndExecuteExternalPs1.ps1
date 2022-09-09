$downloadString = 'https://raw.githubusercontent.com/DanysysTeam/PS-SFTA/master/SFTA.ps1'
iex ((New-Object System.Net.WebClient).DownloadString($downloadString))