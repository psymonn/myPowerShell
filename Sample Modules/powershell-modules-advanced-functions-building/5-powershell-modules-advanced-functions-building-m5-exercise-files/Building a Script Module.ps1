## Create the module folder
$modulesFolder = $env:PSModulePath.Split(';')[0]
mkdir "$modulesFolder\MyModule"

## Create a blank PSM1 file
$moduleFile = New-Item -Path "$modulesFolder\MyModule\MyModule.psm1"

## Add functions to the module
ise $moduleFile.FullName