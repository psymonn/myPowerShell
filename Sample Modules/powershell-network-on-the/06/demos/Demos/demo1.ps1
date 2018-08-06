#demo CIM cmdlets

help Get-Cimclass
cls

#use the default namespace Root\Cimv2
#discover all the classes q 
get-cimclass -class win32* | more

help Get-CimInstance
cls

Get-CimInstance -ClassName win32_operatingsystem
#same information as WMI
Get-WmiObject win32_operatingsystem
#different class
cls
get-wmiobject win32_operatingsystem | get-member | more
get-ciminstance win32_operatingsystem | get-member | more

cls
#but no system properties
get-ciminstance win32_operatingsystem | select * | more

cls
$computers = "dom1","srv1","srv2"

get-ciminstance win32_logicaldisk -ComputerName $computers

#notice install date is automatically formatted
get-ciminstance win32_operatingsystem -computername $computers | 
select PSComputername,Caption,OSArchitecture,InstallDate

#filtering works the same
#several options:
get-ciminstance -query "Select * from win32_process where Name = 'lsass.exe'" -ComputerName srv2 | 
Select Name,Processid,WorkingSetSize
get-ciminstance win32_process -filter "name='lsass.exe'" -ComputerName srv2 | 
Select Name,Processid,WorkingSetSize
get-ciminstance Win32_Volume -filter "bootvolume='true'" -ComputerName $computers |
Select PSComputername,Name,Capacity,Freespace,Compressed,QuotasEnabled
cls
