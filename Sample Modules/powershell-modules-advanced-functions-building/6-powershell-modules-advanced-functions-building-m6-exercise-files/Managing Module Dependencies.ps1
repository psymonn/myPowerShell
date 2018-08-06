## Use an existing manifest and build upon it
$module = Get-Module -ListAvailable -Name MyModule
ise $module.Path

## No FileList entries and only itself as NestedModules
$module | select nestedmodules,filelist

#region NestedModules --builtin dependency

## Create some blank modules
New-Item -Path "$($module.ModuleBase)\NestedModule1.psm1"
New-Item -Path "$($module.ModuleBase)\NestedModule2.psm1"

## add a function to each module
ise "$($module.ModuleBase)\NestedModule1.psm1"
ise "$($module.ModuleBase)\NestedModule2.psm1"

## Open the manifest and add the modules as NestedModules
ise $module.Path

## Nested modules are now associated with MyModule
Import-Module MyModule -Force -PassThru | select nestedmodules,filelist

## Functions in all modules show up as one
Get-Command -Module MyModule

#endregion

#region FileList --made for inventory-only purposes but can be used to enforce dependencies

## Add a TXT file to the manifest
New-Item -Path "$($module.ModuleBase)\mytextfile.txt"
ise $module.Path
$module = Import-Module MyModule -Force -PassThru
$module.FileList # currently just for inventorying

## Will show how to ensure these files exist when loading module later

#endregion
