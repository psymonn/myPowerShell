#requires -Version 2

$LogFilePreference = $null

function Write-DebugLog
{
    <#
    .Synopsis
       Proxy function for Write-Debug.  Optionally, also directs the debug output to a log file.
    .DESCRIPTION
       Has the same definition as Write-Debug, with the addition of a -LogFile parameter.  If this
       argument has a value, it is treated as a file path, and the function will attempt to write
       the debug output to that file as well (including creating the parent directory, if it doesn't
       already exist).  If the path is malformed or the user does not have permission to create or
       write to the file, New-Item and Add-Content will send errors back through the output stream.

       Non-blank lines in the log file are automatically prepended with a culture-invariant date
       and time, and with the text [D] to indicate this output came from the debug stream.
    .PARAMETER LogFile
       Specifies the full path to the log file.  If this value is not specified, it will default to
       the variable $LogFilePreference, which is provided for the user's convenience in redirecting
       output from all of the Write-*Log functions to the same file.
    .LINK
       Write-Debug
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position=0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [System.String]
        $Message,

        [System.String]
        $LogFile = $null,

        [System.Management.Automation.ScriptBlock]
        $Prepend = { PrependString -Line $args[0] -Flag '[D]' }
    )

    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $_logFile = $LogFile
            $null = $PSBoundParameters.Remove('LogFile')
        }
        else
        {
            $_logFile = $PSCmdlet.GetVariableValue("LogFilePreference")
        } 

        $null = $PSBoundParameters.Remove('Prepend')

        $outBuffer = $null

        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        try 
        {
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Write-Debug', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }

    } # begin

    process
    {
        if (ShouldPerformLogging -Path $_logFile -ActionPreference $DebugPreference)
        {
            foreach ($line in $Message -split '\r?\n')
            {
                if ($null -ne $Prepend)
                {
                    $results = $Prepend.Invoke($line)
                    if ($results.Count -gt 0 -and ($prependString = $results[0]) -is [System.String])
                    {
                        $line = "${prependString}${line}"
                    }
                }

                Add-Content -Path $_logFile -Value $line
            }
        }

        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }

} # function Write-DebugLog

function Write-VerboseLog {
    <#
    .Synopsis
       Proxy function for Write-Verbose.  Optionally, also directs the verbose output to a log file.
    .DESCRIPTION
       Has the same definition as Write-Verbose, with the addition of a -LogFile parameter.  If this
       argument has a value, it is treated as a file path, and the function will attempt to write
       the debug output to that file as well (including creating the parent directory, if it doesn't
       already exist).  If the path is malformed or the user does not have permission to create or
       write to the file, New-Item and Add-Content will send errors back through the output stream.

       Non-blank lines in the log file are automatically prepended with a culture-invariant date
       and time, and with the text [V] to indicate this output came from the verbose stream.
    .PARAMETER LogFile
       Specifies the full path to the log file.  If this value is not specified, it will default to
       the variable $LogFilePreference, which is provided for the user's convenience in redirecting
       output from all of the Write-*Log functions to the same file.
    .LINK
       Write-Verbose
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position=0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [System.String]
        $Message,

        [System.String]
        $LogFile = $null,

        [System.Management.Automation.ScriptBlock]
        $Prepend = { PrependString -Line $args[0] -Flag '[V]' }
    )

    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $_logFile = $LogFile
            $null = $PSBoundParameters.Remove('LogFile')
        }
        else
        {
            $_logFile = $PSCmdlet.GetVariableValue("LogFilePreference")
        } 

        $null = $PSBoundParameters.Remove('Prepend')

        $outBuffer = $null

        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        try 
        {
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Write-Verbose', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }

    } # begin

    process
    {
        if (ShouldPerformLogging -Path $_logFile -ActionPreference $VerbosePreference)
        {
            foreach ($line in $Message -split '\r?\n')
            {
                if ($null -ne $Prepend)
                {
                    $results = $Prepend.Invoke($line)
                    if ($results.Count -gt 0 -and ($prependString = $results[0]) -is [System.String])
                    {
                        $line = "${prependString}${line}"
                    }
                }

                Add-Content -Path $_logFile -Value $line 
            }
        }

        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }

} # function Write-VerboseLog

