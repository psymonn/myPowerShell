#  
#  Demo 3-3
#  Module manifests
#
#  Set location to m3
Set-Location $mod\m3
ls
#  
new-modulemanifest .\m3.psd1
cat .\m3.psd1 | more
cls
# Use Test-moduleManfest on empty manifest to show result
Test-ModuleManifest .\m3.psd1
cls
#
#
#  Now lets's look at a manifest module we created earlier
#
cd $mod\m4
ls
cat m4.psm1
cls
cat m4.psd1
cls
#
#
# Import and use the module
Import-Module M4 -Verbose
Test-ModuleManifest M4.psd1
Get-Greeting
#
# Check other exports
ExportMe
DoNotExportMe
cls
#
# Get-Module details
Get-Module M4| fl * | more
cls
# And finally remove the module
Remove-module M4
# END
