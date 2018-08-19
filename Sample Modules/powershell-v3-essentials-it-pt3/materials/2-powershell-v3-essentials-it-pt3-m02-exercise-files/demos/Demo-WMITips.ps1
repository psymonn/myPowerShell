#requires -version 3.0

#demo WMI Tips

#region WMI Shortcuts

#wmiclass
$cs = [wmiclass]"win32_computersystem"
$cs

$cs.Properties | Select Name,Type
$cs.Methods | Select Name

#wmi
#you need to know the path and key property
$svc = [wmi]"root\cimv2:win32_service.name='bits'"
$svc
#connect to a remote computer
$c = [wmi]"\\chi-dc01\root\cimv2:win32_logicaldisk.DeviceID='C:'"
$c
$c | select *

#wmisearcher
$search = [wmisearcher]"Select * from win32_process where name='svchost.exe'"
$search

#run locally
$search.Get() | 
Select PSComputername,VM,WS,*ModeTime,ProcessID |
ogv

#change the search scope
$search.scope.path="\\chi-dc04\root\cimv2"
$search.Get() | 
Select PSComputername,VM,WS,*ModeTime,ProcessID |
ogv

#endregion

#region WMI Tips and Tricks

$Computers = "chi-dc01","chi-dc02","chi-dc04","chi-fp02"

gwmi win32_operatingsystem -ComputerName $computers |
Select PSComputername,InstallDate

#convert date time
gwmi win32_operatingsystem -comp $computers | 
Select PSComputername,@{Name="OS";Expression={$_.Caption}},
@{Name="ServicePack";Expression={$_.CSDVersion}},
Version,
@{Name="Installed";Expression={$_.ConvertToDateTime($_.InstallDate)}}

#format numbers
gwmi win32_physicalmemory | 
Select PSComputername,Capacity

gwmi win32_physicalmemory -computer $computers | 
Select PSComputername,@{Name="SizeMB";Expression={$_.Capacity/1Mb}} |
Sort SizeMB

#another example
#memory sizes are in KB
gwmi win32_operatingsystem -comp $computers | 
select PSComputername,
@{Name="TotalMemoryMB";Expression={[int]($_.TotalVisibleMemorySize/1KB)}},
@{Name="FreeMemoryMB";
Expression={[math]::Round($_.FreePhysicalmemory/1KB,2)}},
@{Name="PercentMemoryFree";
Expression={[math]::Round(($_.freephysicalmemory/$_.totalvisibleMemorySize)*100,2)}}

#running as job
$computers+=$env:computername

gwmi win32_product -ComputerName $computers -AsJob

#we can nest WMI queries
gwmi win32_operatingsystem -comp $computers | 
Select PSComputername,
@{Name="OS";Expression={$_.Caption}},
@{Name="ServicePack";Expression={$_.CSDVersion}},
Version,
@{Name="Installed";Expression={$_.ConvertToDateTime($_.InstallDate)}},
@{Name="MemoryMB";Expression={ 
$memory = Get-Wmiobject win32_Physicalmemory -comp $_.pscomputername
$memory.Capacity/1Mb
}} 


#set authentication to packetprivacy by default
$PSDefaultParameterValues.Add("get-wmiobject:authentication","PacketPrivacy")

get-wmiobject -Namespace root\webadministration -class site -ComputerName chi-web01

#check job
Get-Job
$data = get-job | Receive-Job -Keep 

#sometimes dates are in a different format
$data | Select PSComputername,Name,Version,Vendor,InstallDate

$data | Select PSComputername,Name,Version,Vendor,
@{Name="Installed";Expression={
$yr = $_.InstallDate.substring(0,4)
$mo = $_.InstallDate.substring(4,2)
$dy = $_.InstallDate.substring(6)
"$mo/$dy/$yr" -as [datetime]
}} | out-gridview -title "Installed Apps"


#endregion
