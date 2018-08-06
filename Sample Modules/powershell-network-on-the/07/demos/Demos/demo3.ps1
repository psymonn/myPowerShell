#demo New-WebServiceproxy
help New-WebServiceProxy
cls

#I have installed a simple web service on a server
$uri = "http://srv2/mywebservices/firstservice.asmx"
$px = New-WebServiceProxy -uri $uri 

$px
#I know this has methods of Add() and SayHello()
$px | Get-Member Add,SayHello

$px.add.OverloadDefinitions
$px.add(123,456)

$px.SayHello()
cls

#this may not always work as the site appears to come and go

$px = New-WebServiceProxy "http://www.webservicex.net/geoipservice.asmx"

$px | Get-Member -MemberType Method

$IPAddress="208.67.220.220"

$px.GetGeoIP($IPAddress)
$px.GetGeoIP($IPAddress) | Select IP,Country*

#test with an array of IP addresses
$ips =  get-content c:\scripts\ips.txt

$ips | foreach { $px.GetGeoIP($_) } | Sort CountryCode | Select IP,Country*

cls