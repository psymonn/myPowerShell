
#accelerators
#You might see these used but I would avoid
[wmi]"\\.\root\cimv2:win32_logicaldisk.deviceid='c:'"
#you need a primary key, which not all classes may have
[wmi]"\\.\root\cimv2:win32_operatingsystem"

$c = Get-WmiObject -list win32_service
$c
#look for a KEY qualifier
$c.properties | Select Name,Type,Qualifiers | more
$c.properties | where {$_.qualifiers.name -contains 'key'}
[wmi]"\\.\root\cimv2:win32_service.name='bits'"
cls

$search = [wmisearcher]"Select * from win32_service where name='bits'"
$search
$search.query
$search.get()

#isn't this much easier?
get-wmiobject win32_service -filter "name='bits'"
cls

#region other namespaces/classes

$ns = "root\microsoft\windows\storage"
Get-WmiObject -Namespace $ns  -list -Class msft* | more

Get-WmiObject -Namespace $ns -Class msft_disk | more

#or use this old script from the Powershell v2 days
c:\scripts\WmiExplorer.ps1

cls

#endregion