function Write-WarningLog
{
    <#
    .Synopsis
       Proxy function for Write-Warning.  Optionally, also directs the warning output to a log file.
    .DESCRIPTION
       Has the same definition as Write-Warning, with the addition of a -LogFile parameter.  If this
       argument has a value, it is treated as a file path, and the function will attempt to write
       the debug output to that file as well (including creating the parent directory, if it doesn't
       already exist).  If the path is malformed or the user does not have permission to create or
       write to the file, New-Item and Add-Content will send errors back through the output stream.

       Non-blank lines in the log file are automatically prepended with a culture-invariant date
       and time, and with the text [W] to indicate this output came from the warning stream.
    .PARAMETER LogFile
       Specifies the full path to the log file.  If this value is not specified, it will default to
       the variable $LogFilePreference, which is provided for the user's convenience in redirecting
       output from all of the Write-*Log functions to the same file.
    .LINK
       Write-Warning
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [System.String]
        $Message,

        [System.String]
        $LogFile = $null,

        [System.Management.Automation.ScriptBlock]
        $Prepend = { PrependString -Line $args[0] -Flag '[W]' }
    )

    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $_logFile = $LogFile
            $null = $PSBoundParameters.Remove('LogFile')
        }
        else
        {
            $_logFile = $PSCmdlet.GetVariableValue("LogFilePreference")
        } 

        $null = $PSBoundParameters.Remove('Prepend')

        $outBuffer = $null

        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        try 
        {
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Write-Warning', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }

    } # begin

    process
    {
        if (ShouldPerformLogging -Path $_logFile -ActionPreference $WarningPreference)
        {
            foreach ($line in $Message -split '\r?\n')
            {
                if ($null -ne $Prepend)
                {
                    $results = $Prepend.Invoke($line)
                    if ($results.Count -gt 0 -and ($prependString = $results[0]) -is [System.String])
                    {
                        $line = "${prependString}${line}"
                    }
                }

                Add-Content -Path $_logFile -Value $line 
            }
        }

        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }

} # function Write-WarningLog

function Write-ErrorLog
{
    <#
    .Synopsis
       Proxy function for Write-Error.  Optionally, also directs the error output to a log file.
    .DESCRIPTION
       Has the same definition as Write-Error, with the addition of a -LogFile parameter.  If this
       argument has a value, it is treated as a file path, and the function will attempt to write
       the debug output to that file as well (including creating the parent directory, if it doesn't
       already exist).  If the path is malformed or the user does not have permission to create or
       write to the file, New-Item and Add-Content will send errors back through the output stream.

       Non-blank lines in the log file are automatically prepended with a culture-invariant date
       and time, and with the text [E] to indicate this output came from the error stream.
    .PARAMETER LogFile
       Specifies the full path to the log file.  If this value is not specified, it will default to
       the variable $LogFilePreference, which is provided for the user's convenience in redirecting
       output from all of the Write-*Log functions to the same file.
    .LINK
       Write-Error
    #>

    [CmdletBinding(DefaultParameterSetName='NoException')]
    param(
        [Parameter(ParameterSetName = 'WithException', Mandatory = $true)]
        [System.Exception]
        $Exception,

        [Parameter(ParameterSetName = 'NoException', Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'WithException')]
        [Alias('Msg')]
        [AllowNull()]
        [AllowEmptyString()]
        [System.String]
        $Message,

        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord,

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Management.Automation.ErrorCategory]
        $Category,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException')]
        [System.String]
        $ErrorId,

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Object]
        $TargetObject,

        [System.String]
        $RecommendedAction,

        [Alias('Activity')]
        [System.String]
        $CategoryActivity,

        [Alias('Reason')]
        [System.String]
        $CategoryReason,

        [Alias('TargetName')]
        [System.String]
        $CategoryTargetName,

        [Alias('TargetType')]
        [System.String]
        $CategoryTargetType,

        [System.String]
        $LogFile = $null,

        [System.Management.Automation.ScriptBlock]
        $Prepend = { PrependString -Line $args[0] -Flag '[E]' }
    )

    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $_logFile = $LogFile
            $null = $PSBoundParameters.Remove('LogFile')
        }
        else
        {
            $_logFile = $PSCmdlet.GetVariableValue("LogFilePreference")
        } 

        $null = $PSBoundParameters.Remove('Prepend')

        $outBuffer = $null

        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        try 
        {
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }

    } # begin

    process
    {
        if (ShouldPerformLogging -Path $_logFile -ActionPreference $ErrorActionPreference)
        {
            $item = ''
            switch ($PSCmdlet.ParameterSetName)
            {
                'ErrorRecord'   { $item = $ErrorRecord }
                'WithException' { $item = $Exception   }
                default         { $item = $Message     }
            }

            foreach ($line in ($item | Out-String -Stream))
            {
                if ($null -ne $Prepend)
                {
                    $results = $Prepend.Invoke($line)
                    if ($results.Count -gt 0 -and ($prependString = $results[0]) -is [System.String])
                    {
                        $line = "${prependString}${line}"
                    }
                }

                Add-Content -Path $_logFile -Value $line
            }
        }

        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }

} # function Write-ErrorLog

