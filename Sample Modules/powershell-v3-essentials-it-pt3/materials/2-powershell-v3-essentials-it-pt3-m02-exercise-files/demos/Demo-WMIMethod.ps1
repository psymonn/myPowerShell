#requires -version 3.0

#demo Invoke-WMIMethod

notepad
#you can use methods directly
$notepad = Get-WmiObject win32_process -filter "name='notepad.exe'"

$notepad | gm -MemberType method

#need () even if no methods
#no -Whatif
$notepad.Terminate()

#return value of 0 means success
help Invoke-WmiMethod -ShowWindow

notepad

Get-WmiObject win32_process -filter "name='notepad.exe'" |
Invoke-WmiMethod -Name Terminate -WhatIf

Get-WmiObject win32_process -filter "name='notepad.exe'" |
Invoke-WmiMethod -Name Terminate

#invoke methods with an argument

#check current startmode
gwmi win32_service -filter "name='wuauserv'" -comp chi-dc01,chi-dc02,chi-dc04 |
Select PSComputername,name,startmode

gwmi win32_service -filter "name='wuauserv'" -comp chi-dc01,chi-dc02,chi-dc04 |
Invoke-WmiMethod -name ChangeStartMode -ArgumentList "auto" -whatif

gwmi win32_service -filter "name='wuauserv'" -comp chi-dc01,chi-dc02,chi-dc04 |
Invoke-WmiMethod -name ChangeStartMode -ArgumentList "automatic" 

#verify
gwmi win32_service -filter "name='wuauserv'" -comp chi-dc01,chi-dc02,chi-dc04 |
Select PSComputername,name,startmode

<#
method parameters are entered alphabetically not in 
the order seen in documentation
#>

start "http://msdn.microsoft.com/en-us/library/windows/desktop/aa393598(v=vs.85).aspx"

gwmi win32_share -filter "name='labs'"

gwmi win32_share -filter "name='labs'" |
Invoke-WmiMethod -Name SetShareInfo -ArgumentList @(5,"TrainSignal Labs")

#parameters as PowerShell sees them
([wmiclass]"win32_share").GetMethodParameters("setShareInfo")

gwmi win32_share -filter "name='labs'" |
Invoke-WmiMethod -Name SetShareInfo -ArgumentList @($null,"TrainSignal Labs",25)

gwmi win32_share -filter "name='labs'" | select Name,Description,Max*

<#
Look for cmdlets that implement WMI methods or use the newer CIM cmdlets
#>