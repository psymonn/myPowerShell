#region Notice the ModuleType is a Script module with little to no information
$module = Get-Module -ListAvailable -Name MyModule
$module | Select *
#endregion

#region Find the folder to create the manifest in
$modulePath = $module.ModuleBase
$modulePath
#endregion

#region Review New-ModuleManifest

## Even though the manifest can be created from scratch I always recommend
## creating a template from New-ModuleManifest and modifying that one.

## Get an idea on the attributes you can use
(Get-Help New-ModuleManifest).Parameters.Parameter.Name

#endregion

#region Create a basic manifest --my minimum recommendations
$params = @{
	'Author' = 'Adam Bertram'
	'CompanyName' = 'Adam the Automator, LLC.'
	'Description' = 'This is a module that does this and that. It was designed to solve some problem.'
    'NestedModules' = 'MyModule' ## This is required to expose functions in a manifest module
	'Path' = "$modulePath\MyModule.psd1" ## Use the same name as the module with a PSD1 extension
}

New-ModuleManifest @params
#endregion

#region Verifying manifest behavior
Get-Module -ListAvailable -Name MyModule | select *
#endregion

#region Review the manifest and add an optional attribute
ise "$modulePath\MyModule.psd1"

PrivateData = @{
	PSData = @{
		Tags = 'Pluralsight','ModuleTraining' ## For the PowerShell Gallery
		ProjectUri = 'https://github.com/adbertram/PluralsightModuleTraining'
	}
}

(Get-Module -Name MyModule -ListAvailable).PrivateData['PSData']
#endregion
