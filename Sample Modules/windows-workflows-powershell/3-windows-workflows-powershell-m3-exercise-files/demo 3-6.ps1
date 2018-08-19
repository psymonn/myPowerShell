#    Demo 3-6
#    Activity Parameters

Workflow Get-CimClassWF
{
  [CmdletBinding()]
  Param ($CimClass = 'Win32_Bios',
         $comp     =  'DC1')

#     Get The CIM Class
  Get-CimInstance $CimClass –PSComputer $comp –PSCredential $credrk
}

#    Invoke the workflow WITH parameters
Get-CimClassWF  -CimClass 'Win32_ComputerSystem'
 