function Write-HostLog
{
    <#
    .Synopsis
       Proxy function for Write-Host.  Optionally, also directs the output to a log file.
    .DESCRIPTION
       Has the same definition as Write-Host, with the addition of a -LogFile parameter.  If this
       argument has a value, it is treated as a file path, and the function will attempt to write
       the output to that file as well (including creating the parent directory, if it doesn't
       already exist).  If the path is malformed or the user does not have permission to create or
       write to the file, New-Item and Add-Content will send errors back through the output stream.

       Non-blank lines in the log file are automatically prepended with a culture-invariant date
       and time.
    .PARAMETER LogFile
       Specifies the full path to the log file.  If this value is not specified, it will default to
       the variable $LogFilePreference, which is provided for the user's convenience in redirecting
       output from all of the Write-*Log functions to the same file.
    .NOTES
       unlike Write-Host, this function defaults the value of the -Separator parameter to
       "`r`n".  This is to make the console output consistent with what is sent to the log file,
       where array elements are always written to separate lines (regardless of the value of the
       -Separator parameter;  if that argument is specified, it just gets passed on to Write-Host).
    .LINK
       Write-Host
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [System.Object]
        $Object,

        [Switch]
        $NoNewline,
        
        [System.Object]
        $Separator = "`r`n",

        [System.ConsoleColor]
        $ForegroundColor,

        [System.ConsoleColor]
        $BackgroundColor,

        [System.String]
        $LogFile = $null,

        [System.Management.Automation.ScriptBlock]
        $Prepend = { PrependString -Line $args[0] }
    )

    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        if ($PSBoundParameters.ContainsKey('LogFile'))
        {
            $_logFile = $LogFile
            $null = $PSBoundParameters.Remove('LogFile')
        }
        else
        {
            $_logFile = $PSCmdlet.GetVariableValue("LogFilePreference")
        } 

        $null = $PSBoundParameters.Remove('Prepend')

        $outBuffer = $null

        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        try 
        {
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Write-Host', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }

    } # begin

    process
    {
        if (ShouldPerformLogging -Path $_logFile)
        {
            foreach ($line in ($Object | Out-String -Stream))
            {
                if ($null -ne $Prepend)
                {
                    $results = $Prepend.Invoke($line)
                    if ($results.Count -gt 0 -and ($prependString = $results[0]) -is [System.String])
                    {
                        $line = "${prependString}${line}"
                    }
                }

                Add-Content -Path $_logFile -Value $line
            }
        }
            
        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }

} # function Write-HostLog

function ShouldPerformLogging
{
    [CmdletBinding()]
    param (
        [string]
        $Path,

        [System.String]
        $ActionPreference
    )

    if ([System.String]::IsNullOrEmpty($Path) -or $ActionPreference -eq 'SilentlyContinue' -or $ActionPreference -eq 'Ignore')
    {
        return $false
    }

    try
    {
        $folder = Split-Path $Path -Parent

        if ($folder -ne '' -and -not (Test-Path -Path $folder))
        {
            $null = New-Item -Path $folder -ItemType Directory -ErrorAction Stop
        }

        return $true
    }
    catch
    {
        try
        {
            $cmd = Get-Command -Name Write-Warning -CommandType Cmdlet
            & $cmd ($_ | Out-String)
        }
        catch { }

        return $false
    }
}

function PrependString
{
    [CmdletBinding()]
    param (
        [System.String]
        $Line,

        [System.String]
        $Flag
    )

    if ($null -eq $Line)
    {
        $Line = [System.String]::Empty
    }

    if ($null -eq $Flag)
    {
        $Flag = [System.String]::Empty
    }

    if ($Line.Trim() -ne '')
    {
        $prependString = "$(Get-Date -Format r) - "
        if (-not [System.String]::IsNullOrEmpty($Flag))
        {
            $prependString += "$Flag "
        }

        Write-Output $prependString
    }
}

