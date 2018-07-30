#demo troubleshooting

#retest
cls

$cred = get-credential globomantics\administrator
test-wsman chi-core02 -Authentication Default -Credential $cred

icm { $psversiontable } -computer chi-core02 -Credential $cred
#test another computer
icm { $psversiontable } -computer chi-core01 -Credential $cred

#test legacy connections for name resolution and credentials
get-wmiobject win32_operatingsystem -ComputerName chi-core02 -Credential $cred

cls

#test firewall rules
Get-NetFirewallRule *winrm* -CimSession chi-core02 | 
Select Name,Description,Enabled,Action,Profile


<#
Here's an alternative that will also get the associated port
Get-NetFirewallRule *winrm* -CimSession chi-core02 | 
Select Name,Description,@{Name="Port"; 
Expression = { ($_ |  Get-CimAssociatedInstance -ResultClassName MSFT_NetProtocolPortFilter).LocalPort}},
Enabled,Action,Profile,PSComputername
#>

#test ports
#test known closed
#new-object System.Net.Sockets.TcpClient chi-core02,80
new-object System.Net.Sockets.TcpClient chi-core02,5985

cls


