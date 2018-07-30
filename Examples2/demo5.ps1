#region  jobs

help Get-CimInstance -Parameter asjob

#option 1 use start job
#Get-Ciminstance runs locally and queries computers
Start-job { Get-Ciminstance win32_service -filter "startmode='auto' AND state<>'running'" -computername srv1,srv2,dom1 } -Name SvcCheck

wait-job svccheck

receive-job svccheck -Keep
#format the results and display remote computername using the SYSTEMNAME propertyh
receive-job svccheck -Keep | 
Select SystemName,Name,Displayname,State,Startmode |
Format-Table
cls

#option 2 use invoke-command
#I can let Invoke-Command give me the computer name
#Get-Ciminstance is running remotely and results come back to me
#this approach scales better as it also supports throttling
Invoke-command {Get-Ciminstance win32_service -filter "startmode='auto' AND state<>'running'" | 
Select Name,Displayname,State,Startmode 
} -jobName SvcCheck2 -computername srv1,srv2,dom1 -asjob
wait-job svccheck2
receive-job svccheck2 -Keep | select * -ExcludeProperty run* | format-table
cls
#option 3 create a job on all the remote computers
$pssess = New-PSSession -ComputerName srv1,srv2,dom1
invoke-command {
 Start-Job { Get-Ciminstance win32_service -filter "startmode='auto' AND state<>'running'"} -name check
} -session $pssess
invoke-command {  Wait-Job check } -session $pssess

#job results are on each remote computer
invoke-command {
 Receive-job check -keep | Select Name,Displayname,State,Startmode
} -session $pssess | Select * -ExcludeProperty run*

#be sure to get results before removing sessions
remove-pssession $pssess

cls
#endregion
