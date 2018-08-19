#requires -version 3.0

#demo file aging report

Get-WmiObject win32_share -comp chi-fp01 -filter "type=0"

#region 365 days

#path is relative to the server
$sharepath = "c:\shares\sales"

$days = {
dir $using:SharePath -recurse | 
Select Fullname,CreationTime,LastWriteTime,
@{Name="Age";Expression={(Get-Date)-$_.LastWriteTime}},
@{Name="Days";Expression={[int]((Get-Date)-$_.LastWriteTime).TotalDays}} |
Where {$_.Days -ge 365} | Sort Days -Descending
}

$data = Invoke-Command $days -computername chi-fp01

$data | Out-GridView

#endregion

#region Aging Buckets

$buckets = {
#get some other properties in case we want to further
#break down each bucket

$files = dir $using:sharepath -recurse | 
Select Fullname,CreationTime,LastWriteTime,Length,
@{Name = "Age";Expression={(Get-Date)-$_.LastWriteTime}},
@{Name = "Days";Expression={[int]((Get-Date)-$_.LastWriteTime).TotalDays}}

$hash= @{
Path = $using:sharepath
'Over'    = ($files | Where {$_.Days -gt 365} | Measure-Object).Count
'365Days' = ($files | Where {$_.Days -gt 180 -AND $_.Days -le 365} | Measure-Object).Count
'180Days' = ($files | Where {$_.Days -gt 90 -AND $_.Days -le 180} | Measure-Object).Count
'90Days'  = ($files | Where {$_.Days -gt 30 -AND $_.Days -le 90} | Measure-Object).Count
'30Days'  = ($files | Where {$_.Days -gt 7 -AND $_.Days -le 30} | Measure-Object).Count
'7Days'   = ($files | Where {$_.Days -gt 0 -AND $_.Days -le 7} | Measure-Object).Count
Total = ($files | Measure-Object).count
}
New-Object -TypeName PSObject -Property $hash | 
Select Path,Total,Over,365Days,180Days,90Days,30Days,7Days
}

#process for all shares on CHI-FP01
$shares = Get-WmiObject win32_share -comp chi-fp01 -filter "type=0"

#create a PSSession to reuse
$fp = New-PSSession -ComputerName CHI-FP01

#define an empty array to hold results
$data=@()

foreach ($share in $shares) {

Write-Host "Analyzing $($share.name) [$sharepath]" -ForegroundColor Green
$sharepath = $share.path

$data += Invoke-Command -ScriptBlock $buckets -Session $FP
}

$data | Where {$_.Total -gt 0} | Sort Total | 
Select Path,Total,Over,*Days

#endregion

