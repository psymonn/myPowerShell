# demo prep...
<#
cd $home
rmdir backups -force -recurse
ipmo pscx
function global:copy-toExpensiveOffsiteStorage{ process { $input | %{ "`$`$`$ copying $_ to expensive offsite storage `$`$`$" } } }

cls
#>
<#
    take a look at this function and see if you can determine what it's output will be
#>
#@
function get-numbers {
    1
    2
    3
    return 4
    5
}
#@

# got it?  guess what the output is before I hit enter here...
get-numbers

# 1,2,3,4

<#
    PowerShell functions are gabby - that is, they really like to output things to the pipeline
    
    this is a remarkably unique behavior - not many other languages exist that
    consider a value on its own to be output from a function

    but this is a huge part of what makes powershell so awesome.  it lets you create little 
    tools that fit together into more complex pipelines that accomplish amazing things

    e.g.
#>

get-numbers | sort -Descending
get-numbers | sort -Descending | clip
notepad

cls

<#
    however this can lead to some really bad side-effects if you're not careful

    if you call a cmdlet that returns an object from your function, that object
    will be sent to the pipeline, and the results could be anything from 
    unanticipated errors to system failure

    for instance, look at this function
#>
#@
function backup-project{
    push-location $home
    mkdir backups -force
    write-zip ./documents/project "./backups/mybackup$((get-date).ticks).zip"
    pop-location
}
#@

<#
    pretty straightforward: create a backup folder, then zip a project folder into that backup folder

    So, what gets output from this function?  if you're familiar with the PSCX module you
    probably know that write-zip will output the FileInfo for the created zip file
#>

backup-project

<#
    but LO!  the output from backup-project includes the created backups folder as well...

    the mkdir (new-item) cmdlet outputs the item it creates to the pipeline.  in this sense,
    the mkdir is "polluting" our pipeline with output we don't want.

    Image what would happen if we used backup-project in this pipeline below
    the entire backup directory could potentially be sent to our expensive Azure
    storage, which isn't really what we intend
#>

backup-project | copy-toExpensiveOffsiteStorage

cls

<#
    so what do we do?  we need to create the backup folder if it doesn't exist.

    well, we need to do something with the output of mkdir, and we have a few options

    first, we can pipe the output to the out-null cmdlet:
#>
mkdir tmp | out-null

#out-null simply swallows anything coming out of the current pipeline

# you can also "capture" the output in a local variable to prevent it from getting into the pipeline:
$d = mkdir tmp2

# for instance, here is how you would fix our backup-project function:
#@
function backup-project{
    push-location $home
    mkdir backups -force | out-null
    write-zip ./documents/project "./backups/mybackup$((get-date).ticks).zip"
    pop-location
}
#@

#now the fuction only outputs the zip file object, and not the backup directory
backup-project | copy-toExpensiveOffsiteStorage