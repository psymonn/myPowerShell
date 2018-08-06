#requires -version 4.0

#pluralsight PowerShell v4 New Features

<#
from the about_common_parameters topic
 1..5 | Foreach-Object -PipelineVariable Left -Process { $_ } |
 Foreach-Object -PV Right -Process { 1..10 }  |
 Foreach-Object -Process { "$Left * $Right = " + ($Left * $Right) } 
#>

$path = '\\chi-fp01\c$\shares'

Get-Childitem -path $Path -Directory -PipelineVariable d -OutVariable dirs | 
foreach -begin { $data=@()  } -process {
 Write-host "Processing $($d.fullname)" -ForegroundColor green
 $data+= Get-ChildItem -path $d.fullname -file -Recurse | 
 Measure-Object -property length -sum -pv m |
 Select @{Name="Path";Expression={$d.Fullname}},
 @{Name="LastModified";Expression={$d.lastWriteTime}},
 @{Name="Name";Expression={$d.Name}},
 @{Name="Files";Expression={$m.count}},
 @{Name="SizeKB";Expression={[math]::Round($m.sum/1kb,2)}}
} -end {
 $data
 Write-Host "Processed $($dirs.count) top level folders in $Path" -ForegroundColor Cyan
}