function Get-CallerPreference
{
    <#
    .Synopsis
       Fetches "Preference" variable values from the caller's scope.
    .DESCRIPTION
       Script module functions do not automatically inherit their caller's variables, but they can be
       obtained through the $PSCmdlet variable in Advanced Functions.  This function is a helper function
       for any script module Advanced Function; by passing in the values of $ExecutionContext.SessionState
       and $PSCmdlet, Get-CallerPreference will set the caller's preference variables locally.
    .PARAMETER Cmdlet
       The $PSCmdlet object from a script module Advanced Function.
    .PARAMETER SessionState
       The $ExecutionContext.SessionState object from a script module Advanced Function.  This is how the
       Get-CallerPreference function sets variables in its callers' scope, even if that caller is in a different
       script module.
    .PARAMETER Name
       Optional array of parameter names to retrieve from the caller's scope.  Default is to retrieve all
       Preference variables as defined in the about_Preference_Variables help file (as of PowerShell 4.0)
       This parameter may also specify names of variables that are not in the about_Preference_Variables
       help file, and the function will retrieve and set those as well.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Imports the default PowerShell preference variables from the caller into the local scope.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','SomeOtherVariable'

       Imports only the ErrorActionPreference and SomeOtherVariable variables into the local scope.
    .EXAMPLE
       'ErrorActionPreference','SomeOtherVariable' | Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Same as Example 2, but sends variable names to the Name parameter via pipeline input.
    .INPUTS
       String
    .OUTPUTS
       None.  This function does not produce pipeline output.
    .LINK
       about_Preference_Variables
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]
        $SessionState,

        [Parameter(ParameterSetName = 'Filtered', ValueFromPipeline = $true)]
        [string[]]
        $Name
    )

    begin
    {
        $filterHash = @{}
    }
    
    process
    {
        if ($null -ne $Name)
        {
            foreach ($string in $Name)
            {
                $filterHash[$string] = $true
            }
        }
    }

    end
    {
        # List of preference variables taken from the about_Preference_Variables help file in PowerShell version 4.0

        $vars = @{
            'ErrorView' = $null
            'FormatEnumerationLimit' = $null
            'LogCommandHealthEvent' = $null
            'LogCommandLifecycleEvent' = $null
            'LogEngineHealthEvent' = $null
            'LogEngineLifecycleEvent' = $null
            'LogProviderHealthEvent' = $null
            'LogProviderLifecycleEvent' = $null
            'MaximumAliasCount' = $null
            'MaximumDriveCount' = $null
            'MaximumErrorCount' = $null
            'MaximumFunctionCount' = $null
            'MaximumHistoryCount' = $null
            'MaximumVariableCount' = $null
            'OFS' = $null
            'OutputEncoding' = $null
            'ProgressPreference' = $null
            'PSDefaultParameterValues' = $null
            'PSEmailServer' = $null
            'PSModuleAutoLoadingPreference' = $null
            'PSSessionApplicationName' = $null
            'PSSessionConfigurationName' = $null
            'PSSessionOption' = $null

            'ErrorActionPreference' = 'ErrorAction'
            'DebugPreference' = 'Debug'
            'ConfirmPreference' = 'Confirm'
            'WhatIfPreference' = 'WhatIf'
            'VerbosePreference' = 'Verbose'
            'WarningPreference' = 'WarningAction'
        }


        foreach ($entry in $vars.GetEnumerator())
        {
            if (([string]::IsNullOrEmpty($entry.Value) -or -not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($entry.Value)) -and
                ($PSCmdlet.ParameterSetName -eq 'AllVariables' -or $filterHash.ContainsKey($entry.Name)))
            {
                $variable = $Cmdlet.SessionState.PSVariable.Get($entry.Key)
                
                if ($null -ne $variable)
                {
                    if ($SessionState -eq $ExecutionContext.SessionState)
                    {
                        Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force
                    }
                    else
                    {
                        $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                    }
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filtered')
        {
            foreach ($varName in $filterHash.Keys)
            {
                if (-not $vars.ContainsKey($varName))
                {
                    $variable = $Cmdlet.SessionState.PSVariable.Get($varName)
                
                    if ($null -ne $variable)
                    {
                        if ($SessionState -eq $ExecutionContext.SessionState)
                        {
                            Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force
                        }
                        else
                        {
                            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                        }
                    }
                }
            }
        }

    } # end

} # function Get-CallerPreference

Set-Alias -Name Write-Host -Value Write-HostLog
Set-Alias -Name Write-Verbose -Value Write-VerboseLog
Set-Alias -Name Write-Debug -Value Write-DebugLog
Set-Alias -Name Write-Warning -Value Write-WarningLog
#Set-Alias -Name Write-Error -Value Write-ErrorLog

Export-ModuleMember -Function 'Write-DebugLog','Write-ErrorLog','Write-WarningLog','Write-VerboseLog','Write-HostLog'
Export-ModuleMember -Variable 'LogFilePreference'
Export-ModuleMember -Alias '*'
