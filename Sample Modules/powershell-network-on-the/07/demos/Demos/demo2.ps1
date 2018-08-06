#demo Invoke-RestMethod

help Invoke-RestMethod
cls

#use the GitHub API https://developer.github.com/v3/
$r = invoke-restmethod https://api.github.com/users/jdhitsolutions/repos?per_page=50
$r.count
$r[0] |more
#filter out repos I have forked
$r | where { -not $_.fork} | 
Select Name,Description,Updated_at,html_url,*count | 
Out-GridView -title "Jeff's GitHub"
cls

#see https://www.arin.net/resources/whoisrws/whois_api.html
start https://www.arin.net/resources/whoisrws/whois_api.html
$baseURL = 'http://whois.arin.net/rest'
$uri = "$baseurl/ip/52.27.12.198"
#default is XML
$who = Invoke-Restmethod $uri 
$who
$who.net

#can also use json
#some services are better than others
$s = Invoke-RestMethod $uri -Headers @{"Accept"="application/json"}
$s
$s.net

#or simple text!
Invoke-RestMethod $uri -Headers @{"Accept"="text/plain"}

cls
#use with XML data like rss feeds
$uri = 'http://feeds.feedburner.com/brainyquote/QUOTEBR'
$data = Invoke-RestMethod -Uri $uri
$data

#The first quote will be the most recent
$data[0]
$quote = "{0} - {1}" -f $data[0].description,$data[0].title
Write-host $quote -ForegroundColor yellow

cls

#here's a function that uses Invoke-RestMethod
ise c:\scripts\Get-RSSv4.ps1
. C:\scripts\Get-RSSv4.ps1
get-rssfeed | sort Published

cls