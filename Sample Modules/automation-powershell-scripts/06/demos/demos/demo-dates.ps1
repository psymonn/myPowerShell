
$now = Get-Date
$now | get-member
#you can use any of these properties
$now | select *
$now.dayOfWeek
cls
#format
$now.ToShortDateString()
$now.ToShortTimestdString()
$now.ToUniversalTime()

#get custom formatting
#case sensitive
Get-Date -Format ddMMyyyy
Get-Date -Format ddMMyyyy_hhmmss

cls

#calculate
$now.AddDays(42)
$now.AddHours(500)
#or go backwards
$now.AddDays(-60)

#treat as a date
"6/1/2018 9:10am" -as [datetime]
Get-Date "6/1/2018 9:10AM"

cls

#example
dir \\srv1\public -File
$cutoff = (Get-Date).AddDays(-180).Date
dir \\srv1\public -File | Where {$_.LastWriteTime -le $cutoff }

cls