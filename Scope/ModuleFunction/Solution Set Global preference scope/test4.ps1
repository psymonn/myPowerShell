<#
By default, this will retrieve the values of all PowerShell Preference variables
(as defined in the about_Preference_Variables help file) and set them in your function's local scope, 
unless the variable has an associated Common Parameter (-Verbose, etc) which has been set in the $PSBoundParameters table.
#>

function Test-ModuleFunction
{
    [CmdletBinding()]
    param ( )
    
    begin
    {
        
        . .\Get-CallerPreference.ps1

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }
}

