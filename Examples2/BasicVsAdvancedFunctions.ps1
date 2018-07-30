#region Basic functions
function Get-SomethingBasic
{
	param (
		[string]$Param
	)
	Write-Host $Param
}

## Just takes an input and gives an output
Get-SomethingBasic -Param 'This is my param'

#endregion

#region Advanced function

## Create a basic function to use to send to our advanced function
get

function Get-SomethingAdvanced
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,ValueFromPipeline)]
		[ValidateSet('This','That')]
		[string]$Param
	)
	Write-Host $Param
}

## I forgot to use the parameter
Get-SomethingAdvanced

## Pipeline input --no workie  Doesn't meet specs
Get-SomethingBasicPipeline | Get-SomethingAdvanced

## Yay! now it works
Get-SomethingBasicPipeline | Get-SomethingAdvanced

#endregion