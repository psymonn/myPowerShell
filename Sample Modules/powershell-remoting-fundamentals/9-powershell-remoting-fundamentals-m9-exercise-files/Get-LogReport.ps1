
Param([int]$Latest = 100)

#get all logs except Security
$logs = get-eventlog -list | where {$_.log -NE 'SECURITY' -AND $_.Entries.count -gt 0}

foreach ($log in $logs.log ) {
    Get-EventLog -log $log -Newest $Latest | 
    Group-Object -Property Source -NoElement | 
    Select @{Name = "LogName"; Expression = {$Log}},Count,
    @{Name="Source";Expression = {$_.Name}},
    @{Name = "Computername"; Expression = {$env:COMPUTERNAME}}
}




