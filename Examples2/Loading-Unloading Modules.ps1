## Verify the module created earlier is available
Get-Module -ListAvailable

## Verify the functions in the module are available
Get-Command -Module MyModule

## The module is not loaded into the session
Get-Module -Name MyModule

## Call a function inside the module and it gets auto-loaded
Get-VirtualMachine

## Remove the module from the session
Remove-Module -Name MyModule

## Manually load the module
Import-Module -Name MyModule
Get-Module -Name MyModule

New-Item C:\users\administrator.LAB\Desktop\ModuleNameThis.psm1 -ItemType File
ise C:\users\administrator.LAB\Desktop\ModuleNameThis.psm1
Import-Module C:\users\administrator.LAB\Desktop\ModuleNameThis.psm1
Get-Module -Name ModuleNameThis