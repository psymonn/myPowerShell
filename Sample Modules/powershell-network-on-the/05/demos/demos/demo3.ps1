#region methods

#using another accelerator
$c = [wmiclass]"win32_share"
$c.methods

#But you can't go by this
#use MSDN documentation for the class
start http://bit.ly/CreateWin32_Share

#Path,Name,Type [0=disk,1=print],maxallowed,description,password,access
#this must be run in an elevated session
$c.Create("c:\work","work",0,$null,"my demo share")

$work = get-wmiobject win32_share -filter "name = 'work'"
$work
$work | get-member -MemberType Method
$work.Delete()

cls

help Invoke-WmiMethod
cls
#need different parameter order
$c.GetMethodParameters("Create")
#argumentlist is in order of method parameters
Invoke-WmiMethod -Class win32_share -Name Create -ArgumentList @($null,"My work files",$null,"Work",$null,"c:\work",0) 

Get-WmiObject win32_share
#need an instance of the object
Get-WmiObject win32_share -filter "name='work'" | 
Invoke-WmiMethod -Name Delete

cls
#endregion

