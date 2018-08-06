#region Invoke-Command

#I'm logged in with an account that has remote admin access

help invoke-command
cls

$r = Invoke-Command -scriptblock {
 get-item HKLM:\SYSTEM\CurrentControlSet\Control\BitlockerStatus
} -ComputerName srv1
$r

$r | Get-Member

Invoke-Command -scriptblock {
 Get-process | Sort WS -Descending | Select -first 5
} -ComputerName srv1,srv2,dom1 -Credential company\administrator

#be careful
Invoke-Command {$x=123} -ComputerName srv1
Invoke-Command {$x+$x} -ComputerName srv1

cls
#endregion

