#get a breakdown of error sources in the System eventlog

#start with a command that works in the console
$computername = $env:computername
$data = Get-Eventlog System -EntryType Error -Newest 1000 -ComputerName $Computername |
Group -Property Source -NoElement 

#create an HTML report
$title = "System Log Analysis"
$footer = "<h5>report run $(Get-Date)</h5>"
$css = "http://jdhitsolutions.com/sample.css"

$data | Sort -Property Count,Name -Descending |
Select Count,Name | 
ConvertTo-Html -Title $Title -PreContent "<H1>$Computername</H1>" -PostContent $footer -CssUri $css |
Out-File c:\work\systemsources.html

# Invoke-Item c:\work\systemsources.html


