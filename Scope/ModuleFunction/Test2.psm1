#I researched this, and at some point discovered that module functions
# can get at the variables in the caller's scope
#by using properties and methods of the $PSCmdlet object, for example:

function Test-ModuleFunction
{
    [CmdletBinding()]
    param ( )
    
    
    if (-not $PSBoundParameters.ContainsKey('ErrorAction'))
    {
        $ErrorActionPreference = $PSCmdlet.GetVariableValue('ErrorActionPreference')
    }
    
    Write-Host "Module Function: ErrorActionPreference = $ErrorActionPreference"
}