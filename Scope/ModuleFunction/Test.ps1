#If the caller sets, for example, $ErrorActionPreferenceto 'Stop' 
#in the Script scope and then calls your function, your function
#will still be acting with the value of the global $ErrorActionPreference, 
#which is most likely still set to the default value of 'Continue'.

# Test.ps1:

Import-Module .\Test.psm1

$ErrorActionPreference = 'Stop'

Test-ModuleFunction


#conclusion: after testing:
#Import-Module test1.psm1
#runt test.ps1
#no matter what it still showing $global default value
#the above comment is correct!!
