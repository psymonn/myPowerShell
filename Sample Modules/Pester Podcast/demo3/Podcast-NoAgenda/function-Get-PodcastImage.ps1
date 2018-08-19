<#
  .SYNOPSIS
  Downloads the image files associated with the podcast feed
  
  .DESCRIPTION
  Uses the passed in RSS feed to get the names of the image files, 
  then checks to see if the file exists in the output folder. 
  If it does not exist, the audio file is downloaded.
  
  .INPUTS
  rssData - The RSS feed returned by Get-PodcastData
  OutputPathFolder - The target folder where the audio files should exist
  
  .OUTPUTS
  No values are returned. 
  
  .EXAMPLE
  $rssData = Get-PodcastData
  Get-PodcastImage $rssData

  .EXAMPLE
  $rssData = Get-PodcastData
  $folder = 'C:\Temp'
  Get-PodcastImage $rssData $folder

  .EXAMPLE
  $rssData = Get-PodcastData
  $folder = 'C:\Temp'
  Get-PodcastImage -rssData $rssData -OutputPathFolder $folder

  .LINK
  Get-PodcastData 
  
#>
function Get-PodcastImage()
{    
  [CmdletBinding()]
  param
  (
    [parameter (Mandatory = $false) ]
    $rssData
    ,   
    [parameter (Mandatory = $false) ]
    [string] $OutputPathFolder = 'F:\STUDYING\a PLURALSIGHT Courses\POWERSHELL\powershell-testing-pester\03\demos\Podcast-NoAgenda\OutputPathFolder\Podcast-Data\'
  )

  Write-Verbose 'Get-PodcastImage: Starting'

  $downloadedImages = @()

  foreach($podcast in $rssData)
  {
    # Example ImageUrl: http://adam.curry.com/enc/20160407195815_na-814-art-sm.jpg
    $imgFileName = $podcast.ImageUrl.Split('/')[-1]
    $outFileName = "$($OutputPathFolder)$($imgFileName)"

    Write-Verbose "`r`nGet-PodcastImage: Downloading $imgFileName from $($podcast.ImageUrl) `r`n"
    Invoke-WebRequest $podcast.ImageUrl -OutFile $outFileName
    $downloadedImages += $imgFileName

  }

  return $downloadedImages

}