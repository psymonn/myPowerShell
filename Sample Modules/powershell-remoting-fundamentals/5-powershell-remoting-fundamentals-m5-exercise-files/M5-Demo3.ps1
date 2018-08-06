#region using jobs

#local job
help icm -Parameter asjob

new-pssession -ComputerName "chi-core01","chi-core02","chi-web02","chi-fp02","chi-hvr2"

#get all PSSessions
$all = get-pssession
$all.count

icm { get-hotfix } -session $all -AsJob | tee -Variable hot
$hot
$hot.ChildJobs

wait-job $hot

$data = receive-job $hot -Keep
$data.count
$data | select -first 3
$data | group pscomputername

cls

#remote job
#must have a PSSession
$sb  = { Start-job  { get-eventlog system -EntryType error  } -Name SysErr }
icm $sb -Session $all

#loop until all jobs have finished running
do { start-sleep -Milliseconds 10 } while ( icm { get-job -State Running } -session $all )

icm { get-job SysErr } -session $all[0]
icm { get-job SysErr } -session $all

cls

#endregion
