#demo disconnected sessions

#using options and multiple computers
#4 hours idle timeout
$psopt = New-PSSessionOption -IdleTimeout (60*60*4*1000)
$sess = New-PSSession -computername chi-fp02,chi-web02,chi-core01,chi-core02 -SessionOption $psopt 

$sess

#run remote command as a job
invoke-command –scriptblock { get-wmiobject win32_SystemDriver –asjob } -Session $sess  
disconnect-pssession $sess 

cls

$sess | Connect-PSSession

icm { get-job } -session $sess

$r = icm { get-job | receive-job -keep } -session $sess
$r.count

#look at properties
$r[0] | select *

$r | where { $_.name -eq 'dedup'}

#using v4 Where method is faster

($r).where({$_.pscomputername -eq 'chi-core02' -AND $_.state -eq 'running'}) | 
Sort Displayname | 
select Displayname,PathName

#close sessions
Get-PSSession | Remove-PSSession

cls
