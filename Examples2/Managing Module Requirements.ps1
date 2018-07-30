## Use an existing manifest and build upon it
$module = Get-Module -Name MyModule -ListAvailable
ise $module.Path

## Enforcing the version of PowerShell --good for scripts that you only test on specific versions
PowerShellVersion = '5.0'
Import-Module MyModule -Force

## To ensure your module only runs in the console (not in the ISE)
PowerShellHostName = 'ConsoleHost'
Import-Module MyModule -Force

## To ensure your module only runs on a specific architecture
ProcessorArchitecture = 'X86'
Import-Module MyModule -Force