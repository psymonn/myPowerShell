Find-module psscriptanalyzer -AllVersions
get-command -module psscriptanalyzer
find-module psscriptanalyzer -minimumversion 1.11
find-module psscriptanalyzer -maximumversion 1.11
find-module psscriptanalyzer -maximumversion 1.20

Find-module -requiredversion 1.16 -name psscriptanalyzer | install-module
Remove-module psscriptanalyzer 
Get-command -module psscriptanalyzer 
Find-module -requiredversion 1.11 -name psscriptanalyzer | 
    save-module -path C:\Users\Administrator.company\documents\windowspowershell\modules | install-module

Find-module -requiredVersion 1.13 -name psscriptanalyzer | install-module
import-module -requiredversion 1.13.0 
get-command -module psscriptanalyzer

Remove-module psscriptanalyzer
Import-module -FullyQualifiedName @{ModuleName = ‘psscriptanalyzer’;RequiredVersion = ‘1.13.0’}
Get-command -module PSSCriptanalyzer

Remove-module psscriptanalyzer
Import-module -FullyQualifiedName @{ModuleName = ‘psscriptanalyzer’;ModuleVersion = ‘1.13.0’}
Get-command -module PSSCriptanalyzer

Ise .\test-directive.ps1
Remove-module psscriptanalyzer
.\test-directive.ps1

Test-ModuleManifest -path 'C:\Program Files\WindowsPowershell\Modules\PSScriptAnalyzer\1.13.0\PSScriptAnalyzer.psd1' 
