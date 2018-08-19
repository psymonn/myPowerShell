#requires -version 3.0

#demo CIM methods

get-cimclass win32_process | select -expand Cimclassmethods

calc;calc;calc

gcim win32_process -filter "name='calc.exe'"

gcim win32_process -filter "name='calc.exe'" |
Invoke-CimMethod -MethodName Terminate -WhatIf

gcim win32_process -filter "name='calc.exe'" |
Invoke-CimMethod -MethodName Terminate

#works remotely
#we'll use notepad as a test process
(get-cimclass win32_process).CimClassMethods["Create"].Parameters
(get-cimclass win32_process).CimClassMethods["Terminate"].Parameters

#test locally
icim -ClassName win32_process -MethodName Create -Arguments @{Commandline="notepad.exe";CurrentDirectory="c:\"}

#the optional reason is a user defined value
gcim win32_process -filter "name='notepad.exe'" |
icim -MethodName Terminate -Arguments @{Reason=1}

#run remotely using our cimsessions
get-cimsession

gcms | 
icim -ClassName win32_process -MethodName Create -Arguments @{Commandline="notepad.exe";CurrentDirectory="c:\"}

gcms | gcim win32_process -filter "name='notepad.exe'" | 
icim -MethodName Terminate -Arguments @{Reason=1}

