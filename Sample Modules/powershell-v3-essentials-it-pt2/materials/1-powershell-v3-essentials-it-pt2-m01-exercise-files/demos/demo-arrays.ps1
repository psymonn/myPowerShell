#requires -version 3.0

#demo arrays 
#region array usage and language

$a=1..10
$a
#how many?
$a.count
#access by index number
$a[0]
$a[1..3]
$a[-1]
#arrays of objects
$b = get-service s*
$b[0]
$b[1]
#treat it as an object
$b[0].DisplayName
#in v2 we would need this to select a single property
$b | Select Displayname
$b | Select Displayname | gm
$b | Select -expand Displayname
#now we can do this
$b.displayname
#arrays can contain different objects
#any comma separated list is an array
$c=1,"b",3,$PSVersionTable,(get-process w*)
$c.count
$c[3].PSVersion
#even arrays of arrays
$c[-1]
$c[-1][0]

#create an empty array
$d=@()

#add to it
$d+=100
$d+=200
$d+=300
$d+=1,3,5,7,9
$d

#these will fail
$d-=9
$d-=$d[-1]

#best way to remove items is to filter 
#out the ones you don't want
$d = $d | where {$_ -ge 100}
$d
#endregion

#region practical examples

#these examples can all be done interactively in the console
#an array of domain controller names
$dcs = "CHI-DC01","CHI-DC02","CHI-DC03"
$services = "wuauserv","winmgmt"

#get-service parameters can accept arrays
get-help get-service -Parameter *name

#use the arrays as parameter values
get-service -Name $services -computername $dcs | 
Select Name,Displayname,Status,Machinename

#or use an array for a simple ping test
help Test-Connection -Parameter computername
$computers = $dcs, "CHI-DB01","CHI-EX01", 
$computers | where { (Test-Connection $_ -quiet -Count 1)}

#endregion
