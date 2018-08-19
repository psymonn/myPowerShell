#requires -version 3.0

#demo CSV serialization.
#these commands are designed for the ISE

#region Export-CSV

#region be careful what you export
get-service m* -ComputerName $env:computername | 
Export-Csv -Path c:\work\msvc.csv

psedit C:\work\msvc.csv
#endregion

#region select the properties you want
get-service m* -ComputerName $env:computername | 
Select Name,Displayname,Status,Machinename |
Export-Csv -Path c:\work\msvc.csv

psedit C:\work\msvc.csv
#endregion

#region no type information
get-service | Select name,displayname,status |
Export-csv c:\work\svc.csv -NoTypeInformation -Delimiter ";"

psedit C:\work\svc.csv
#endregion

#region appending
#keep properties the same.

#run at least 3 times with a little time between each sample
get-process svchost | 
Add-Member -membertype Noteproperty -name SampleTime -Value (get-date) -PassThru |
Select * -ExcludeProperty Modules,Threads | 
Export-Csv c:\work\svchost.csv -Append

#we'll use this later
#endregion

#endregion

#region Import-CSV

#region default delimiter is comma
$impSvc = Import-Csv C:\work\msvc.csv
$impSvc
$impSvc | gm
#endregion

#region works with any CSV
$s = import-csv C:\work\svc.csv -Delimiter ";"
$s
$s | gm

psedit .\newusers.csv

#import and filter out blank lines
$n = import-csv \\serenity\trainsignal\lesson_14\newusers.csv | where {$_.OU}
$n

#these objects could then be piped to AD cmdlets

#importing our appended csv file
#I've added code to change some properties back into different
#object type instead of string
import-csv c:\work\svchost.csv | sort id,@{expression={[datetime]$_.sampletime}} | 
ft -group id -Property @{N="Sample";Expression={([datetime]$_.SampleTime).ToLongTimeString()}},WS,VM,PM,CPU

#endregion

#endregion

#region Convert CSV

help convertto-csv -online

$a = get-service | select name,displayname,status | Convertto-CSV 
$a[0..4]
#not sure what this really gives us
$b = $a | convertFrom-csv

#endregion

