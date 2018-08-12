$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\1. Creating the Configuration Item JSON'

<# 
	Define categories to place potential configuration items in. This may not be the final JSON structure.
	What are each of the broad categories of items that the script should change?
	They are:
		VirtualMachine for Hyper-V related things
		ActiveDirectory for all AD objects (we'll need sub-categories too)
		OperatingSystem for all of the OS-specific related stuff
		CSVFile to place tests on the CSV file's structure and data
#>

## First create the JSON file

## Now that the JSON is created, we can easily reference this with PowerShell
$rawJsonString = Get-Content -Path "$demoPath\ConfigurationItems.json" -Raw
$configItems = $rawJsonString | ConvertFrom-Json

## It's now just a pscustomobject
$configItems | Get-Member

## We can now enumerate each category and items within
$configItems.ConfigurationItems
$configItems.ConfigurationItems.ActiveDirectory
$configItems.ConfigurationItems.CSVFile