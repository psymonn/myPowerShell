#demo WMI
help Get-WmiObject
cls
#list find default classes
#use the default namespace Root\Cimv2
get-wmiobject -list -class win32* | more

#get class information online
start "http://bing.com/search?q=win32_operatingsystem"

get-wmiobject -ClassName win32_operatingsystem
#this is an object
#or pipe to Get-Member
get-wmiobject win32_operatingsystem | select * | more

cls
#multiple computers
$computers = "dom1","srv1","srv2"
get-wmiobject win32_operatingsystem -computername $computers | 
select PSComputername,Caption,OSArchitecture,ServicePackMajorVersion,InstallDate

#WMI Dates can be converted
get-wmiobject win32_operatingsystem -computername $computers | 
select PSComputername,Caption,OSArchitecture,
ServicePackMajorVersion,
@{Name="Installed";Expression={$_.ConvertToDatetime($_.InstallDate)}}
cls

#filtering
#selecting properties
get-wmiobject win32_process -ComputerName srv2| Select Name,Processid,WorkingSetSize

#NOT THIS
get-wmiobject win32_process -ComputerName srv2 | where { $_.name -eq 'lsass.exe'}

#several options:
get-wmiobject -query "Select * from win32_process where Name = 'lsass.exe'" -ComputerName srv2 | 
Select Name,Processid,WorkingSetSize

get-wmiobject win32_process -filter "name='lsass.exe'" -ComputerName srv2 | 
Select Name,Processid,WorkingSetSize
cls

#also supports credentials
$cred = Get-Credential company\administrator
get-wmiobject win32_logicaldisk -filter "deviceid='c:'" -ComputerName $computers -credential $cred | 
Select PSComputername,Caption,Size,Freespace

#customize the output
get-wmiobject win32_logicaldisk -filter "deviceid='c:'" -ComputerName $computers -credential $cred | 
Select PSComputername,Caption,@{Name="SizeGB";
Expression={($_.Size/1gb) -as [int]}},
@{Name="FreeGB";Expression={$_.Freespace/1gb}},
@{Name="PctFree";Expression={ ($_.freespace/$_.size)*100}}
cls
#you need credentials for non-domain machines
get-wmiobject win32_processor -comp srv3
get-wmiobject win32_processor -comp srv3 -Credential srv3\administrator
cls

#a non PowerShell tool for testing
wbemtest
