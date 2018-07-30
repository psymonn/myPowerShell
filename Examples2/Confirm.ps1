#region Scenario #1: ConfirmImpact is Low and $ConfirmPreference is High: No confirmation

## Notice SupportsShouldProcess isn't necessary here. We're working on with ALL functions now.
function Remove-VirtualMachine
{
	[CmdletBinding(ConfirmImpact = 'Low')]
	param
	(
		[Parameter()]
		[string[]]$Name
	)
	
    if ($PSCmdlet.ShouldProcess($Name)) {
        Write-Host "Removing VM $Name..."
    }
}

$ConfirmPreference = 'High'
Remove-VirtualMachine -Name 'MYVM'

#endregion

#region Scenario #2: ConfirmImpact is a level higher than $ConfirmPreference: Automatic prompting

function Remove-VirtualMachine
{
	[CmdletBinding(ConfirmImpact = 'Medium')]
	param
	(
		[Parameter()]
		[string[]]$Name
	)
	
	if ($PSCmdlet.ShouldProcess($Name)) {
        Write-Host "Removing VM $Name..."
    }
}

$ConfirmPreference = 'Low'
Remove-VirtualMachine -Name 'MYVM'

#endregion

#region Scenario #3: All or nothing

## $ConfirmPreference could essentially make everything or nothing prompt depending on
## if that function's ConfirmImpact is higher or lower than $ConfirmPreference

## Auto prompting: No -Confirm Needed
$ConfirmPreference = 'Low'

New-Item -Path C:\test.txt -Type File

## but can still override the default behavior
New-Item -Path C:\test.txt -Type File -Confirm:$false

## Or go the other way: Have nothing prompt and only prompt on specific functions
$ConfirmPreference = 'None'
New-Item -Path C:\test2.txt -Type File

New-Item -Path C:\test3.txt -Type File -Confirm

#endregion

#region Overriding $ConfirmPreference

## No SupportsShouldProcess
function Remove-VirtualMachine
{
	[CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
	param
	(
		[Parameter()]
		[string[]]$Name
	)
	
	if ($PSCmdlet.ShouldProcess($Name)) {
        Write-Host "Removing VM $Name..."
    }
}

## This is an advanced function. I should have -Confirm support?
$ConfirmPreference = 'High'
Remove-VirtualMachine -Name 'MYVM' -Confirm
#endregion