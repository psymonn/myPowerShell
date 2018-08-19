#requires -version 3.0

#demo PowerShell Formatting

#region Format-Wide

get-process | format-wide
get-process | format-wide -column 4
get-process | format-wide -AutoSize

#sort on property before grouping
gsv | Sort Status | fw -GroupBy status

gsv | Sort Status,displayname | 
fw -GroupBy status -Property Displayname

#endregion

#region Format-Table

#this is fine if you think you want to do something else with
#the output
get-process -comp chi-dc03 | sort VM -Descending |
Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10

#or create a table
get-process -comp chi-dc03 | sort VM -Descending |
Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10 |
Format-Table

#it was already a table so let's autosize
get-process -comp chi-dc03 | sort VM -Descending |
Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10 |
Format-Table -autosize

#or if you know you want a formatted table to begin with
get-process -comp chi-dc03 | sort VM -Descending | Select -first 10 | 
Format-Table -property ID,Name,VM,
@{N="Computername";E={$_.Machinename}} -AutoSize

#grouping by property
get-eventlog System -comp chi-dc01 -newest 50 |
Format-Table -GroupBy EntryType -Property TimeGenerated,Source,Message -Wrap

#should sort first
get-eventlog System -comp chi-dc01 -newest 50 | Sort EntryType |
Format-Table -GroupBy EntryType -Property TimeGenerated,Source,Message -Wrap

#formatting has to be last

#this will fail
$computers = 'chi-dc01','chi-dc03','chi-fp01','chi-win8-01'

Get-CimInstance win32_operatingsystem -comp $computers |
Format-Table @{n="OS";e={
#trim off Microsoft Windows from the caption
[regex]$rx="Microsoft|Windows|\(R\)"
$rx.Replace($_.caption,"").Trim()}
},InstallDate,
@{n="Computername";e={$_.CSName}},
@{n="SP";e={$_.ServicePackmajorversion}} -auto |
Sort InstallDate

#see why?
gcim win32_operatingsystem | 
ft Caption,CSName,InstallDate | gm

#process data before formatting
Get-CimInstance win32_operatingsystem -comp $computers |
Sort InstallDate | 
Format-Table @{n="OS";e={
#trim off Microsoft Windows from the caption
[regex]$rx="Microsoft|Windows|\(R\)"
$rx.Replace($_.caption,"").Trim()}
},InstallDate,
@{n="Computername";e={$_.CSName}},
@{n="SP";e={$_.ServicePackmajorversion}} -auto 

#except to send to Out-File
Get-CimInstance win32_operatingsystem -comp $computers |
Sort InstallDate | 
Format-Table @{n="OS";e={
#trim off Microsoft Windows from the caption
[regex]$rx="Microsoft|Windows|\(R\)"
$rx.Replace($_.caption,"").Trim()}
},InstallDate,
@{n="Computername";e={$_.CSName}},
@{n="SP";e={$_.ServicePackmajorversion}} -auto |
Out-File \\chi-fp01\it\OSReport.txt -Encoding ascii

notepad \\chi-fp01\it\OSReport.txt

#endregion

#region Format-List

#great way to discover object properties
get-process system | format-list *

#some cmdlets might have a different view
get-process | ft
get-process | fl
dir c:\work
dir c:\work | fl

#grouping
dir \\chi-fp01\public | sort Extension |
fl -GroupBy Extension

#or select properties
dir \\chi-fp01\public | sort Extension |
fl -GroupBy Extension -prop Fullname,Length,CreationTime,LastWriteTime


#endregion
