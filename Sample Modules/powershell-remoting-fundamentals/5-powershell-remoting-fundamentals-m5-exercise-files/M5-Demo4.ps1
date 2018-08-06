
#region managing results

#bring results back to local machine
$syserrs =  icm { receive-job syserr -Keep } -session $all
$syserrs.count
$syserrs[0] | select *

#process the results
$syserrs | Group Source -NoElement | Sort Count -Descending | Select -First 10

cls
#make the server do the work
measure-command { icm { get-windowsfeature } -session $all | where installed | select *Name }

measure-command { icm { get-windowsfeature | where installed | select *Name } -session $all }

cls
#we tried this earlier
icm {get-service adws,dns,kdc } -session $dcs | Sort Status

#filtering like this is after the fact
icm {get-service adws,dns,kdc } -session $dcs | where {$_.status -eq 'stopped'}

#filter earlier
icm {get-service adws,dns,kdc | Where {$_.status -ne "running" }} -session $dcs

#fix them
icm {get-service adws,dns,kdc | Where {$_.status -ne "running" } | start-service -PassThru } -session $dcs


#endregion

#region clean up

get-pssession | remove-pssession

cls

#endregion