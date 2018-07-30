#region can use multiple sessions

$dcs = New-PSSession -ComputerName chi-dc01,chi-dc02,chi-dc04 -Credential globomantics\administrator
$dcs

Get-PSSession

icm {get-service adws,dns,kdc } -session $dcs | Sort Status

#check AD database file
icm { dir $env:windir\ntds\ntds.dit } -session $dcs

cls

#endregion