
#region other namespaces/classes

#works pretty much as WMI did
$ns = "root\microsoft\windows\storage"
Get-cimclass -Namespace $ns -Class msft* | more

Get-cimclass -Namespace $ns -Class msft_disk

#getting an instance
Get-CimInstance -Namespace $ns -ClassName msft_disk | Select *

#Microsoft has created many new commands based on these classes
Get-Disk | Select *
get-disk | Get-Member | more

get-command get-disk

#here is some code to see what classes are covered
#Don't worry, this isn't something you would be expected to know how to do
get-typedata -TypeName *cim* | where {$_.typename -notmatch 'win32'}| sort typename | more

#you could then try and find a command based on the classname
get-command -noun *healthaction*

cls

#endregion





