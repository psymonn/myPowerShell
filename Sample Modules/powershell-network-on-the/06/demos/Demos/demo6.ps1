#some practical examples of using CIM cmdlets

#query AD for computer names
$names = (Get-ADComputer -filter "OperatingSystem -like '*Server*'").Name
$names

#Verify which computers are online
$servers = $names | Where { Test-wsman $_}
$servers

ise c:\scripts\diskreporthtml.ps1
c:\scripts\diskreporthtml.ps1 -computer $servers -path c:\work\diskreport.htm
cls

#get uptime
#let's restart a computer to make it interesting
#the command uses WMI bits under the hood
Restart-computer srv1 -Force -Wait -For WinRM
#limit the properties returned to speed things up a bit
Get-CimInstance -ClassName win32_operatingsystem -ComputerName $servers -Property LastBootUpTime | 
Select @{Name="Computername";expression={$_.PSComputername}},
LastBootUpTime,
@{Name="Runtime";Expression={(Get-Date) - $_.lastbootuptime}}
cls

#checking hotfixes
#this uses WMI/DCOM
get-hotfix -ComputerName $servers

#or use CIM
Get-Ciminstance Win32_QuickFixEngineering -ComputerName $servers
#what properties can I use
(get-cimclass win32_quickfixengineering).cimclassproperties | Select Name
Get-Ciminstance Win32_QuickFixEngineering -ComputerName $servers | 
Select CSName,HotfixID,Installed*,Description,Caption |
Out-GridView -title "HotFix List"

cls
