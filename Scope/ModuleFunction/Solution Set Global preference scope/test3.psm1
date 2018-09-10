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

