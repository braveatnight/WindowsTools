#Created on 2022-12-15
#Author: Faith Heath
#Description: This script will rename all files in the MovieBoxPro default videos folder to 
# the format that Jellyfin prefers

# Rename-Item is set to what if as a safety and testing feature
# Please verify the output before running the script
# remove the -WhatIf to actually rename the files

#Declare initial array and path
$movieBoxProPath = 'C:\Users\fheat\Videos\MovieBoxPro'
$seriesFolders = (Get-ChildItem -Path $movieBoxProPath -Directory).FullName


#For each series folder get the children season folders and store in an array
ForEach-Object -InputObject $seriesFolders -Process {
   $seasonFolders = (Get-ChildItem -Path $_ -Directory).FullName

    #For each season folder get the children episode folders and store in an array
    ForEach-Object -InputObject $seasonFolders -Process {
        $episodeFolders = (Get-ChildItem -Path $_ -Directory).FullName

        #For each episode folder get the file
        foreach ($episodeFolder in $episodeFolders) {
            $episodeFile = Get-ChildItem -Path $episodeFolder -File
            
            #Check if the folder contains an episode
            if ($episodeFile -eq $null) {
                Write-Host "No file found in $episodeFolder"
                continue
            }
            
            #Rename the file to the episode folder name
            #$episodeFile.Name
            #$episodeFile.FullName
            #do the unconditional regex replace to remove trailing and leading text
            $targetEpisode = $episodeFile.Name -replace '(.*) S(\d+) E(\d+) (.*)', 'S$2E$3.mp4'
            #do the conditional regex replace to add leading zeros
            #only happens if the season or episode is a single digit
            if ($targetEpisode -match 'S(\d+)E(\d+)') {
                $season = $matches[1]
                $episode = $matches[2]
                if ($season.Length -lt 2) { $season = "0$season" }
                if ($episode.Length -lt 2) { $episode = "0$episode" }
                $targetEpisode = "S$season" + "E$episode.mp4"
            }
            #Rename the file
            Rename-Item $episodeFile -NewName $targetEpisode -WhatIf
        }
    }
}





