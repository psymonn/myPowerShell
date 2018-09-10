# Test.psm1:

function Test-ModuleFunction
{
    [CmdletBinding()]
    param ( )

    Write-Host "Module Function: ErrorActionPreference = $ErrorActionPreference"
}
