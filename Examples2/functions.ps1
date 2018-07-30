function Get-VirtualMachine
{	
    # .EXTERNALHELP demofunction-help.xml
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)
}

function New-VirtualMachine
{
    # .EXTERNALHELP demofunction-help.xml
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)
}