#
# Demo 2-1
# A simple script module
#
cd e:\foo
ls m2.ps1
cat m2.ps1
cls
# So dot-source the function file and use the function
. .\m2.ps1
dir function:get-greeting
Get-Greeting
Remove-Item function:get-greeting
dir function:Get-*
cls
Get-Greeting
# now look at function
cd $mod\m2
cat m2.psm1
Get-Greeting
Import-Module m2 -force -verbose
Get-command Get-Greeting
Get-module m2
Remove-module m2
dir function:get*
# done