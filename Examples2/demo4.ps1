#region methods

$c = Get-Cimclass win32_share
$c
$c.CimClassMethods
$c.CimClassMethods["Create"]

#use MSDN documentation for the class
#http://bit.ly/CreateWin32_Share

#CIM Cmdlets don't return any methods
#create is a static method meaning it doesn't require an instance or object
get-wmiobject win32_share | get-member -MemberType Method
get-ciminstance win32_share | get-member -MemberType Method

#or look at this
Get-WmiObject win32_process | get-member terminate
Get-CimInstance win32_process | get-member terminate

cls
#this must be run in an elevated session

help Invoke-CimMethod
cls
#need to know parameter names
$c.CimClassMethods["Create"].Parameters | select name,cimtype

cls
#arguments passed as a hash table, no need for nulls
#sometimes you might have to specify the type
$hash = @{
Name = "WorkFiles"
Description = "My work folder"
Type = [uint32]0 
Path = "C:\Work"
}

Invoke-CimMethod -Class win32_share -Name Create -Arguments $hash

$w = Get-CimInstance win32_share -filter "name='workfiles'"
$w
#There is no method
$w | get-member delete

Get-Ciminstance win32_share -filter "name='workfiles'" |
Invoke-CimMethod -MethodName Delete -Confirm
cls

#endregion
