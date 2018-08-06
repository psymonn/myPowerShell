function New-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[string[]]$Name,
		
		[Parameter()]
		[int64]$MemoryStartupBytes = 2GB,
		
		[Parameter()]
		[int]$Generation = 2,
		
		[Parameter()]
		[string]$Path = 'C:\somebogusfolder',
		
		[Parameter()]
		[string]$OperatingSystem
	)	
	Write-Host "It looks like you want to create a $Generation generation VM calld $Name with $MemoryStartupBytes of memory at $Path with OS of $OperatingSystem"	
}

New-VirtualMachine -Name '%#joj@@@' -MemoryStartupBytes 4799999GB -Generation 443 -Path $services -OperatingSystem 'AdamOS'