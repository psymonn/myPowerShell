#requires -version 3.0

<# 
Demonstrate scheduled jobs in PowerShell 3.0
 This must be run in an elevated session
 Don't confuse this with ScheduledTasks module in Windows 8
#>

# These commands are in the PSScheduledJob module.
# importing a module is optional in v3.
get-command -module PSScheduledJob

#region Define when to run the job
help new-jobTrigger

#$trigger = New-JobTrigger -Once -At (Get-Date).AddMinutes(30)
$trigger = New-JobTrigger -Daily -At "6:00 AM" 

# Let's see what we created
$trigger

#endregion

#region Define the scheduled job action

$action = { 
 get-eventlog system -EntryType Error,Warning -After (Get-Date).AddHours(-24)
 }

#endregion

#region define job options
help New-ScheduledJobOption -show

$opt = New-ScheduledJobOption -RunElevated 
$opt

#endregion

#region Register the job
help Register-ScheduledJob

# Define a name for the scheduled job to save typing
$name="Daily Event Log"

Register-ScheduledJob -Name $name -ScriptBlock $action -Trigger $trigger -ScheduledJobOption $opt

#let's create a second job as well in a oneline command using splatting

$computers = "chi-dc01","chi-dc02","chi-dc04","chi-fp01"

$jobParams = @{
 Name="DiskReport"
 Trigger = New-JobTrigger -DaysOfWeek Sunday -At "10:00 PM" -Weekly
 ScheduledJobOption = New-ScheduledJobOption -RunElevated -RequireNetwork
 FilePath = "C:\scripts\WeeklyDiskReport.ps1"
 ArgumentList = ,$computers
 }

Register-ScheduledJob @jobParams

#endregion

#region Review the job

Get-ScheduledJob -Name $name

# Define a variable for the job path so we don't have to retype
$jobpath= "$env:LocalAppData\Microsoft\Windows\PowerShell\ScheduledJobs"
dir $jobpath -recurse

# show the job in Task Scheduler Microsoft\Windows\PowerShell\SchedJobs
Taskschd.msc

# this is a rich object
Get-ScheduledJob -Name $name | get-member
Get-ScheduledJob -Name $name | Select *

# We can also see when it will execute
get-jobtrigger $name

#or this way 
Get-ScheduledJob $name | Get-JobTrigger

# let's look at options
Get-ScheduledJobOption -Name $name

#endregion

#region modify the scheduled job
help Set-ScheduledJobOption

#Works best in a pipeline
Get-ScheduledJobOption -Name $name | 
Set-ScheduledJobOption -WakeToRun -passthru | 
Select *Run*

#we can modify the trigger
help set-jobtrigger

Get-JobTrigger $Name
Get-JobTrigger $Name | 
Set-JobTrigger -DaysOfWeek Thursday -Weekly -at 12:00PM -PassThru | 
Select *

#endregion

#region Managing the job

#get the job using the standard job cmdlets after it has run
Get-Job
Get-ScheduledJob

#You can start a scheduled job manually. Notice the new parameter
Start-Job -DefinitionName $Name

#Now what do we see in the job queue?
Get-Job

# there are some new properties
Get-Job -Name $name | Select *

# get job results
Receive-job $name -keep

#results written to disk
dir $jobpath -recurse

#disabling the job
Help Disabled-ScheduledJob
Disable-ScheduledJob $name -WhatIf
Disable-ScheduledJob $name -PassThru

#if I wanted to re-enable
Enable-ScheduledJob $name -WhatIf

#And finally we'll remove the scheduled job
help Unregister-ScheduledJob
get-scheduledjob | Unregister-ScheduledJob -whatif

get-scheduledjob | Unregister-ScheduledJob

Get-ScheduledJob

#also clears job queue
Get-job

#UNREGISTERING ALSO DELETES HISTORY AND OUTPUT
dir $jobpath -recurse

#again, these are the commands you'll use
get-command -module PSScheduledJob

#endregion

