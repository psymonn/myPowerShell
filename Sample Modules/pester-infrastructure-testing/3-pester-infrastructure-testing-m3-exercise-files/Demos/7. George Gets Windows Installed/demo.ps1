#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m3\Demos\7. George Gets Windows Installed'
#endregion

## Check out the AutoUnattend.xml file to automate OS installation
ise "$demoPath\AutoUnattend.xml"

## The small bit of PowerShell to get Windows installed. Everything is in the AutoUnattend.xml file.
## We're doing the minimum amount of work in AutoUnattend to get the VM to the point to where we can remote to it.

ise "$demoPath\New-TestEnvironment.ps1"