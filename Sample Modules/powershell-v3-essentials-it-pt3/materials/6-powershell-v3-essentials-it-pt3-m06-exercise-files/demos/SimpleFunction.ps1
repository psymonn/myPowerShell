#requires -version 3.0

Function Get-FolderData {

Param (
[string]$Path=".",
[datetime]$Cutoff,
[string]$Filter="*.*"
)

#the path might be a . or a PSDrive shortcut so get the complete path
$Folder = Get-Item -Path $path

#Display a status message. 
Write-Host "Getting file data from $Folder for $Filter" -ForegroundColor Green

#if $cutoff is specified, find the files last modified since the cutoff date.
if ($Cutoff) {
    Write-Host "Getting files modified since $Cutoff" -ForegroundColor Green
    $data = Get-ChildItem -Path $path -Recurse -File -filter $Filter | 
    Where {$_.LastWriteTime -ge $Cutoff}
}
else {
    $data = Get-ChildItem -Path $path -Recurse -File -filter $Filter
}

#measure the files
Write-Host "Measuring files" -ForegroundColor Green
$stats = $data | Measure-Object -Property length -sum -Minimum -Average -Maximum

#write the result to the pipeline including a property for all of the files
$stats | Select-Object -Property @{Name="Folder";Expression={$Folder}},Count,
@{Name="Smallest";Expression={$_.Minimum}},
@{Name="Largest";Expression={$_.Maximum}},
@{Name="AvgSize";Expression={$_.Average}},
@{Name="TotalSize";Expression={$_.Sum}},
@{Name="Files";Expression={$data}}

} #end of function

