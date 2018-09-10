<#
Passing the $PSCmdlet object to the Get-CallerPreference function 
gives it the ability to read the BoundParameters collection and access your caller's variables,
and passing in $ExecutionContext.SessionState gives it the ability to set those variables
in your function's scope (Test-ModuleFunction, in this case.)  
This works even if the Get-CallerPreference function is exported
from a different module than Test-ModuleFunction.
#>

# The test.ps1 script:

Import-Module .\test3.psm1 -Force

$script:ErrorActionPreference = 'Stop'
$script:NonstandardPreferenceVariable = 'I exist!'
$script:PsymonPeferenceVariable = 'Who am I?'


# The test.psm1 Module (which also includes the Get-CallerPreference function):

function Test-ModuleFunction
{
    [CmdletBinding()]
    param ( )
    
    begin
    {
        Write-Host "Before:`r`n"

        Write-Host "ErrorActionPreference: $ErrorActionPreference"
        Write-Host "NonstandardPreferenceVariable: $NonstandardPreferenceVariable"
        Write-Host "PsymonPeferenceVariable: $PsymonPeferenceVariable"

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','NonstandardPreferenceVariable'

        Write-Host "`r`nAfter:`r`n"

        Write-Host "ErrorActionPreference: $ErrorActionPreference"
        Write-Host "NonstandardPreferenceVariable: $NonstandardPreferenceVariable"
        Write-Host "PsymonPeferenceVariable: $PsymonPeferenceVariable"
    }
}

Test-ModuleFunction


<#

Output:

Before:

ErrorActionPreference: Continue
NonstandardPreferenceVariable: 

After:

ErrorActionPreference: Stop
NonstandardPreferenceVariable: I exist!

#>