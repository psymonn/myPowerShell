function Get-VirtualMachine
{
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSCustomObject])]
	param
	(
		[Parameter()]
		[string]$Name
	)
	0..10 | foreach {
		[pscustomobject]@{ 'Name' = "VM$PSItem"; 'HyperVHost' = 'HYPERV1' }
	}
}

## No begin/process/end blocks
function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[pscustomobject]$InputObject
	)
    begin {
        
    }
	process {
	    function Add-VmToFile
	    {
		    param ($Name)
		    Write-Verbose -Message "Adding the VM name [$($Name)] to the file"
		    Add-Content -Path C:\VMNames.txt -Value $Name
	    }
	 
	    New-Item -Path C:\VMNames.txt -Type File

	    Add-VmToFile -Name $InputObject.Name
    }
}

function Set-VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[pscustomobject]$InputObject
	)
	begin
	{
		## $ErrorActionPreference will apply across ALL pipeline objects if only set once
		$ErrorActionPreference = 'Stop'
		
		## "Helper" functions are commonly placed in the begin block because they need loaded into memory once
		function Add-VmToFile
		{
			param ($Name)
			#Write-Verbose -Message "Adding the VM name [$($Name)] to the file"
			Add-Content -Path C:\VMNames.txt -Value $Name
		}
		
		## Maybe you need to work with a file temporarily for all objects in this function. Create one at the start
		#New-Item -Path C:\VMNames.txt -Type File
		
		#Write-Verbose -Message 'Beginning to process pipeline objects with Get-VirtualMachine'
        
	}
	process
	{
		#Write-Verbose -Message "Processing pipeline object representing VM [$($InputObject.Name)]..."
		#Add-VmToFile -Name $InputObject.Name
        
        
	}
	end
	{
        $input
		## Common uses: 
		## 		Removing PowerShell sessions to be used for all pipeline objects
		##		Removing temporary files
		##		Closing database connections
		
		#Write-Verbose -Message 'The function Get-VirtualMachine has completed processing all pipeline objects'
	}
}

<#
---Steps---

1. Run Get-VirtualMachine to get a bunch of VM names
2. Create a text file to hold these VM names.
3. Add each of the VM names output by Get-VirtualMachine into the text file

#>

## Get-VirtualMachine outputs 10 objects of type System.Management.Automation.PSCustomObject
Get-VirtualMachine

## Demo begin/process/end blocks
Get-VirtualMachine | Set-VirtualMachine -Verbose

# $input