#requires -version 3.0

#demo PSSessions

#region Interactive PSSession

help Enter-PSSession -ShowWindow

enter-pssession chi-dc02 -Credential globomantics\administrator
hostname
whoami
get-process | sort ws -desc | select -first 3

#you get full objects
get-service | get-member
$X = 123
$p = get-process

exit

cls
#endregion

#region Creating PSSessions

#this is why we do it
enter-pssession chi-dc02 -Credential globomantics\administrator
$X
$p
exit

#create a single session
$dc02 = New-PSSession -ComputerName chi-dc02 -Credential globomantics\administrator
$dc02

#create multiple sessions
#no guarantee which computer will get which variable
$A,$B = New-PSSession CHI-DC01,CHI-DC04
$A
$B

#get PSSessions
Get-PSSession

#now I can do this
Enter-PSSession $b
$x = 123
$logs = get-eventlog -list
$X
exit
#go back in later
Enter-PSSession $b
$logs
$X
exit

#Show remote sessions in the ISE

cls
#endregion

#region Using Invoke-Command with PSSessions

invoke-command { dir c:\windows\ntds\ntds.dit} -session $a

#or do it for all
invoke-command { dir c:\windows\ntds\ntds.dit} -session (get-pssession) | gm

#get all sessions
$all = Get-PSSession

$logs = invoke-command { 
get-eventlog "Directory Service" -EntryType Error,Warning `
-After (Get-Date).AddHours(-48)
} -session $all

#data is deserialized
$logs | Get-Member

$logs

#might need to format the results
$logs | Sort PSComputername,TimeGenerated |
Select PSComputername,TimeGenerated,Source,Category,EntryType,EventID,Message |
Out-Gridview -Title "Directory Service Problems"

#sessions can be re-used as often as needed, maintaining their state
icm {mkdir c:\reports} -session $all

icm {1..12 | foreach {mkdir (join-path c:\reports $_)}} -session $all

icm {dir c:\reports\} -session $A

#icm {rmdir c:\reports -Recurse} -session $all

cls

#endregion

#region removing pssessions
remove-pssession $dc02

get-pssession | remove-pssession -whatif

get-pssession | remove-pssession

#sessions are gone but variable remains
$a

#endregion
