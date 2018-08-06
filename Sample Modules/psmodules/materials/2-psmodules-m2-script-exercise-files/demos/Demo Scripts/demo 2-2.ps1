#
# Demo 2-2
# A complex script module
#
# Move to M2 folder
cd $mod\m2
#
# Look at m2 module
cat m2.psm1
cls
# import the module
Import-module m2 -verbose
# Use the exports - first the function
Get-Greeting
#  now the alias
hw
# and the variable
$hw
cls
# Look at module
Get-module M2 | Format-List definition, onremove
# now remore the module
Remove-Module m2