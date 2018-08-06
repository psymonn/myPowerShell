#region Demo setup
$demoFolder = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\building-advanced-powershell-functions-and-modules\building-advanced-powershell-functions-and-modules-m7\Demos\XML Help\Module Help'
$module = Get-Module -Name MyModule
del "$($module.ModuleBase)\en-US" -ea SilentlyContinue -Recurse
#endregion

#region Setup
## No tricks up my sleeve --module with just a couple standard functions
## Import or reimport the module if it's currently loaded
Import-Module -Name MyModule -Force
$module = Get-Module -Name MyModule
$module
ise (Join-Path -Path $module.ModuleBase -ChildPath 'MyModule.psm1')

## The XML (in the demo folder for now) named modulehelp.xml (remember this name)
$moduleXml = "$demoFolder\modulehelp.xml"
ise $moduleXml
#endregion

## Only the module in the module folder
Get-ChildItem -Path $module.ModuleBase

#region Language folder

## The XML file needs to go in a language-specific subfolder with a specific name.
## See what options you have for the language folder
([System.Globalization.Cultureinfo]::GetCultures('AllCultures')).Name

## Create the folder --we're using English
$languageFolder = mkdir "$($module.ModuleBase)\en-US"
$languageFolder

## Copy our prebuilt XML file into the language folder
copy $moduleXml $languageFolder
ls $languageFolder
#endregion

#region No help with a script module unless using .EXTERNALHELP

#region Why no help?
## Reload the session and import the module again.
Import-Module -Name MyModule -Force

## Check to see if the help content is available for both functions in the module
## Why no help even though the XML file is in the language folder??
Get-Help -Name Get-VirtualMachine
Get-Help -Name New-VirtualMachine
#endregion

#region Adding .EXTERNALHELP

## Add .EXTERNALHELP to functions just like we did with the function-level XML help
<#
    # .EXTERNALHELP modulehelp.xml
#>

## Reload the session and import the module again.
Import-Module -Name MyModule -Force

## Check to see if the help content is available for both functions in the module now
Get-Help -Name Get-VirtualMachine
Get-Help -Name New-VirtualMachine
#endregion

#region Right XML file name but still a script module
Rename-Item "$($module.ModuleBase)\en-US\modulehelp.xml" MyModule.psm1-help.xml
Get-Item "$($module.ModuleBase)\en-US\MyModule.psm1-help.xml"

## Remove the .EXTERNALHELP references

## Ensure EXTERNALHELP references are gone
ise "$((Get-Module -Name MyModule -ListAvailable).ModuleBase)\MyModule.psm1"

## Import or reimport the module if it's currently loaded
Import-Module -Name MyModule -Force

## Check to see if the help content is available for both functions in the module
## Why still no help with no EXTERNALHELP references?  It's not a manifest module
Get-Help -Name Get-VirtualMachine
Get-Help -Name New-VirtualMachine

#endregion

#endregion

#region XML help as a manifest module

## Build a manifest and put it in the module folder
$params = @{
	'Author' = 'Adam Bertram'
	'CompanyName' = 'Adam the Automator, LLC.'
	'Description' = 'This is a module that does this and that. It was designed to solve some problem.'
	'NestedModules' = 'MyModule' ## This is required to expose functions in a manifest module
	'Path' = "$((Get-Module MyModule).ModuleBase)\MyModule.psd1" ## Use the same name as the module with a PSD1 extension
}
New-ModuleManifest @params

## Module and manifest now exist
Get-ChildItem -Path (Get-Module MyModule).ModuleBase

## Reimport the module
Import-Module MyModule -Force

## Ensure the module type is Manifest now
(Get-Module MyModule).ModuleType

## Ensure no .EXTERNALHELP references
ise "$((Get-Module MyModule).ModuleBase)\MyModule.psm1"

## Import or reimport the module if it's currently loaded
Import-Module -Name MyModule -Force

## Check to see if the help content is available for both functions in the module
Get-Help -Name Get-VirtualMachine
Get-Help -Name New-VirtualMachine

## No .EXTERNALHELP references
ise "$((Get-Module MyModule).ModuleBase)\MyModule.psm1"

#endregion
