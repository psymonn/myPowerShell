
#show user and AD Group memberships
#this requires the ActiveDirectory module from Remote Server Administration Tools
get-aduser $env:username -Properties memberof,displayname
cls

#region disable remoting for testing

#must be run in an elevated session
#disable and reset first
Disable-PSRemoting -force
stop-service winrm
set-service winrm -StartupType Disabled
get-netfirewallrule *winrm* | 
Select Name,Enabled,Profile,Direction,Action | 
format-table

Disable-netfirewallrule winrm-http-in-TCP* 

cls

#endregion

#region Enable

test-wsman
get-service winrm

Enable-PSRemoting
get-service winrm
test-wsman

#endregion

#region Testing

test-wsman -ComputerName srv1
#this will throw an error
test-wsman -ComputerName srv2 -Credential company\administrator
#you must specify authentication
test-wsman -ComputerName srv2 -Credential company\administrator -Authentication Default

#check the service - this does not use remoting
get-service winrm -comp dom1,srv1,srv2 | select machinename,name,status,StartType

cls
#endregion


