$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Get-Module Podcast-NoAgenda | Remove-Module -Force
Import-Module $here\Podcast-NoAgenda.psm1 -Force

InModuleScope Podcast-NoAgenda { 
  
  Describe 'Get-PodcastMedia Unit Tests' -Tags 'Unit' {
  
    # See the notes in function-GetPodcastImage.Tests for how the mock data works  
    # Also note, due to the size of the podcast files for unit testing the mocked data
    # has been reduced to just two podcasts in order to save download bandwidth and time
    $mockRssData = @'
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>PodcastSight.Podcast</T>
      <T>System.Management.Automation.PSCustomObject</T>
      <T>System.Object</T>
    </TN>
    <MS>
      <S N="Title">814: Produce &amp; Pipelines</S>
      <S N="ShowUrl">http://814.noagendanotes.com</S>
      <S N="EmbeddedHTML">&lt;p&gt;Show Notes&lt;/p&gt;&lt;p&gt;_x000A_No Agenda Episode 814 - "Produce &amp; Pipelines"&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Produce &amp; Pipelines&lt;/b&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;audio src="http://mp3s.nashownotes.com/NA-814-2016-04-07-final.mp3" controls&gt;&lt;/audio&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://mp3s.nashownotes.com/NA-814-2016-04-07-final.mp3"&gt;&lt;img src="http://adam.curry.com/enc/20160407193233_na-814-art-sm.jpg" alt="A picture named NA-814-Art-SM" align="right" border="0" vspace="5" width="256" height="256" hspace="15"&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Direct [&lt;a href="http://mp3s.nashownotes.com/NA-814-2016-04-07-final.mp3"&gt;link&lt;/a&gt;] to the mp3 file&lt;/p&gt;&lt;p&gt;_x000A_ShowNotes Archive of links and Assets (clips etc) &lt;a href="http://814.noagendanotes.com/"&gt; 814.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Sign Up&lt;/b&gt; for the &lt;a href="http://www.dvorak.org/blog/no-agenda-mailing-list-signup-here/"&gt;newsletter&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_New: Directory Archive of Shownotes (includes all audio and video assets used) &lt;a href="http://archive.noagendanotes.com"&gt;archive.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_The No Agenda News Network- &lt;a href="http://noagendanewsnetwork.com/"&gt;noagendanewsnetwork.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_RSS Podcast&lt;a href="http://feed.nashownotes.com/rss.xml"&gt; Feed&lt;/a&gt; &lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://nanewsapp.com/"&gt;No Agenda News App&lt;/a&gt; for your iPhone and iPad&lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://www.noagendroid.com/"&gt;NoAgendDroid app&lt;/a&gt; for your Android Phone&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://bitlove.org/adamc1999/noagenda"&gt;Torrents&lt;/a&gt; of each episode via BitLove&lt;/p&gt;&lt;p&gt;_x000A_IPFS Hash for the mp3: QmXYDEQwC6gikA9enYxkQ21HtUua2bs1ziE2chW5g7pm4i &lt;/p&gt;&lt;p&gt;_x000A_BitTorrentSync Secret: BBE35UBVKPKSUWGDLUZN5DIPFIB3TTQ5I&lt;/p&gt;&lt;p&gt;_x000A_&lt;font size= -1&gt;&lt;script&gt;document.write("Last Modified " + document.lastModified)&lt;/script&gt;&lt;/font&gt;&lt;br&gt;&lt;a href="http://freedomcontroller.com"&gt;&lt;font size= -2&gt;This page created with the FreedomController&lt;/font&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Credits&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Produce &amp; Pipelines&lt;/b&gt;&lt;/p&gt;&lt;p&gt;_x000A_Executive Producers: Thor Odelsting, Sir Henry P. Biglin, Jing Yu, Sir Smilesalot Ryan Merritt, Craig Lucca, Daniel J Franco&lt;/p&gt;&lt;p&gt;_x000A_Associate Executive Producers: Sir Sander Hoksbergen Baron of the Alps, JQ, Ron Nooren, Sean Regalado&lt;/p&gt;&lt;p&gt;_x000A_Become a member of the 814 Club, support the show &lt;a href="http://dvorak.org/na"&gt;here&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Sign Up&lt;/b&gt; for the &lt;a href="http://www.dvorak.org/blog/no-agenda-mailing-list-signup-here/"&gt;newsletter&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Knights &amp; Dames: Paul Webb -&gt; Sir Paul of Twickenham&lt;/p&gt;&lt;p&gt;_x000A_Art By: &lt;a href="http://noagendaartgenerator.com/artist/4"&gt;Patrick Buijs&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_ShowNotes Archive of links and Assets (clips etc) &lt;a href="http://814.noagendanotes.com/"&gt; 814.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_New: Directory Archive of Shownotes (includes all audio and video assets used) &lt;a href="http://archive.noagendanotes.com/"&gt;archive.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_The No Agenda News Network- &lt;a href="http://noagendanewsnetwork.com/"&gt;noagendanewsnetwork.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_RSS Podcast&lt;a href="http://feed.nashownotes.com/rss.xml"&gt; Feed&lt;/a&gt; &lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://nanewsapp.com/"&gt;No Agenda News App&lt;/a&gt; for your iPhone and iPad&lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://www.noagendroid.com/"&gt;NoAgendDroid app&lt;/a&gt; for your Android Phone&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://bitlove.org/adamc1999/noagenda"&gt;Torrents&lt;/a&gt; of each episode via BitLove&lt;/p&gt;&lt;p&gt;_x000A_IPSH: QmXYDEQwC6gikA9enYxkQ21HtUua2bs1ziE2chW5g7pm4i &lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;New!&lt;/b&gt; &lt;a href="http://inthemorningzen.wordpress.com/2013/08/02/bittorrent-sync-the-no-agenda-show/"&gt;BitTorrent Sync&lt;/a&gt; the No Agenda Show&lt;/p&gt;&lt;p&gt;_x000A_&lt;font size= -1&gt;&lt;script&gt;document.write("Last Modified " + document.lastModified)&lt;/script&gt;&lt;/font&gt;&lt;br&gt;&lt;a href="http://freedomcontroller.com"&gt;&lt;font size= -2&gt;This page created with the FreedomController&lt;/font&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Keywords&lt;/p&gt;</S>
      <S N="Hosts">Adam Curry and John C. Dvorak</S>
      <S N="PublicationDate">Thu, 07 Apr 2016 19:59:48 GMT</S>
      <S N="ImageUrl">http://adam.curry.com/enc/20160407195815_na-814-art-sm.jpg</S>
      <S N="AudioUrl">http://mp3s.nashownotes.com/NA-814-2016-04-07-final.mp3</S>
      <S N="AudioLength">123349429</S>
    </MS>
  </Obj>
  <Obj RefId="1">
    <TNRef RefId="0" />
    <MS>
      <S N="Title">813: Clinton Condign</S>
      <S N="ShowUrl">http://813.noagendanotes.com/</S>
      <S N="EmbeddedHTML">&lt;p&gt;Show Notes&lt;/p&gt;&lt;p&gt;_x000A_No Agenda Episode 813 - "Clinton Condign"&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Clinton Condign&lt;/b&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;audio src="http://mp3s.nashownotes.com/NA-813-2016-04-03-Final.mp3" controls&gt;&lt;/audio&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://mp3s.nashownotes.com/NA-813-2016-04-03-Final.mp3"&gt;&lt;img src="http://adam.curry.com/enc/20160403181111_na-813-art-sm.jpg" alt="A picture named NA-813-Art-SM" align="right" border="0" vspace="5" width="256" height="256" hspace="15"&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Direct [&lt;a href="http://mp3s.nashownotes.com/NA-813-2016-04-03-Final.mp3"&gt;link&lt;/a&gt;] to the mp3 file&lt;/p&gt;&lt;p&gt;_x000A_ShowNotes Archive of links and Assets (clips etc) &lt;a href="http://813.noagendanotes.com/"&gt; 813.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Sign Up&lt;/b&gt; for the &lt;a href="http://www.dvorak.org/blog/no-agenda-mailing-list-signup-here/"&gt;newsletter&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_New: Directory Archive of Shownotes (includes all audio and video assets used) &lt;a href="http://archive.noagendanotes.com"&gt;archive.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_The No Agenda News Network- &lt;a href="http://noagendanewsnetwork.com/"&gt;noagendanewsnetwork.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_RSS Podcast&lt;a href="http://feed.nashownotes.com/rss.xml"&gt; Feed&lt;/a&gt; &lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://nanewsapp.com/"&gt;No Agenda News App&lt;/a&gt; for your iPhone and iPad&lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://www.noagendroid.com/"&gt;NoAgendDroid app&lt;/a&gt; for your Android Phone&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://bitlove.org/adamc1999/noagenda"&gt;Torrents&lt;/a&gt; of each episode via BitLove&lt;/p&gt;&lt;p&gt;_x000A_IPFS Hash for the mp3: QmYTHCRUrbmaqC1v7buGT25W8Mn2UFvmvsFugaHeRctCMA &lt;/p&gt;&lt;p&gt;_x000A_BitTorrentSync Secret: BBE35UBVKPKSUWGDLUZN5DIPFIB3TTQ5I&lt;/p&gt;&lt;p&gt;_x000A_&lt;font size= -1&gt;&lt;script&gt;document.write("Last Modified " + document.lastModified)&lt;/script&gt;&lt;/font&gt;&lt;br&gt;&lt;a href="http://freedomcontroller.com"&gt;&lt;font size= -2&gt;This page created with the FreedomController&lt;/font&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Credits&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Clinton Condign&lt;/b&gt;&lt;/p&gt;&lt;p&gt;_x000A_Executive Producer: Dam Astrid Duchess of Tokyo&lt;/p&gt;&lt;p&gt;_x000A_Become a member of the 814 Club, support the show &lt;a href="http://dvorak.org/na"&gt;here&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;Sign Up&lt;/b&gt; for the &lt;a href="http://www.dvorak.org/blog/no-agenda-mailing-list-signup-here/"&gt;newsletter&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Knights &amp; Dames: Lu the Shoe -&gt; Sir Lu The Shoe&lt;/p&gt;&lt;p&gt;_x000A_Art By: &lt;a href="http://noagendaartgenerator.com/artist/668"&gt;Sir_Sluf&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_ShowNotes Archive of links and Assets (clips etc) &lt;a href="http://813.noagendanotes.com/"&gt; 813.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_New: Directory Archive of Shownotes (includes all audio and video assets used) &lt;a href="http://archive.noagendanotes.com/"&gt;archive.noagendanotes.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_The No Agenda News Network- &lt;a href="http://noagendanewsnetwork.com/"&gt;noagendanewsnetwork.com&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_RSS Podcast&lt;a href="http://feed.nashownotes.com/rss.xml"&gt; Feed&lt;/a&gt; &lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://nanewsapp.com/"&gt;No Agenda News App&lt;/a&gt; for your iPhone and iPad&lt;/p&gt;&lt;p&gt;_x000A_Get the &lt;a href="http://www.noagendroid.com/"&gt;NoAgendDroid app&lt;/a&gt; for your Android Phone&lt;/p&gt;&lt;p&gt;_x000A_&lt;a href="http://bitlove.org/adamc1999/noagenda"&gt;Torrents&lt;/a&gt; of each episode via BitLove&lt;/p&gt;&lt;p&gt;_x000A_IPSH: QmYTHCRUrbmaqC1v7buGT25W8Mn2UFvmvsFugaHeRctCMA &lt;/p&gt;&lt;p&gt;_x000A_&lt;b&gt;New!&lt;/b&gt; &lt;a href="http://inthemorningzen.wordpress.com/2013/08/02/bittorrent-sync-the-no-agenda-show/"&gt;BitTorrent Sync&lt;/a&gt; the No Agenda Show&lt;/p&gt;&lt;p&gt;_x000A_&lt;font size= -1&gt;&lt;script&gt;document.write("Last Modified " + document.lastModified)&lt;/script&gt;&lt;/font&gt;&lt;br&gt;&lt;a href="http://freedomcontroller.com"&gt;&lt;font size= -2&gt;This page created with the FreedomController&lt;/font&gt;&lt;/a&gt;&lt;/p&gt;&lt;p&gt;_x000A_Keywords&lt;/p&gt;</S>
      <S N="Hosts">Adam Curry and John C. Dvorak</S>
      <S N="PublicationDate">Sun, 03 Apr 2016 18:31:43 GMT</S>
      <S N="ImageUrl">http://adam.curry.com/enc/20160403183034_na-813-art-sm.jpg</S>
      <S N="AudioUrl">http://mp3s.nashownotes.com/NA-813-2016-04-03-Final.mp3</S>
      <S N="AudioLength">112311070</S>
    </MS>
  </Obj>
</Objs>
'@
  
    $rssData = [System.Management.Automation.PSSerializer]::DeserializeAsList($mockRssData)

    Get-PodcastMedia -rssData $rssData -OutputPathFolder $TestData -Verbose
    foreach ($podcast in $rssData)
    {
      $audioFileName = $podcast.AudioUrl.Split('/')[-1]
      $outFileName = "$($TestData)$($audioFileName)"

      It "should have downloaded podcast $audioFileName " {
        $outFileName | Should Exist
      }

      It "$audioFileName should have a length of $($podcast.AudioLength)" {
        $mp3File = Get-ChildItem $outFileName
        $mp3File.Length.ToString() | Should Match $podcast.AudioLength
      }
    }


  } # Describe 'Get-PodcastMedia Unit Tests' 

} # InModuleScope Podcast-NoAgenda



