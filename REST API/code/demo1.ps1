#demo Invoke-Webrequest

help Invoke-WebRequest
cls

#on a new Windows 10 installation make sure you've launched Internet Explorer
#if you want to use the full DOM object
$a = Invoke-WebRequest -uri 'http://icanhazip.com/' -UseBasicParsing
$a
$a.Content
#as a one-liner
(Invoke-WebRequest -uri 'http://icanhazip.com/' -UseBasicParsing).content
cls
#download git
$uri = 'https://git-scm.com/download/win'
#view the page - cancel any download prompt
start $uri
#get the web page with PowerShell
$page = Invoke-WebRequest -Uri $uri -UseBasicParsing -DisableKeepAlive
$page | more
#get the download link
$page.links
$dl = $page.links | where-object outerhtml -match 'git-.*-64-bit.exe' | Select-Object -first 1 * 
$dl | format-list *

#split out the filename
$filename = split-path $dl.href -leaf
$filename
#construct a filepath for the download
$out = Join-Path -Path c:\work -ChildPath $filename

#download the file
Invoke-WebRequest -uri $dl.href -OutFile $out -UseBasicParsing -DisableKeepAlive

dir c:\work\git*
cls

#you may need to do some scripting - especially when using DOM
start https://www.ssa.gov/OACT/babynames/index.html
ise c:\scripts\get-babynames.ps1 
#run in the ISE or from the command line C:\scripts\Get-BabyNames.ps1
cls