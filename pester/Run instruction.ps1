Install-Module Pester -RequireVersion 4.1.0 -SkipPublisherCheck
get-module pester -ListAvailable
Invoke-Pester -script .\Get-ServiceProperty.Tests.ps1
PS C:\DebuggingPowerShellVSCode\M5> Invoke-Pester  #this run all test that suffix with .Tests.ps1