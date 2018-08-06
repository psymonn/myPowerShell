function Get-VirtualMachine
{
	<#
	.SYNOPSIS
		A brief description of the function or script. This keyword can be used
		only once in each topic.
	
	.DESCRIPTION
		A detailed description of the function or script. This keyword can be
		used only once in each topic.
	
	.PARAMETER Name
		The description of a parameter. Add a .PARAMETER keyword for
		each parameter in the function or script syntax.
		
		Type the parameter name on the same line as the .PARAMETER keyword.
		Type the parameter description on the lines following the .PARAMETER
		keyword. Windows PowerShell interprets all text between the .PARAMETER
		line and the next keyword or the end of the comment block as part of
		the parameter description. The description can include paragraph breaks.
		
		The Parameter keywords can appear in any order in the comment block, but
		the function or script syntax determines the order in which the parameters
		(and their descriptions) appear in help topic. To change the order,
										change the syntax.
		
		You can also specify a parameter description by placing a comment in the
		function or script syntax immediately before the parameter variable name.
		If you use both a syntax comment and a Parameter keyword, the description
		associated with the Parameter keyword is used, and the syntax comment is
		ignored.
	
	.EXAMPLE
		PS> Get-VirtualMachine -Name 'MYVM'
		
		This example retrieves the virtual machine with the name of MYVM from whatever virtualization system
		it's supposed to work with.
	
	.INPUTS
		None.
	
	.OUTPUTS
		System.Management.Automation.PSCustomObject
	
	.NOTES
		Requirements: This requires
	
	.LINK
		http://www.google.com
	
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)
	[pscustomobject]@{}
}

Get-Help Get-VirtualMachine
get-help Get-VirtualMachine -Parameter Name
Get-Help Get-VirtualMachine -Examples
Get-Help Get-VirtualMachine -Online