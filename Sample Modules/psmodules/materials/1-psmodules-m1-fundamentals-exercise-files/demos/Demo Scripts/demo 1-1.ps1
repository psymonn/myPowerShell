#
# Demo 1-1
# Module handling
#
#  Show getting help on module cmdlets
Get-Command -noun Module 
cls
#
# And what's available?
Get-Module -ListAvailable
cls
#
#
# Show Autolaoding
Get-Module
Get-NetAdapter
Get-Greeting
Get-Module
cls
#
#
$env:PSModulePath
$env:PSModulePath.split(";")
$env:PSModulePath.split(";")[0]
$env:PSModulePath.split(";")[1]
# done