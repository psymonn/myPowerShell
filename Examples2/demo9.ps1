
help get-service -Parameter computername
get-service -ComputerName srv1
get-service -name bits -computername srv1,srv2,dom1 |
select Name,Status,Machinename

get-service -name bits -computername srv1,srv2,dom1 |
restart-service -Force -PassThru | 
select machinename,status,displayname

cls
#need admin rights, no ability to authenticate
#SRV3 is in a workgroup - we will need PowerShell remoting which is coming up
get-service -ComputerName srv3

cls
help get-process -parameter computername
get-process lsass -ComputerName dom1
#this may not scale well for hundreds of servers
get-process lsass -ComputerName dom1,srv1,srv2 | 
select machinename,id,name,handles,VM,WS |
sort handles,machinename -Descending |
format-table
cls

help get-eventlog -Parameter computername
get-eventlog -list -ComputerName dom1

get-eventlog -list -ComputerName dom1,srv1,srv2,win10 | 
Where log -eq 'system' |
format-table -GroupBy Log -Property @{Name="Computername";Expression={$_.MachineName}},
OverFlowAction,
@{Name="MaxKB";Expression={$_.MaximumKilobytes}},
@{Name="Retain";Expression={$_.MinimumRetentionDays}},
@{Name="RecordCount";Expression={$_.entries.count}} 

#filter out empty logs
get-eventlog -list -computername dom1,srv1,srv2 | 
where {$_.Entries.count -gt 0 } | Sort Machinename,Log |
format-table -groupby @{Name="Computername";Expression = {$_.Machinename.toUpper()}}
cls

#find all commands with -computername
Get-command -CommandType Cmdlet -ParameterName Computername

cls

