#region using PSSessions
help New-PSSession
cls
#You can also use alternate credentials with -Credential company\administrator
$sessions = New-PSSession -ComputerName srv1,srv2,dom1 
$sessions

Get-PSSession

#remember the issue with disappearing stuff?
$s1 = get-pssession | where computerName -eq srv1
$s1
Invoke-Command {$x=123} -session $s1
Invoke-Command {$x+$x} -session $s1
cls

#this command runs on all remote computers at once
Invoke-Command { get-service bits } -session $sessions

#your scriptblock can be as complicated as it needs to be.
$sb = {
$fso = new-object -com scripting.filesystemobject
$fso.drives | where drivetype -eq 2 | Select Path,
@{Name="SizeGB";Expression={$_.TotalSize/1GB -as [int]}},
@{Name="FreeGB";Expression={$_.FreeSpace/1GB}},
@{Name="AvailGB";Expression={$_.AvailableSpace/1GB}},
@{Name="Computername";Expression = {$env:computername}}
}

Invoke-command -scriptblock $sb -Session $sessions
#clean up the output

Invoke-command -scriptblock $sb -Session $sessions -HideComputerName |
select * -ExcludeProperty runspaceid

cls
#you can also run a script from your machine
ise c:\scripts\fsoreport.ps1

#let's splat a hashtable of parameter values
$params = @{
FilePath = "c:\scripts\fsoreport.ps1"
argumentlist = @("C:","MB")
session = $sessions 
HideComputerName  = $true
}

#hide computername and runspace id
$report = invoke-command @params | Select * -ExcludeProperty run*
$report
$report[0].rootfiles
$report | export-clixml c:\work\creport.xml
#endregion

#region cleanup

#sessions go away when PowerShell stops
$sessions | Remove-PSSession

cls
#endregion