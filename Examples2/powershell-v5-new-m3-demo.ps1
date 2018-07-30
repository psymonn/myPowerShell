
#Do not run this as a script.  It is part of a demo.

get-command -module PackageManagement
Register-PackageSource -name chocolatey -ProviderName chocolatey -location http://chocolatey.org/api/v2
find-package -Source chocolatey -name *zip*
install-package -name 7zip -source chocolatey -force

get-command -module PowerShellGet
find-module -name PSScriptAnalyzer
Find-module -name PSScriptAnalyzer | save-module -path C:\PowerShell
Find-module -name PSScriptAnalyzer -requiredVersion 1.16.1 | install-module
Get-help publish-module