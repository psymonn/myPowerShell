#requires -version 3.0

#demo New-WebServiceProxy

help New-WebServiceProxy -ShowWindow

$proxy = New-WebServiceProxy "http://www.webservicex.net/geoipservice.asmx"

$proxy

$proxy | Get-Member -MemberType Method

#invoke a proxy method
$IP = '213.139.122.103'
$proxy.GetGeoIP($IP) 
$proxy.GetGeoIP($IP) | Select IP,C*

#the proxy makes it easier to reuse
$IPs = '213.139.122.103','67.215.92.211','69.43.161.168','82.112.104.81','193.60.236.70'
$IPs | Foreach { $proxy.GetGeoIP($_)} | Sort CountryName | Select IP,C*

