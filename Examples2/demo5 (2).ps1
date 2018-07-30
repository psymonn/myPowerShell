#region WMI in action

ise c:\scripts\New-SystemReport.ps1

#test locally
#default output is text
C:\scripts\new-systemreport.ps1

#create HTML reports for remote servers
C:\scripts\new-systemreport.ps1 -computername srv1,srv2 -HTML | 
Out-file c:\work\report.html
invoke-item  c:\work\report.html

cls
#endregion

#region look for cmdlets to do WMI-related tasks

#instead of invoking methods
get-wmiobject win32_operatingsystem -computer srv1 | invoke-wmimethod -name Reboot -whatif
help restart-computer
restart-computer -ComputerName srv1 -WhatIf
cls

#you could do this
Get-WmiObject win32_share
#this is easier
Get-SmbShare

#creating a share with WMI is complicated as we saw earlier
#this is easier
help new-smbshare
New-SmbShare -Name Work -Path C:\work -FullAccess "company\domain admins" -FolderEnumerationMode AccessBased
get-smbshare
Get-SmbShareAccess -Name work
dir \\win10\work
Remove-SmbShare -Name work

cls

#endregion

help about_wmi