Describe 'Get-PodcastMedia Acceptance Tests' -Tags 'Acceptance' {

  InModuleScope Podcast-NoAgenda { 

    # For acceptance we call the real function
    $rssData = Get-PodcastData

    # Unfortunately, to be able to test the default OutputPathFolder from the
    # function, we have to hard code it here    
    $defaultOutputPathFolder = 'C:\PS\Pester-course\demo\completed-final-module\Podcast-Data\'

    $downloadedMedia = Get-PodcastMedia -rssData $rssData 
    # Since unit test tested passing in a value to the OutputPathFolder parameter,
    # only going to test using the default parameter since it takes so long to download.
    # Hugs and kisses, Hortense
                                        
    foreach ($podcast in $rssData)
    {
      $audioFileName = $podcast.AudioUrl.Split('/')[-1]
      $outFileName = "$($defaultOutputPathFolder)$($audioFileName)"

      It "should have downloaded podcast $audioFileName " {
        $outFileName | Should Exist
      }

      It "$audioFileName should have a length of $($podcast.AudioLength)" {
        $mp3File = Get-ChildItem $outFileName
        $mp3File.Length.ToString() | Should Match $podcast.AudioLength
      }
    }

  } # InModuleScope Podcast-NoAgenda

} # Describe 'Get-PodcastMedia Acceptance Tests' 
