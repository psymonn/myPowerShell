$module = Get-Module -ListAvailable -Name MyModule
$manifestPath = $module.Path

## Check out the module now
ise "$($module.ModuleBase)\MyModule.psm1"

## Only show Get functions in the module
ise $manifestPath
<#
FunctionsToExport = 'Get-*'
#>

## Reload the module
$module = Import-Module -Name MyModule -Force -PassThru
$module.ExportedFunctions