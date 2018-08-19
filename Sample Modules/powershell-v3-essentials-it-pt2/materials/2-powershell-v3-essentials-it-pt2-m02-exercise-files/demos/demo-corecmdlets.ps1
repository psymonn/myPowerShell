#requires -version 3.0

#demo Core cmdlets

#region Get-Childitem

help dir -showwindow

dir \\chi-fp01\it
dir \\chi-fp01\it -recurse

#filtering techniques
$a = { dir \\chi-fp01\it\*.ps1 -recurse}
&$a
$b = {dir \\chi-fp01\it -include *.ps1 -recurse}
&$b
$c = {dir \\chi-fp01\it -filter *.ps1 -recurse}
&$c

measure-command $a
measure-command $b
measure-command $c

#but it depends on provider
get-psprovider
Push-Location
cd function:

#notice help changed
help dir -ShowWindow

#this works
dir m*

#fails
dir -filter m* -Recurse
#this also fails
dir -include m*
#but this works
dir -include m* -Recurse

#same principal applies when listing items in the registry
Pop-Location

#getting items by attribute
dir \\chi-fp01\it -Directory
dir \\chi-fp01\it\TechEd -file

dir c:\ -Hidden
dir c:\ -Hidden -File

#works with other providers
Import-Module ActiveDirectory
pushd
cd ad:
dir
#sometimes it isn't apparent
dir globomantics
#in this case you need distinguishedname or use tab completion
dir '.\OU=Employees,DC=GLOBOMANTICS,DC=local' -recurse

Get-PSProvider ActiveDirectory
cd  '.\OU=Employees,DC=GLOBOMANTICS,DC=local'
dir

#filter needs to be an LDAP Filter
dir -recurse -filter "(&(objectclass=user)(givenname=jack))"
dir -recurse -filter "(&(objectclass=user)(givenname=j*))"

popd

#endregion

#region Where-Object

#legacy syntax
get-service | where {$_.status -eq 'Stopped'}

#new syntax
get-service | where status -eq 'Stopped'

dir \\chi-fp01\Executive -file | where Length -ge 100kb

dir \\chi-fp01\Executive\*.docx | 
where LastWritetime -gt (Get-Date).AddDays(-90)

#but something more complex will fail
dir \\chi-fp01\Executive\*.docx | 
where LastWritetime -gt (Get-Date).AddDays(-90) -AND Length -gt 15KB

#need to use older syntax
dir \\chi-fp01\Executive\*.docx | 
where { ($_.LastWritetime -gt (Get-Date).AddDays(-90)) -AND ($_.length -gt 15KB)}

#always filter early when possible
#both commands will work but one is 'better' than the other
Measure-Command {
 dir \\chi-fp01\it -recurse | where {$_.extension -eq '.xml'}
}

Measure-Command {
 dir \\chi-fp01\it -recurse -filter '*.xml'
}

#use filtering for those things you can't otherwise filter
dir \\chi-fp01\it -recurse -filter '*.xml' |
where {$_.LastWriteTime.Year -eq '2013'}

#endregion

#region Sort-Object

get-process -computername chi-dc01 | Sort WS
get-process -ComputerName chi-dc01 | Sort WS -Descending

#starttime property only available locally
#skip processes without a starttime property
notepad
get-process | where starttime | 
sort @{Expression={(Get-Date) - $_.starttime}}

#endregion

#region Select-Object

#objects
get-process -ComputerName chi-dc01 | 
Sort WS -Descending | Select -First 5

get-process -ComputerName chi-dc01 | 
Sort WS -Descending | Select -last 5

#properties
dir \\chi-fp01\public -file | Select Name,Length,LastWriteTime

#create customproperties
$data = dir \\chi-fp01\public -file | 
Select Name,@{Name="Size";Expression={$_.Length}},
LastWriteTime,@{Name="Age";Expression={
((Get-Date) - $_.lastWriteTime).Days}} |
Sort Size -Descending 

#selecting is not the same as formatting
$data
$data | ft -Auto

#unique
get-process -ComputerName chi-dc01 | Select Name -unique
get-process -ComputerName chi-dc01 | Select Name -unique | sort name

#or select unique objects
1,4,5,1,6,6,7,8 | select -Unique
Get-Process -ComputerName chi-dc01 | select -Unique

#expand properties
#this is hard to read because the property is a collection of objects
get-service winmgmt -computername chi-dc03 | Select DependentServices
#so expand it
get-service winmgmt -computername chi-dc03 | 
Select -expandproperty DependentServices

#endregion

#region Group-Object

$logs = Get-eventlog system -newest 100 -ComputerName CHI-FP01 | Group Source
$logs

#this is a different object
$logs | sort Count -Descending
$logs | gm

#get grouped objects
$logs[0].group
$logs[0].group | Select EntryType,Message

#create without the elements
Get-eventlog system -newest 100 -ComputerName CHI-FP01 |
Group EntryType -NoElement | Sort Count

#or create a hashtable
$groupHash = Get-eventlog system -newest 100 -ComputerName CHI-FP01 |
Group EntryType -AsHashTable -AsString

#forced PowerShell to treat EntryType as a string, because
#it is technically [system.diagnostics.eventlogentrytype]

$groupHash
$grouphash.error


#endregion

#region Measure-Object

get-process | measure

get-process  | measure workingset -sum -Minimum -Maximum -Average

dir \\chi-fp01\it -Directory | 
Select FullName,LastWriteTime,@{Name="Size";Expression={ 
 $stats = dir $_.Fullname -recurse | Measure-Object Length -sum
 $stats.sum
}} | fl

#endregion

#region Get-Content

get-content C:\work\computers.txt

#get the head (alias parameter)
get-content C:\windows\WindowsUpdate.log -head 5

#get the tail of a file
get-content C:\windows\WindowsUpdate.log -Tail 5

#get tail and watch
get-content C:\work\computers.txt -Tail 1 -Wait

#endregion

#region Putting it all together

#using aliases for this one line command


$data = get-wmiobject win32_OperatingSystem -ComputerName (cat c:\work\computers.txt | where {$_}) | 
Select Caption,@{Name="Computername";Expression={$_.CSName}},
@{Name="FreePhysMemBytes";Expression={$_.FreePhysicalMemory*1kb}},
@{Name="TotalPhysMemBytes";Expression={$_.TotalVisibleMemorySize*1kb}},
@{Name="PercentFreeMem";Expression={
($_.FreePhysicalMemory/$_.TotalVisibleMemorySize)*100}},
NumberofUsers,NumberofProcesses |
Group Computername -AsHashTable -AsString

$data

#need to handle the dash
$data.'chi-dc03'

#analyze the data
$data.GetEnumerator() | select -expand Value | 
Where {$_.percentFreeMem -le 25} |
sort PercentFreeMem -Desc | 
select Comp*,P*,Num*

#I used abbreviations and shortcuts to simulate how you would type it
#interactively. In a script don't use the shortcuts.

#endregion


