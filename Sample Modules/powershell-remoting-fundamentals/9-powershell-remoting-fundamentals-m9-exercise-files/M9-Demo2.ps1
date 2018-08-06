#demo disconnected sessions

#open a new PowerShell session
Get-PSSession -ComputerName chi-core01
$s = Connect-PSSession -ComputerName chi-core01 
$s

#if busy might need to receive the session
Receive-PSSession -Session $s | 
Select * -ExcludeProperty PSComputername,RunspaceID |
tee -Variable logdata

$s

$logdata | format-table -AutoSize

cls

get-pssession -ComputerName chi-dc04 -Name NewUsers
#receive session and save output to a local job
$j = Receive-PSSession -ComputerName chi-dc04 -Name NewUsers -OutTarget Job

Wait-job $j

$users = Receive-job $j -Keep
$users.count

#where were they created?
$users | Group {$_.DistinguishedName.split(",",2)[1]} -NoElement

Get-PSSession | Remove-PSSession

cls

