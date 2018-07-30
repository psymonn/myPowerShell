#creating your own tools

#you could run this:
Get-CimInstance Win32_OperatingSystem -ComputerName srv1 |
Select-object -property @{Name="Computername";Expression={$_.CSName}},
@{Name="Name";Expression= { $_.Caption}},
Version,BuildNumber,InstallDate,OSArchitecture 

#but you want to make this easier for the help desk, so you create a tool
#the code is advanced and not something I'd expect you to be able to write today
ise C:\scripts\Get-MyOS.ps1

#dot source it because it isn't in a module
. C:\scripts\Get-MyOS.ps1
help get-myos
get-myos win10
get-myos srv2

cls

#reporting
ise c:\scripts\sysreport.ps1
C:\Scripts\Sysreport.ps1 -computername dom1 -Path c:\work\dom1.htm
invoke-item C:\work\dom1.htm

cls
help cim