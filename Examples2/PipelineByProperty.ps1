function Get-VirtualMachine
{
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory)]
		[string]$Name
	)
	[pscustomobject]@{ 'VMName' = $Name; 'HyperVHost' = 'HYPERV1' }
}

function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName)]
        [Alias('VMName')]
		[string]$Name,
		
		[Parameter(ValueFromPipelineByPropertyName)]
		[string]$HyperVHost
	)
	Write-Host "I'll now do something on the VM [$($Name)] which is on the Hyper-V host [$($HyperVHost)]"
}

Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine -Verbose