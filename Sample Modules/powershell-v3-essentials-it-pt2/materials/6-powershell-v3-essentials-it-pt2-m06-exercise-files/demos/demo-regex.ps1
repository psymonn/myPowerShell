$p = "\\\\CHI-\w+\d{2}\\\w+"

#regex is case sensitive
[regex]$rx = $p                                                     

$unc = "\\chi-fp01\public"

$unc -match $p

$rx.match($unc)
$rx.match($unc.toUpper())

#or adjust regex
[regex]$rx = "^\\\\[Cc][Hh][Ii]-\w+\d{2}\\\w+$"
$rx.match("\\chi-fp01\public")
$rx.match("\\CHI-fp01\public")
$rx.match("\\cHi-fp01\public")

#use the regex result
$f = read-host "Enter a folder path"

$rx.match($f)
Test-Path $rx.Match($f).Value

#find multiple matches
$line = "172.16.30.8    192.10.1.1 Error  Some event happened"
[regex]$ip="\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

$data = $ip.Matches($line)
$data
$data[0].value

$d = get-content C:\Windows\system32\LogFiles\HTTPERR\httperr1.log
$ip.matches($d) | select Value -Unique

