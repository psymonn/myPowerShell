#    Demo 3-3
#    Define the workflow with a parameter

Workflow Get-CimClassWF {
[CmdletBinding()]
 Param ($CimClass = 'Win32_Bios')

#     Get The CIM Class
  Get-CimInstance $CimClass}

#    Invoke the workflow - with no parameters
Get-CimClassWF 

#    Invoke the workflow WITH parameters
Get-CimClassWF  -CimClass 'Win32_ComputerSystem'
