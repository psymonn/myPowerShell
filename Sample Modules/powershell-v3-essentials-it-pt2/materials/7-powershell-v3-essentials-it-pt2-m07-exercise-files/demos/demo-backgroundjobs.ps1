#requires -version 3.0

#demonstrate PowerShell Background jobs

#region Creating Background jobs

    #region Using Start-Job
    help start-job

    #create a job and save the output to a variable
    $procjob = start-job {get-process}
    $procjob

    #define a name for the job
    start-job { Get-HotFix } -Name hf

    start-job { Param($path) dir $path -recurse -file | measure length -sum} -Name DirSize -ArgumentList $env:temp

    #endregion

    #region Using AsJob
    $csjob = get-wmiobject Win32_Computersystem -comp chi-dc01,chi-dc02,chi-dc04,chi-fp01 -AsJob
    $csjob
    
    #this job will intentionally have some problems
    $wsjob = Invoke-command {get-process | sort WS -desc | Select -first 5} -computername chi-fp01,chi-fp02,chi-dc01 -AsJob

    #endregion

cls
#endregion

#region Managing Jobs

    #region Getting Jobs
    help Get-Job
    Get-Job
    
    #get jobs by name or ID
    get-job dirsize

    #get childjobs
    $csjob | Get-Job -IncludeChildJob

    #the job is an object
    $procjob | select *

    #get jobs by state
    get-job -State Completed
   
    #endregion

    #region Wait job
    #start a job and give it 10 seconds to finish before moving on
    get-wmiobject win32_product -asjob | Wait-Job -Timeout 10
    get-job

    get-job -Newest 1 | Wait-Job

    #endregion

    #region Getting Job Results

    receive-job $procjob
    
    #I didn't keep results so they are gone
    receive-job $procjob

    $data = receive-job hf -keep

    $data 

    #job results are deserialized objects
    $data | get-member

    #use the job results like output from any other command
    $data | Sort Description | format-table -GroupBy Description HotfixID,Installed*

    #retrieve results from child jobs by using the parent
    receive-job $csjob -Keep

    receive-job $csjob -Keep | Select Name,TotalPhysicalmemory,NumberofProcessors

    #endregion

    #region Stop job

    start-job {1..10000 | foreach { $_ ;start-sleep -Seconds 5}} -Name Oops
    Get-job Oops

    #use -passthru to see the job object
    stop-job oops -PassThru

    #there may be job results
    receive-job Oops -Keep
    
    #endregion

    #region Troubleshooting
    $wsjob

    #get results
    receive-job $wsjob -Keep | format-table -GroupBy PSComputername

    #see failed childjobs
    $wsjob | get-job -ChildJobState Failed

    #skip the parent
    $wsjob | get-job -ChildJobState Failed | select -Skip 1 | Select -ExpandProperty JobStateInfo | select -expand Reason

    #or you can simplify 
    ($wsjob | get-job -ChildJobState Failed | select -last 1).JobStateInfo.Reason

    #endregion

    #region Removing jobs

    #remove a single job    
    remove-job hf

    get-job -State Failed | Remove-Job
    get-job

    #remove all jobs
    get-job | remove-job

    #endregion

    cls
#endregion

#region Remote Jobs

#create pssessions
$sess = new-pssession chi-dc01,chi-dc02,chi-dc04

#start the job on the remote computers
Invoke-Command { start-job {get-eventlog "Directory Service" -Newest 10 -EntryType Error,Warning}} -session $sess

#nothing is local
Get-Job

icm {get-job} -session $sess

#get the results from the remote computers
$dcdata = icm {get-job | receive-job -Keep} -session $sess
$dcdata

$dcdata | Select Machinename,TimeGenerated,EventID,Source,Category,EntryType,Message | Out-GridView

#remote job will go away when I end the session
$sess | Remove-PSSession

cls

#endregion
