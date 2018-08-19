<#
  .SYNOPSIS
  Downloads the audio files associated with the podcast feed
  
  .DESCRIPTION
  Uses the passed in RSS feed to get the names of the audio files, 
  then checks to see if the file exists in the output folder. 
  If it does exist, it is then checked to see if the length matches 
  the length specified in the feed. If it does not exist, 
  or if the lengths don't match, the audio file is downloaded.
  
  .INPUTS
  rssData - The RSS feed returned by Get-PodcastData
  OutputPathFolder - The target folder where the audio files should exist
  
  .OUTPUTS
  No values are returned. 
  
  .EXAMPLE
  $rssData = Get-PodcastData
  Get-PodcastMedia $rssData

  .EXAMPLE
  $rssData = Get-PodcastData
  $folder = 'C:\Temp'
  Get-PodcastMedia $rssData $folder

  .EXAMPLE
  $rssData = Get-PodcastData
  $folder = 'C:\Temp'
  Get-PodcastMedia -rssData $rssData -OutputPathFolder $folder

  .LINK
  Get-PodcastData 
  
#>
function Get-PodcastMedia()
{    
  [CmdletBinding()]
  param
  (
    [parameter (Mandatory = $true) ]
    $rssData
    ,   
    [parameter (Mandatory = $false) ]
    [string] $OutputPathFolder = 'F:\STUDYING\a PLURALSIGHT Courses\POWERSHELL\powershell-testing-pester\03\demos\Podcast-NoAgenda\OutputPathFolder\Podcast-Data\'
  )

  Write-Verbose 'Get-PodcastMedia: Starting'
  
  foreach($podcast in $rssData)
  {
    $audioURL = $podcast.AudioUrl
    $audioSize = $podcast.AudioLength
    $audioFileName = $audioURL.Split('/')[-1]
    $outFileName = "$($OutputPathFolder)$($audioFileName)"

    $msg = "`r`nGet-PodcastMedia: Downloading $audioFileName, "
    $msg += "$($podcast.AudioLength) bytes "
    $msg += " from $audioURL `r`n"
    Write-Verbose $msg
    Invoke-WebRequest $audioUrl -OutFile $outFileName

  }

}