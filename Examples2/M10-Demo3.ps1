#look at WSMan settings
connect-wsman -ComputerName chi-core02
cd WSMan:\chi-core02

dir
#look at listener
dir .\Listener\l* -Recurse

#look at service
dir .\Service -Recurse
#look at security settings
dir .\Service\RootSDDL | select Value

#read about the sddlparse.exe tool here:
#https://jorgequestforknowledge.wordpress.com/2008/03/26/parsing-sddl-strings/
s:\sddlparse (Get-Item .\Service\RootSDDL).Value

cls
#check configuration
dir .\Plugin\microsoft.powershell
cd .\Plugin\microsoft.powershell\resources\res*
dir
cd .\Security
dir
cd sec*
cls
dir

cls
s:\sddlparse (Get-Item .\sddl).Value
#return to current location
cd \

cd C:\

#disconnect
Disconnect-WSMan -ComputerName chi-core02

cls

#test outside of PowerShell
winrm /?
winrm id -remote:chi-core02
winrm g wsman/config -remote:chi-core02
cls

#as a last resort, re-enable remoting on remote computer
mstsc -v chi-core02

#retry command
icm { $psversiontable} -computername chi-core02 -Credential $cred

icm { get-process -IncludeUserName | sort VM -Descending | select -first 5} -computer chi-core02 | 
format-table ID,Name,Username,VM -AutoSize

cls
