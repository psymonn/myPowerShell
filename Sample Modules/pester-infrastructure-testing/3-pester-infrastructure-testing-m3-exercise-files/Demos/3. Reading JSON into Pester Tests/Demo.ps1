#region Demo stuff

$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\3. Reading JSON into Pester Tests'
$previousdemoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\2. Building the Pester Test Template'

& "$demoPath\Demo.ahk"

#endregion

## JSON file we created
ise "$demoPath\ConfigurationItems.json"

## Pester test template created earlier

ise "$demoPath\New-TestEnvironment.Tests.ps1"

## Run the example Pester test reading JSON values
Invoke-Pester "$demoPath\New-TestEnvironment.Tests.ps1"