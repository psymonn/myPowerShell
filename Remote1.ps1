#remote to pvc-01 - pc -> send a remote request -> serialize -> de-seriliazed ->pc
get-eventlog -LogName security -Newest 10 -ComputerName pvc-01

Invoke-Command -ScriptBlock {Get-Process} -ComputerName pvc-01 | select name

$logname = read-host "enter name of log to retrive"
$quantity = read-host "How many recent entries to retrieve"
Invoke-Command -ComputerName pvc-01 -ScriptBlock {param ($x,$y) get-eventlog -LogName $x -Newest $y} -ArgumentList $logname, $quantity

Invoke-Command -ComputerName pvc-01 -ScriptBlock {get-eventlog -LogName $using:logname -Newest $using:quantity}

runas /user:redink\administrator "Powershell"

Get-PSSessionConfiguration

#-----------
#run that pc locally
Enter-PSSession -ComputerName pvc-01
Import-Module “C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll”

#trust relationship between domain
Enter-PSSession -ComputerName pvc-01 -Credential redink\administrator

#permanent session
$dc = New-PSSession -ComputerName redink-dc-01.redink.com -Credential redink\administrator
$pvs = New-PSSession -ComputerName pvc-01.redink.com
Get-PSSession
Invoke-Command -Session $dc,$pvs -ScriptBlock {Import-Module ActiveDirectory}
Import-PSSession -Session $dc -Prefix LAB -Module ActiveDirectory
#LAB is prefixed infront of the command this is like a proxy on this computer (it implicity remote into the AD server)
Get-LABADUser -Filter *
#functionally the same, expect this sent to the remote computer
Invoke-Command -ScriptBlock {Get-ADUser -Filter * } -Session $dc
#After execute this command you can run this seperately from LAB two different server
Import-PSSession -Session $pvc -Prefix REMOTE -Module ActiveDirectory
Get-PSSession | Remove-PSSession

$dc = New-PSSession -ComputerName redink-dc-01.redink.com
Invoke-Command -Session $dc -ScriptBlock {Get-ADUser -Filter *}
Import-PSSession -Session $dc -Prefix LAB -Module ActiveDirectory
#Get-LABADUser -filter * | Set-LABADUser  <-- Set is not here use the below
Set-LABADUser -Identity Me -Department IT

####new trick without using Import-Pssession #####

Get-Module -PSSession $dc -ListAvailable
#Dynamicly create proxy shortcut
Import-Module -Name NetAdapter -PSSession $dc -Prefix DC
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Get-Module
Import-Module NetAdapter
Get-Module
Get-NetAdapter|gm
Get-DCNetAdapter|gm
$dc | Remove-PSSession
#or
Get-PSSession | Remove-PSSession
#or
#Close the powershell prompt
#Remeber session are not share accross powershell
##Overall this above mehtod is implicit remoting...get the server to process instead of your pc

#use this if you have several of the same sessions but you can select the first one
New-PSSession -ComputerName pvc-01.redink.com
New-PSSession -ComputerName pvc-01.redink.com
Enter-PSSession -Session (Get-PSSession -ComputerName pvc-01 |select -First 1)

#------------
New-PSSession -ComputerName pvc-01.redink.com
Get-PSSession
#Disconnect the session
Get-PSSession | Disconnect-PSSession
#now close your powershell window
Get-PSSession -ComputerName pvc-01
#reconnect the session
Get-PSSession -ComputerName pvc-01 | Connect-PSSession
#close session
Get-PSSession | Remove-PSSession

