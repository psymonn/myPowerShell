function New-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[string]$VMName
	)
	
    switch ($VMName) {
        'SQLInjectAttackName' {
            Write-Error -Message "OMG! Someone's trying to H@x0r our base!"
        }

        'AlreadyExists' {
            Write-Warning -Message "You got a problem. This VM already exists so you can't add it, dummy"
        }

        'DoesNotExistAlready' {
            Write-Verbose -Message 'The VM does not already exist. You may proceed to add a new one with that name'
        }

        'FlakyIssue' {
            $ThatVariable = 'notright'
            Write-Debug -Message 'I will add this VM on host 123, blade 4564 on the molecule H2S squared'
        }
    }
}

#region During development

#region Testing error behavior

## Check what the $ErrorActionPreference variable is set at to see what kind of behavior to expect
$ErrorActionPreference

## A major error occurs!!
New-VirtualMachine -VMName 'SQLInjectAttackName'

## During debugging maybe I don't care for now if it throws an error. Override it in just this function
New-VirtualMachine -VMName 'SQLInjectAttackName' -ErrorAction SilentlyContinue

## I want to just shut up all error references except New-VirtualMachine
$ErrorActionPreference = 'SilentlyContinue'
New-VirtualMachine -VMName 'SQLInjectAttackName'
New-VirtualMachine -VMName 'SQLInjectAttackName' -ErrorAction Continue
#endregion

#region Testing warning behavior

## Exactly the same except to use Write-Warning instead of Write-Error and $WarningPreference

## Check what the global preference is set at
$WarningPreference
New-VirtualMachine -VMName 'AlreadyExists'

## Override it
New-VirtualMachine -VMName 'AlreadyExists' -WarningAction Stop

#endregion

#region Testing verbose behavior

## Check what the $VerbosePreference variable is set at to see what kind of behavior to expect
$VerbosePreference

## No VM exists but why no Verbose message?
New-VirtualMachine -VMName 'DoesNotExistAlready'

## Forgot -Verbose since $VerbosePreference defaults to SilentlyContinue
New-VirtualMachine -VMName 'DoesNotExistAlready' -Verbose

## Maybe I've got a ton of -Verbose references and I just want to see all of them
$VerbosePreference = 'Continue'
New-VirtualMachine -VMName 'DoesNotExistAlready'

#endregion

#region Testing debug behavior

## Nothing special
New-VirtualMachine -VMName 'FlakyIssue'

## Setting a breakpoint to further investigate the variable
New-VirtualMachine -VMName 'FlakyIssue' -Debug

#endregion

#endregion

#region During production we'll silence everything and instead, assign to a variable

$ErrorActionPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$DebugPreference = 'SilentlyContinue'

## A VM already exists so instead of confusing the user let's just log to fictional file instead
New-VirtualMachine -VMName 'AlreadyExists' -WarningVariable VMAlreadyExists
if ($VMAlreadyExists) {
    Add-Content -Path 'C:\Users\Administrator\Documents\somelogfile.log' -Value "WARNING: $VMAlreadyExists"
}

New-VirtualMachine -VMName 'SQLInjectAttackName' -ErrorVariable err
if ($err) {
    Add-Content -Path 'C:\Users\Administrator\Documents\somelogfile.log' -Value "ERR: $($err.Exception.Message)"
}

## Check out the log
Get-Content -Path 'C:\Users\Administrator\Documents\somelogfile.log'

#endregion