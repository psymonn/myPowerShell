#requires -version 3.0
[psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get

#demo object members in action

#region Get-Member

get-service
get-service | get-member

#see just properties
get-service | get-member -MemberType Properties

#once you know the properties you can use them
get-service | Select Name,Status,ServiceType 

#endregion

#region creating custom properties

#select-object
#start some new processes
notepad;calc

#start time only works locally
get-process | where starttime | 
Select ID,Name,Starttime,
@{Name="RunTime";Expression={(Get-Date) - $_.StartTime}} |
Sort RunTime

#format-table
$computers = "chi-dc01","chi-fp01","chi-dc03"
Get-CimInstance win32_logicaldisk -filter "drivetype=3" -comp $computers |
Format-Table -GroupBy PSComputername -Property DeviceID,VolumeName,
@{N="SizeGB";E={[math]::Round($_.Size/1GB)}},
@{N="FreeGB";E={[math]::Round($_.Freespace/1GB,2)}},
@{N="PerFree";E={[math]::Round(($_.freespace/$_.size)*100,2)}}


#endregion

#region Add-Member

#passthru a single change
dir c:\work -file -Recurse | 
Add-Member Aliasproperty Size -value length -PassThru | 
Sort Size -descending | select Fullname,size -first 10

#a practical example
$files = dir \\chi-fp01\public -file

$files | Add-Member -MemberType AliasProperty -Name Size -Value Length
$files | Add-Member ScriptProperty -Name FileAge -Value {(Get-Date) - ($this.LastWriteTime)}
$files | Add-Member ScriptProperty -Name FileAgeDays -Value {[int]((Get-Date) - ($this.LastWriteTime)).TotalDays}

#display the customized file object
$files | sort Size -Descending | 
Select FullName,Size,CreationTime,LastWriteTime,FileAge* |
Out-GridView -Title "Public Files"

#endregion
