$module = Get-Module -Name MyModule

$module.AccessMode

$module.AccessMode = 'ReadOnly'
Remove-Module MyModule

$module.AccessMode = 'Constant'
Remove-Module MyModule