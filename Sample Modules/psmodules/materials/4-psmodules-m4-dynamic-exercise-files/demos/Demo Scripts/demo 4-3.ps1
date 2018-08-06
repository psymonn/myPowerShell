#
# Demo 4-3
# Modules as Objects
#
#
cd $mod\modasobj
ls
cls
#
#
# First, examine the manifrst
cat .\modasobj.psd1
cls
# now look at the script
cat .\modasobj.ps1
cls
#
# So import the module
Import-module modasobj -verbose -force
#
# Let's see what's there
Get-module mod*
cls
#
# Let's use this object
New-Person
New-Address
cls
#  Now a better use of this
$me            = new-person
$me.Name       = "Thomas Lee"
$me.Age        = "old enough to know beter, young enough to not care"
$me.Address    = "Deep in the English Countryside"
$me.NiNo       = 'none of your business'
$me.Occupation = 'Pluralsight author'
#
# Look at $me now
$me
cls
# Finally let's extend $me with a better address
$me.Address = new-address
$me
# Fill in the Blanks
$me.Address.House    = 'Jasmine Cottage'
$me.Address.Street   = 'Lower Road'
$me.Address.County   = 'Berkshire'
$me.Address.PostCode = 'Sl6 9HJ'
$me.Address.Country  = 'GB'
$me
# Look at just address
$me.address
# End of demo