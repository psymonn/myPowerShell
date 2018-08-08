Push-Location
Import-Module SQLPS -DisableNameChecking -WarningAction SilentlyContinue | Out-Null
Pop-Location

. $PSScriptRoot\function-Test-PodcastDatabase.ps1
. $PSScriptRoot\function-New-PodcastDatabase.ps1
. $PSScriptRoot\function-Test-PodcastTable.ps1
. $PSScriptRoot\function-New-PodcastTable.ps1
. $PSScriptRoot\function-Update-PodcastTable.ps1

Export-ModuleMember Test-PodcastDatabase
Export-ModuleMember New-PodcastDatabase
Export-ModuleMember Test-PodcastTable
Export-ModuleMember New-PodcastTable
Export-ModuleMember Update-PodcastTable

