# Let's look at where our personal modules are stored.

$env:PSModulePath

# Create the folder for MyModule

# Get-Help about_Split
# Get-Help Test-Path

$modulePath = ($env:PSModulePath -split ";")[0]
$myModulePath = "$modulePath\MyModule"

if (!(Test-Path $myModulePath)) {
    md $myModulePath | Out-Null # We don't need to create them individually
}

# Create a PSM1 file

New-ModuleManifest "$myModulePath\MyModule.psd1" -Author "Cody Konior" -RootModule "MyModule.psm1"
&notepad "$myModulePath\MyModule.psd1"

# This one just loads all the other functions

Set-Content "$myModulePath\MyModule.psm1" 'Get-ChildItem -Path $PSScriptRoot\*.ps1 | %{ . $_.FullName }'
&notepad "$myModulePath\MyModule.psm1"

Set-Content "$myModulePath\Test-MyModule.ps1" 'function Test-MyModule { Write-Host "Yes, it loaded ok!" }'
Import-Module MyModule -Force # -Force is important
Test-MyModule

Get-Help Test-MyModule
Copy-Item "$env:USERPROFILE\Desktop\Test-MyModule.ps1" "$myModulePath"
&notepad "$myModulePath\Test-MyModule.ps1"

Import-Module MyModule -Force
Get-Help Test-MyModule -Full

# Get-Help Set-ExecutionPolicy

Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# Profiles

$profile

Get-Content $profile

if (!(Test-Path (Split-Path $profile))) {
    md (Split-Path $profile)
}

Set-Content $profile @"
Set-StrictMode -Version Latest
Import-Module MyModule -Force
"@
# Load a new session

## Next slide
