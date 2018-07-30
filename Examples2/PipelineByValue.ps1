function Get-VirtualMachine
{
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param
	(
		[Parameter(Mandatory)]
		[string]$Name
	)
	[pscustomobject]@{ 'Name' = $Name;  'HyperVHost' = 'HYPERV1' }
    1234
 
}

## 1 object
function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline)]
		[pscustomObject]$InputObject
	)
	process
	{
		Write-Host $InputObject.Name
		Write-Host '-------'
		Write-Host $InputObject.HyperVHost
		
	}
}

## 2 objects
function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline)]
		[pscustomobject]$Object1,
		
		[Parameter(ValueFromPipeline)]
		[System.IO.FileInfo]$Object2
	)
	process
	{
		Write-Verbose -Message "OBJECT1: Name is [$($Object1.Name)] -- HyperV host is [$($Object1.HyperVHost)]"
		Write-Verbose -Message "OBJECT2: Name is [$($Object2.Name)] -- HyperV host is [$($Object2.HyperVHost)]"
	}
}

## $Input
function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline)]
		[pscustomobject]$Object1
	)
	$Object1
}

## Verify outputs a custom object
Get-VirtualMachine -Name 'MYVM' | Get-Member

## pipeline behavior
Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine -Verbose

## parameter binding by type with 2 objects capable of pipeline input
Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine -Verbose

## choosy pipeline input by type -- coercion --change to pscustomobject
Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine -Verbose
Get-Item C:\autoexec.bat | Set-VirtualMachine -Verbose

## $Input
Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine

#region Break the pipeline

## Change the object type of $InputObject from something that Get-VirtualMachine does NOT output
Get-VirtualMachine -Name 'MYVM' | Set-VirtualMachine

#endregion