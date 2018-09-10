
# File Test.ps1:
Import-Module -Name .\TestModule.psm1 -Force

$VerbosePreference = 'continue'

Write-Host "Global VerbosePreference: $global:VerbosePreference"
Write-Host "TestModules.ps1 Script VerbosePreference: $script:VerbosePreference"

Test-ScriptModuleFunction

