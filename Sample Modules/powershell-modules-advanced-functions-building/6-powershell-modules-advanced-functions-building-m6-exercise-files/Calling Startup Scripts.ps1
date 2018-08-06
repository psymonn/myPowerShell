$module = Get-Module -ListAvailable -Name MyModule
ise $module.Path

#region Use the FileList attribute to check for files before loading module
$module.FileList

## Create a script called Startup.ps1. This will be "dot-sourced" into your session
New-Item "$($module.ModuleBase)\Startup.ps1" -ItemType File

ise "$($module.ModuleBase)\Startup.ps1"
<#
$requiredFiles = (Get-Module MyModule -ListAvailable).FileList
$requiredFiles | foreach {
    if (-not (Test-Path -Path $_ -PathType Leaf)) {
        Write-Warning "The file [$($_)] does not exist and is required for this module."       
    } 
}
#>

Import-Module MyModule

#endregion