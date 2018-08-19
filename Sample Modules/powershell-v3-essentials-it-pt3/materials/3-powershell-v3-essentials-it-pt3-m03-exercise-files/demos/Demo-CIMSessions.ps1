#requires -version 3.0

#demo CIMSessions

#region New-CIMSession

help New-CimSession -ShowWindow

#let's test with a CIMSession created locally
#use -Name to make it easier to reference the session
New-CimSession -Name Me -ComputerName $env:computername

#create a session with a credential
$dc04 = New-CimSession -ComputerName chi-dc04 -Credential globomantics\administrator
$dc04

#DC02 is running PowerShell 2.0
$dc02 = New-CimSession -ComputerName chi-dc02 -Credential globomantics\administrator
$dc02

#you can create the cimsession but it will be invalid when you try to use it
#We'll look at Get-CIMInstance in more detail later
Get-CimInstance win32_computersystem -CimSession $dc02

#while we're at, let's creat some additional CIMSessions
New-CimSession -ComputerName CHI-DC01,CHI-FP02

#endregion

#region CIMSession Options

#Use Test-WSMan to verify protocol version
Test-WSMan chi-dc04
Test-WSMan chi-dc02

#we need to create a CIMSession that uses DCOM as the protocol
help New-CimSessionOption -ShowWindow

$option = New-CimSessionOption -Protocol Dcom
$option
#now create the CIMSession
$dc02 = New-CimSession -ComputerName chi-dc02 -Credential globomantics\administrator -SessionOption $option
$dc02

#this will work. We'll use it later.
#endregion

#region Getting sessions
help Get-CimSession -ShowWindow

Get-CimSession

Get-CimSession -Name me
gcms CHI-DC02

#endregion

#region Removing CIMSessions

#sessions will automatically close when you end PowerShell
help Remove-CimSession -ShowWindow

#make sure you use Remove-CIMSession and NOT Remove-PSSession
gcms chi-dc02  | Where {$_.protocol -eq "WSMAN"} | Remove-CIMSession -whatif
gcms chi-dc02  | Where {$_.protocol -eq "WSMAN"} | Remove-CIMSession

gcms | ft ID,Name,Computername,Protocol

#endregion