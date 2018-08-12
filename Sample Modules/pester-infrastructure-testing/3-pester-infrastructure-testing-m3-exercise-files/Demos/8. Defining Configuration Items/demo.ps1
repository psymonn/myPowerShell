#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m3\Demos\8. Defining Configuration Items'
#endregion

## Review your autounattend.xml for all the values to test
ise "$demoPath\AutoUnattend.xml"

## Build those values into your main configuration item JSON file
ise "$demoPath\ConfigurationItems.json"