#region wmi jobs

#requires PowerShell remoting
help Get-WmiObject -Parameter asjob
#need to run elevated and remoting must be enabled locally and remotely
#you may need to adjust firewall settings if this doesn't work.

#might also need Remote Administration firewall rules enabled
$j = Get-WmiObject Win32_logicaldisk -filter "deviceid='c:'" -ComputerName 'srv1','srv2','dom1' -asjob

wait-job $j
$j | receive-job -keep
#may need to get a property to indicate the computer name.
receive-job $j -keep | Select PSComputername,DeviceID,Size,Freespace

cls

#or use Start-Job
start-job { Get-Wmiobject win32_operatingsystem -computername srv1,srv2,dom1} -name OS
wait-job OS
#need to use an object property to get remote server name. 
receive-job OS -keep | Select CSName,Caption,InstallDate

cls
#use Invoke-Command
invoke-command { 
get-wmiobject win32_operatingsystem | 
Select @{Name="Computername";Expression={$_.CSName}},
Caption,Version,
@{Name="Installed";Expression={$_.Converttodatetime($_.Installdate)}}
} -computername srv1,srv2,dom1 -HideComputerName -asjob -JobName GetOS
Wait-Job GetOS
receive-job GetOS -Keep

cls
#endregion


