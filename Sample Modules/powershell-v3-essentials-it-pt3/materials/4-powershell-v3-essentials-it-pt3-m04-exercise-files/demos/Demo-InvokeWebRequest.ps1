#requires -version 3.0

#demo Invoke-WebRequest

<#

IMPORTANT:if you run this in the ISE you might experience a memory leak
When you are finished, exit the ISE and then look for any remaining
PowerShell_ISE processes and kill them.

#>

help Invoke-WebRequest -ShowWindow

#region test if a web server is running

$r = invoke-webrequest https://chi-web01/pswa
$r
$r.StatusCode
$r.Headers

#endregion

#region scrape a web site
$base = "http://trainsignal.com"
$uri = "$base/Browse"
$r = invoke-webrequest $uri
$r
#look at links
$r.links[0..5]
$r.links | select OuterText,href

#let's get just courses
$r.links | where {$_.href -match "^/Course"} | 
Select @{Name="Title";Expression={$_.OuterText.Split("`n")[0].Trim()}},
@{Name="Instructor";Expression={$_.OuterText.Split("`n")[1].Trim()}},
@{Name="Date";Expression={$_.OuterText.Split("`n")[2].Trim() -as [datetime]}},
@{Name="Link";Expression={"$base$($_.href)"}} | 
Out-GridView -Title "Trainsignal Courses" -PassThru |
Foreach { 
#open selected links in the browser
start $_.link
}

#sometimes the data is XML
[xml]$rss = invoke-webrequest 'http://mcpmag.com/rss-feeds/prof-powershell.aspx'
$rss
$rss.rss
$rss.rss.channel
#get items
$rss.rss.channel.ChildNodes | Where Title | 
Select Title,Description,Link,PubDate |
Out-GridView -Title "Prof. PowerShell" -PassThru |
foreach { start $_.link}

#endregion

#region Using parsedhtml

$petri = Invoke-webrequest 'http://www.petri.co.il/'
$petri.parsedhtml
$d = $petri.ParsedHtml.getElementById("deploy") 
$d.getElementsByTagName("A") | 
where {$_.href -match "^http"} | 
select InnerText,href

#endregion