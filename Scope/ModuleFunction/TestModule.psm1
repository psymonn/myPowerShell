<#
# File TestModule.psm1:
function Test-ScriptModuleFunction
{
    [CmdletBinding()]
    param ( )

    Write-Host "Module Function Effective VerbosePreference: $VerbosePreference"
    Write-Verbose "Something verbose."
}

#>

function Test-ScriptModuleFunction
{
    [CmdletBinding()]
    param ()

    if (-not $PSBoundParameters.ContainsKey('Verbose'))
    {
        #$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
        $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
    }

    Write-Host "Module Function Effective VerbosePreference: $VerbosePreference"
    Write-Verbose "Something verbose."
}

 
