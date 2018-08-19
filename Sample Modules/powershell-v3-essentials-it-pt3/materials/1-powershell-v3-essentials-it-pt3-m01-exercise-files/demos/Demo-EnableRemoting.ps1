#requires -version 3.0

#demonstrate enabling and configuring remoting.
#the assumption is that remoting is not configured
#on this machine.

#region Enable remoting

help Enable-PSRemoting -ShowWindow

get-service winrm

enable-psremoting

get-service winrm

Get-PSSessionConfiguration
Get-PSSessionConfiguration "microsoft.powershell" | select *

#use the command line tool to view configuration
winrm get winrm/config

#open Group Policy and show settings
gpmc.msc


#region using Test-WSMan
Test-WSMan
Test-wsman chi-dc04
Test-WSMan chi-dc02

#endregion


#endregion

#region WSMAN:

cd wsman:
dir
cd .\localhost
dir

dir .\Listener -Recurse | Select Name,Value
dir .\Shell
dir .\Client -recurse
dir .\Service -Recurse

#these are the endpoints
dir .\Plugin

cd C:\

cls

#endregion

#region configure TrustedHosts

get-item wsman:\localhost\client\trustedhosts

test-wsman novo8
invoke-command { hostname } -comp  novo8 -Credential novo8\jeff

set-item wsman:\localhost\client\trustedhosts -Value "novo8"

#verify setting
get-item wsman:\localhost\client\trustedhosts

#try the command again
invoke-command { hostname } -comp novo8 -Credential novo8\jeff

#endregion

#region read more about it

help about_remote*

#endregion