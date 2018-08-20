#requires -version 3.0

#demo Invoke-RestMethod

help Invoke-RestMethod -ShowWindow

#region scraping XML data is easy
$uri = 'http://mcpmag.com/rss-feeds/prof-powershell.aspx'
$uri ='http://localhost:8080/api/xml'
$data = Invoke-RestMethod $uri
$data
$data.GetEnumerator().job
$data.GetEnumerator().job|where {$_.name -eq 'Atmosphere2'}

#$data | Select Title,Description,
$data | Select Name, Url,
@{Name="Published";Expression={$_.PubDate -as [datetime]}},Link |
format-list

#endregion

#region using a web service

#IP address is pulled from an IIS log
$IP = "208.67.220.220"
$uri = "http://www.webservicex.net/geoipservice.asmx/GetGeoIP?IPAddress=$IP"

$data = Invoke-RestMethod -Uri $uri 
$data
$data.GeoIP
$data.GeoIP | Select IP,Country*

$whois = Invoke-RestMethod "http://www.webservicex.net/whois.asmx/GetWhoIS?HostName=globomantics.com"
$whois
$whois.string.InnerText
#or get just the data we want
$whois.string.InnerText.split("`n") | select-string "^\s+"

#endregion
