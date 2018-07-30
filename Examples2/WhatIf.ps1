#region How NOT to implement "WhatIf"
function Remove-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[string[]]$Name,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$WhatIf
		
	)
	
	if ($WhatIf.IsPresent)
	{
		Write-Host "I would have removed that VM $Name" -ForegroundColor Cyan
	}
	else
	{
		Write-Host "I'm removing the VM $Name now" -ForegroundColor Green
	}
	
}

Remove-VirtualMachine -WhatIf
#endregion

#region SupportsShouldProcess
function Remove-VirtualMachine
{
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter()]
		[string[]]$Name
	)
	
	if ($PSCmdlet.ShouldProcess($Name))
	{
		Write-Host "Removing the VM $Name now"
	}
}

$WhatIfPreference
Remove-VirtualMachine -Name 'MYVM' -WhatIf
#endregion