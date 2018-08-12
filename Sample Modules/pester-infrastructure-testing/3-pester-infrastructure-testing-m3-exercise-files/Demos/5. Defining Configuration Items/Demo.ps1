#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\7. Defining Configuration Items'
#endregion

## Show our JSON configuration file with no values; just categories

ise "$demoPath\ConfigurationItems.json"

## First define values going into the configuration JSON
<#
    1. What is the "static" data?
    2. What could potentially change in the script?

    These are configuration items,
#>

## Open George's script to track down these items
ise "$demoPath\New-TestEnvironment.ps1"

## Paste values here temporarily just to keep rough track of them



######

## Add values to configuration JSON

## Verify values show up by querying JSON with PowerShell and converting to an object
$json = Get-Content "$demoPath\ConfigurationItems.json" -Raw | ConvertFrom-Json