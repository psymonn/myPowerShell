#requires -version 3.0

#demo XML serialization
#run these commands in the ISE

#region Clixml

Get-Process | Export-Clixml c:\work\procs.xml

psedit c:\work\procs.xml

$p = Import-Clixml c:\work\procs.xml
$p | gm

#imported objects can be used almost like any other
#process object
$p
$p | sort ws -desc | select -first 5

#endregion

#region Convert XML

$xml = get-process | ConvertTo-Xml
$xml | gm
$xml
$xml.Objects
#xml objects are a bit more complicated to work with
$xml.objects.Object

#save the file. Recommend using full path
$xml.Save("c:\work\procs2.xml")

#but this is a different type of xml file
psedit c:\work\procs2.xml

#and it can't be imported using Import-clixml
Import-Clixml C:\work\procs2.xml

#if you want to work with the object in PowerShell
[xml]$myprocs = Get-Content C:\work\procs2.xml

$myprocs

#endregion