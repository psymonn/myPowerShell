#
# Demo 1-2
# PsModuleInfo objects
#
#
Get-Module -ListAvailable m1
#
Import-Module M1 -verbose
Import-module M1 -verbose -force
Get-Greeting
cls
#
#
# Look at details of Module
$m1 = Import-Module M1 -PassThru
$m1 | Get-Member 
cls
$m1 | Format-List definition
cls
#
#
$m1.accessmode
$m1.accessmode = "ReadOnly"
Remove-Module M1
Remove-Module m1 -force -verbose
cls
# try again with Constant
$m1 = Import-Module M1 -PassThru
$m1.accessmode = "Constant"
Remove-Module M1 -verbose
Remove-Module M1 -force -verbose

