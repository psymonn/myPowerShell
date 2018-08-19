#requires -version 3.0

#demo CIM cmdlets

#region Get-Cimclass

help Get-CimClass -ShowWindow

 #list classes
get-cimclass win32* -Verbose | Out-GridView

#looking at a single class
$c = Get-CimClass win32_logicaldisk
$c
$c | select *
$c.CimClassProperties
$c.CimClassProperties | Select Name,CimType
$c.CimClassMethods

#find properties
gcls win32* -PropertyName Size

#find methods
gcls win32* -MethodName Start*

#endregion

#region Get-CIMInstance

help Get-CimInstance -ShowWindow

get-ciminstance win32_operatingsystem
get-ciminstance win32_operatingsystem | gm
gcim win32_operatingsystem | select *

#select query
gcim -query "Select * from win32_logicaldisk where deviceid='c:'"

#selecting properties doesn't change default display
gcim -query "Select DeviceID,Size,FreeSpace from win32_logicaldisk where deviceid='c:'"

gcim -query "Select * from win32_logicaldisk where deviceid='c:'" |
Select DeviceID,Size,FreeSpace

#filtering
gcim win32_logicaldisk -filter "deviceid='c:'" | 
Select DeviceID,Size,FreeSpace

#key property
gcim win32_logicaldisk -KeyOnly
#show key property from the class definition
$c.cimclassproperties | where {$_.flags -match "key"}

#helps to know in advance the keyvalue so later commands
#can run faster
Measure-Command {
gcim win32_logicaldisk -KeyOnly -CimSession $dc04 | 
Select PSComputername,DeviceID
}

Measure-Command {
gcim win32_logicaldisk -CimSession $dc04 | 
Select PSComputername,DeviceID
}

#using computernames
gcim win32_operatingsystem -ComputerName chi-dc01,chi-dc02,chi-dc04

#using CIMSessions
get-cimsession | Select Computername,Protocol

$cs = Get-CimSession 

gcim win32_operatingsystem -CimSession $cs

#get-cimsession should accept wildcards for computer names but 
#there seems to be a bug

gcms -ComputerName chi-dc01,chi-dc02,chi-dc04 | 
gcim win32_operatingsystem

gcms | gcim win32_operatingsystem | 
Select PSComputername,Version,
@{N="OS";E={$_.Caption}},
@{N="ServicePack";E={$_.CSDVersion}},
InstallDate | sort InstallDate

#region CIM jobs
$computers = "chi-dc01","chi-dc04","chi-fp02"start-job { $input | foreach { get-ciminstance -class win32_service -computer $_ -verbose}
} -input $computers -Name Win32Svc

get-job win32Svc -IncludeChildJob
$data = receive-job Win32Svc -Keep
$data.count

#The PSComputername is for the job, not the CIM cmdlet
$data | Sort SystemName,Name |
Select SystemName,Name,State,StartName |
Out-GridView -Title "Services"

#or run Get-CIMInstance "locally"
Invoke-command {get-ciminstance win32_share -filter "type=0"} -ComputerName $computers -AsJob -JobName shares

get-job shares -IncludeChildJob
$sharedata = receive-job shares -Keep
$sharedata

#endregion

#endregion