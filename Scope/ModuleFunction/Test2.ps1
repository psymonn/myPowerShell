#I researched this, and at some point discovered that module functions can get at the variables in the caller's scope
#by using properties and methods of the $PSCmdlet object, for example:
# Test.ps2:

Import-Module .\Test2.psm1

$ErrorActionPreference = 'stop'

Test-ModuleFunction


#conclusion: after testing:
#Import-Module test2.psm1
#runt test2.ps1
#you can overide the global default value during execution
#once its completed the excution the global default value show up again.
#the above comment is correct!!
